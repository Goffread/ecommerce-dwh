import pathlib
import csv
import sys
import logging
from etl.db_connection import get_connection
from psycopg import sql
from etl.hash_and_clean import file_sha256, clean_row

logger = logging.getLogger(__name__)
LOAD_JOURNAL = 'raw.load_journal'

class FileWasChangedError(Exception):
    pass

def read_csv(path):
    with open(path, encoding='utf-8', newline='') as f:
        reader = csv.reader(f)
        header = next(reader)
        rows = [row for row in reader]
        rows_num = len(rows)
        return header, rows, rows_num

def load_file(conn, path, table):
    file_hash = file_sha256(path)
    file_name = path.name
    header, rows, rows_num = read_csv(path)
    

    with conn.transaction():
        with conn.cursor() as cur:
            cur.execute(
                sql.SQL("""
                    SELECT hash_sum
                    FROM {}
                    WHERE file_name = %s
                """).format(
                    sql.Identifier(*LOAD_JOURNAL.split('.'))),
                (file_name,)
            )
            existing_hashes = cur.fetchall()

        if any(row[0] == file_hash for row in existing_hashes):
            return logger.info("File %s skipped", file_name)

        if existing_hashes:
            raise FileWasChangedError(
                logger.error("File %s exists, but with another data", file_name)
            )

        with conn.cursor() as cur:
            cur.execute(
                sql.SQL(
                    "INSERT INTO {} ({}) VALUES (%s, %s, %s) RETURNING log_id"
                ).format(sql.Identifier(*LOAD_JOURNAL.split('.')),
                         sql.SQL('file_name, hash_sum, rows_num')),
                (file_name, file_hash, rows_num)
            )
            log_id = cur.fetchone()[0]

        q = sql.SQL("COPY {} ({}) FROM STDIN").format(
            sql.Identifier(*table.split('.')),
            sql.SQL(", ").join(map(sql.Identifier, header + ['log_id']))
        )

        with conn.cursor() as cur:
            with cur.copy(q) as copy:
                for row in rows:
                    copy.write_row(clean_row(row) + [log_id])
    
    return logger.info("File %s loaded to %s", (file_name, table))



if __name__ == '__main__':
    logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
    )
    try:
        with get_connection() as conn:
            files = ['orders', 'customers', 'order_items', 
                    'order_payments', 'products']
            any_error = False
            path = pathlib.Path(__file__).resolve().parent.parent/'data'
            for file in files:
                file_path = path / f"{file}.csv"
                table = f"raw.{file}"
                try:
                    load_file(conn, file_path, table)
                except Exception as e:
                    logger.info("Error %s with file %s", (e, file_path))
                    any_error = True
            if any_error:
                sys.exit(1)
    except Exception as e:
        logger.error("Error %s with connection", e)
        sys.exit(1)
