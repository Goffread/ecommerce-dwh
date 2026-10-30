import csv
import pathlib
import sys

def count_records(path):
    with open(path, 'r', encoding='utf-8', newline='') as f:
        reader = csv.reader(f) 
        header = next(reader, None)
        if header is None:
            raise ValueError(f'Файл {f.name} пустой')
        rows_number = sum(1 for _ in reader)
        return (len(header), rows_number)

if __name__ == '__main__':
    path_data = pathlib.Path(__file__).resolve().parent.parent/'data'
    path_glob = sorted(path_data.glob("*.csv"))
    if path_glob:
        for path in path_glob:
            columns, rows = count_records(path)
            print(f"File: {path.name}, column num: {columns}, row num: {rows}")
    else:
        print(f'В папке {path_data} нет файлов .csv')
        sys.exit(1)