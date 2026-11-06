import os
import psycopg
import sys
from dotenv import load_dotenv

class ConfigError(Exception):
    pass

class ConnectTimeout(Exception):
    pass

load_dotenv()
CONNECT_TIMEOUT = 3 #seconds

def read_config():
    env_names = ['PORT', 'DB', 'USER', 'PASSWORD']
    missing_env_name = []
    result = {}

    for name in env_names:
        name = f'POSTGRES_{name}'
        value = os.environ.get(name)
        if not value:
            missing_env_name.append(name)
        else:
            result[name] = value

    if missing_env_name:
        raise ConfigError(f"Не заданы переменные окружения: {missing_env_name}")
    return result

def get_connection():
    host = os.environ.get("POSTGRES_HOST", '127.0.0.1')
    config = read_config()
    port = config['POSTGRES_PORT']
    dbname = config['POSTGRES_DB']
    user = config['POSTGRES_USER']
    password = config['POSTGRES_PASSWORD']

    try:
        conn = psycopg.connect(host=host, port=port, dbname=dbname, user=user, 
                               password=password, connect_timeout=CONNECT_TIMEOUT)
    except psycopg.errors.ConnectionTimeout:
        raise ConnectTimeout(f"Время ожидания подключения истекло\nХост: {host}, Порт: {port}")
    return conn 

if __name__ == '__main__':
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT current_database(), current_user;")
                print(cur.fetchone())

    except ConfigError as e:
        print(e)
        sys.exit(1)
    except ConnectTimeout as c:
        print(c)
        sys.exit(1)
