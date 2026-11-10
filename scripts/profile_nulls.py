import csv
import pathlib
import sys
from collections import Counter

def count_empty_values(path):
    with open(path, encoding='utf-8', newline='') as f:
        reader = csv.DictReader(f)
        c = Counter()
        rows_num = 0
        for row in reader:
            rows_num += 1
            for k, v in row.items():
                if not v:
                    c[k] += 1
    return c, rows_num

if __name__ == '__main__':

    for file in ('orders.csv', 'customers.csv'):
        file_path = pathlib.Path(__file__).resolve().parent.parent/'data'/file
        try:    
            file_counter, rows_num = count_empty_values(file_path)
            print(f'В файле {file_path}: {rows_num} строк')
            for k, v in file_counter.items():
                print(f"В столбце {k}: {v} пустых значений")
            if not file_counter:
                print('Нет пустых значений')
            print('-' * 30)
        except (FileNotFoundError, UnicodeDecodeError) as e:
            print(e)
            sys.exit(1)