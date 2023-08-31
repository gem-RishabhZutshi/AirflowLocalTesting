from airflow import DAG
from airflow.operators import BashOperator
from datetime import datetime, timedelta

# Define default_args for the DAG
default_args = {
    'owner': 'random_man',
    'depends_on_past': False,
    'start_date': datetime(2023, 8, 31),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Create a DAG instance
dag = DAG(
    'hello_world_dag',
    default_args=default_args,
    schedule_interval=None,  # Set to None to run manually or set your schedule_interval
    catchup=False
)

# Define a Bash command to print "Hello, World!"
bash_command = "echo 'Hello, World!'"

# Create a BashOperator to execute the command
hello_world_task = BashOperator(
    task_id='hello_world_task',
    bash_command=bash_command,
    dag=dag
)
