from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from datetime import datetime

# Define default_args dictionary
default_args = {
    'owner': 'your_name',
    'start_date': datetime(2023, 9, 1),
    'retries': 1,
}

# Create a DAG instance
dag = DAG(
    'hello_user_dag',
    default_args=default_args,
    schedule_interval=None,  # Set to None to disable automatic scheduling
    catchup=False,  # If set to True, backfill will run for missed intervals
)

# Define a Python function to print "HELLO USER!"
def print_hello_user():
    print("HELLO USER!")

# Create a PythonOperator to execute the print_hello_user function
task_hello_user = PythonOperator(
    task_id='task_hello_user',
    python_callable=print_hello_user,
    dag=dag,
)

# Set the task dependencies
task_hello_user

if __name__ == "__main__":
    dag.cli()
