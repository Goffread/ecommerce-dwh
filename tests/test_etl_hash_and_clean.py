from etl.hash_and_clean import file_sha256, clean_row

def test_file_sha256(tmp_path):
    p = tmp_path / 'x.txt'
    p.write_bytes(b'abc')
    assert file_sha256(p) == 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad'

def test_file_sha256_identical_files(tmp_path):
    p1 = tmp_path / 'p1.txt'
    p1.write_bytes(b'abc')
    p2 = tmp_path / 'p2.txt'
    p2.write_bytes(b'abc')
    assert file_sha256(p1) == file_sha256(p2)

def test_file_sha256_not_identical_files(tmp_path):
    p1 = tmp_path / 'p1.txt'
    p1.write_bytes(b'abc')
    p2 = tmp_path / 'p2.txt'
    p2.write_bytes(b'abcd')
    assert file_sha256(p1) != file_sha256(p2)

def test_file_sha256_empty_file(tmp_path):
    p = tmp_path / 'x.txt'
    p.write_bytes(b'')
    assert file_sha256(p) == 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'

def test_file_sha256_big_file(tmp_path):
    p = tmp_path / 'x.txt'
    p.write_bytes(b'abc' * 10000)
    assert file_sha256(p) == '13b77af908a78a94f2e21cf8fc137ea16c8020873eeee7b6b96b6b0975555a02'

def test_clean_row_replaces_only_empty_string():
    l = ['', '0', ' ', '123']
    assert clean_row(l) == [None, '0', ' ', '123']

def test_clean_row_does_not_modify_input():
    l1 = ['', '0', ' ', '123']
    l2 = l1[:]
    clean_row(l1)
    assert l1 == l2

def test_clean_row_empty_list():
    l = []
    assert clean_row(l) == []
