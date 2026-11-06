import os
import psycopg
import sys
from dotenv import load_dotenv

class ConfigError(Exception):
    pass

load_dotenv()

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
    
    return psycopg.connect(host=host, port=port, dbname=dbname, user=user, password=password, connect_timeout=20)

if __name__ == '__main__':
    try:
        with get_connection() as conn:
            with conn.cursor() as cur:
                cur.execute("SELECT current_database(), current_user;")
                print(cur.fetchone())

    except ConfigError as e:
        print(e)
        sys.exit(1)
    except psycopg.errors.ConnectionTimeout as c:
        print('Время ожидания подключения истекло')
        sys.exit(1)
