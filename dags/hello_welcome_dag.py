from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime

# Define default_args dictionary
default_args = {
    'owner': 'your_name',
    'start_date': datetime(2023, 9, 1),
    'retries': 1,
}

# Create a DAG instance for the "HELLO WELCOME!" DAG
hello_welcome_dag = DAG(
    'hello_welcome_dag',
    default_args=default_args,
    schedule_interval=None,  # Set to None to disable automatic scheduling
    catchup=False,  # If set to True, backfill will run for missed intervals
)

# Define a Python function to print "HELLO WELCOME!"
def print_hello_welcome():
    print("HELLO WELCOME!")

# Create a PythonOperator to execute the print_hello_welcome function
task_hello_welcome = PythonOperator(
    task_id='task_hello_welcome',
    python_callable=print_hello_welcome,
    dag=hello_welcome_dag,
)

task_hello_welcome
