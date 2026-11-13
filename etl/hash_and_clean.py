import hashlib
import pathlib

def file_sha256(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        while chunk := f.read(4096):
            h.update(chunk)
    return h.hexdigest()

def clean_row(row):
    new_row = [v if v != "" else None for v in row]
    return new_row

if __name__ == '__main__':
    path = pathlib.Path(__file__).resolve().parent.parent/'data'
    file_path = path/'customers.csv'
    file_hash = file_sha256(file_path)
    print(file_hash)