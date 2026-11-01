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
            try:
                columns, rows = count_records(path)
            except ValueError as e:
                print(e)
                sys.exit(1)
            print(f"File: {path.name}, column num: {columns}, row num: {rows}")
    else:
        if path_data.is_dir():
            print(f'В папке {path_data} нет файлов .csv')
        else:
            print(f'Не существует папки {path_data}')
        sys.exit(1)
