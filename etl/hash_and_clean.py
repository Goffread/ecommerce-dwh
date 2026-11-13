import hashlib

def file_sha256(path):
    h = hashlib.sha256()
    with open(path, 'rb') as f:
        while chunk := f.read(4096):
            h.update(chunk)
    return h.hexdigest()

def clean_row(row):
    new_row = [v if v != "" else None for v in row]
    return new_row
