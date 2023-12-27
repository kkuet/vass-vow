import json
import psycopg2
import sqlalchemy
from datetime import datetime

# Replace these values with your PostgreSQL connection details
DATABASE_HOST = "terraform-20231226144046086000000001.ctk2eyggq3hh.eu-north-1.rds.amazonaws.com"
DATABASE_PORT = "5432"
DATABASE_NAME = "test_wg"
DATABASE_USER = "usuario"
DATABASE_PASSWORD = "password"


class File:
    def __init__(self, file_id, name, description, mimetype_id, comment_id, comment_text, created_at):
        self.file_id = file_id
        self.name = name
        self.description = description
        self.mimetype_id = mimetype_id
        self.comment_id = comment_id
        self.comment_text = comment_text
        self.created_at = created_at


def create_connection():
    conn = psycopg2.connect(
        host=DATABASE_HOST,
        port=DATABASE_PORT,
        database=DATABASE_NAME,
        user=DATABASE_USER,
        password=DATABASE_PASSWORD
    )
    return conn


def get_all_files(conn):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM files")
    rows = cursor.fetchall()
    files = [File(*row) for row in rows]
    return files


def get_all_files_by_id(conn,fileid):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM files where file_id = "+fileid)
    rows = cursor.fetchall()
    files = [File(*row) for row in rows]
    return files


def get_all_tests_by_id(conn,fileid):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM tests where test_id = "+fileid)
    rows = cursor.fetchall()
    files = [File(*row) for row in rows]
    return files


def get_all_testequipments_by_id(conn,fileid):
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM testequipment where equipment_id = "+fileid)
    rows = cursor.fetchall()
    files = [File(*row) for row in rows]
    return files


def lambda_handler(event, context):
    conn = create_connection()
    try:
        files = get_all_files(conn)
        response_body = {
            'statusCode': 200,
            'body': json.dumps([file.__dict__ for file in files], default=str)
        }
        return response_body
    except Exception as e:
        response_body = {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
        return response_body
    finally:
        conn.close()


def lambda_handler_by_id(event, context):
    conn = create_connection()
    fileid = event.get('queryStringParameters', {}).get('id')

    try:
        files = get_all_files_by_id(conn,fileid)
        response_body = {
            'statusCode': 200,
            'body': json.dumps([file.__dict__ for file in files], default=str)
        }
        return response_body
    except Exception as e:
        response_body = {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
        return response_body
    finally:
        conn.close()


def lambda_handler_tests_by_id(event, context):
    conn = create_connection()
    testid = event.get('queryStringParameters', {}).get('id')
    try:
        tests = get_all_tests_by_id(conn,testid)
        response_body = {
            'statusCode': 200,
            'body': json.dumps([test.__dict__ for test in tests], default=str)
        }
        return response_body
    except Exception as e:
        response_body = {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
        return response_body
    finally:
        conn.close()

def lambda_handler_testequipments_by_id(event, context):
    conn = create_connection()
    testid = event.get('queryStringParameters', {}).get('id')
    try:
        equipments = get_all_testequipments_by_id(conn,testid)
        response_body = {
            'statusCode': 200,
            'body': json.dumps([equipment.__dict__ for equipment in equipments], default=str)
        }
        return response_body
    except Exception as e:
        response_body = {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
        return response_body
    finally:
        conn.close()

