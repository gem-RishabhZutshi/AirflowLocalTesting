from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

def print_welcome_to_airflow():
    print("WELCOME TO AIRFLOW")

default_args = {
    'owner': 'your_name',
    'start_date': datetime(2023, 9, 1),
    'depends_on_past': False,
    'retries': 1,
}

dag = DAG(
    'welcome_to_airflow_dag',
    default_args=default_args,
    description='A DAG that prints "WELCOME TO AIRFLOW"',
    schedule_interval=None,  # This DAG is not scheduled, so it needs to be triggered manually
)

print_welcome_to_airflow_task = PythonOperator(
    task_id='print_welcome_to_airflow_task',
    python_callable=print_welcome_to_airflow,
    dag=dag,
)
