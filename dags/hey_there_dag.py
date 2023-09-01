from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

def print_hey_there():
    print("HEY THERE")

default_args = {
    'owner': 'your_name',
    'start_date': datetime(2023, 9, 1),
    'depends_on_past': False,
    'retries': 1,
}

dag = DAG(
    'hey_there_dag',
    default_args=default_args,
    description='A DAG that prints "HEY THERE"',
    schedule_interval=None,  
)

print_hey_there_task = PythonOperator(
    task_id='print_hey_there_task',
    python_callable=print_hey_there,
    dag=dag,
)
