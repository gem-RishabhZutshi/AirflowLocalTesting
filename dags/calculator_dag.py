from datetime import datetime
from airflow import DAG
from airflow.operators.python_operator import PythonOperator

def add_numbers():
    num1 = 5
    num2 = 3
    result = num1 + num2
    print(f"Addition: {num1} + {num2} = {result}")

def subtract_numbers():
    num1 = 5
    num2 = 3
    result = num1 - num2
    print(f"Subtraction: {num1} - {num2} = {result}")

def multiply_numbers():
    num1 = 5
    num2 = 3
    result = num1 * num2
    print(f"Multiplication: {num1} * {num2} = {result}")

def divide_numbers():
    num1 = 6
    num2 = 2
    result = num1 / num2
    print(f"Division: {num1} / {num2} = {result}")

default_args = {
    'owner': 'your_name',
    'start_date': datetime(2023, 9, 1),
    'depends_on_past': False,
    'retries': 1,
}

dag = DAG(
    'calculator_dag',
    default_args=default_args,
    description='A simple calculator DAG',
    schedule_interval=None,  # This DAG is not scheduled, so it needs to be triggered manually
)

add_task = PythonOperator(
    task_id='add_numbers_task',
    python_callable=add_numbers,
    dag=dag,
)

subtract_task = PythonOperator(
    task_id='subtract_numbers_task',
    python_callable=subtract_numbers,
    dag=dag,
)

multiply_task = PythonOperator(
    task_id='multiply_numbers_task',
    python_callable=multiply_numbers,
    dag=dag,
)

divide_task = PythonOperator(
    task_id='divide_numbers_task',
    python_callable=divide_numbers,
    dag=dag,
)

# Define the task dependencies
add_task >> subtract_task >> multiply_task >> divide_task
