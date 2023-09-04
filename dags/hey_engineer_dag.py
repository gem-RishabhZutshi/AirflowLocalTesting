from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

def print_hey_engineer():
    print("HEY ENGINEER")

default_args = {
    'owner': 'your_name',
    'start_date': datetime(2023, 9, 1),
    'depends_on_past': False,
    'retries': 1,
}

dag = DAG(
    'hey_engineer_dag',
    default_args=default_args,
    description='A DAG that prints "HEY ENGINEER"',
    schedule_interval=None,  # This DAG is not scheduled, so it needs to be triggered manually
)

print_hey_engineer_task = PythonOperator(
    task_id='print_hey_engineer_task',
    python_callable=print_hey_engineer,
    dag=dag,
)

