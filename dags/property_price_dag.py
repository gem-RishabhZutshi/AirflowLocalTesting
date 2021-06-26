"""
Code that goes along with the Airflow tutorial located at:
https://github.com/apache/airflow/blob/master/airflow/example_dags/tutorial.py
"""

from airflow import DAG
from airflow.operators.python_operator import PythonVirtualenvOperator
from airflow.operators.dummy_operator import DummyOperator
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2021, 6, 9),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 5,
    'retry_delay': timedelta(minutes=5),
    # 'queue': 'bash_queue',
    # 'pool': 'backfill',
    # 'priority_weight': 10,
    # 'end_date': datetime(2016, 1, 1),
    'schedule_interval': '@daily',
    'concurrency': 1,
    'max_active_runs': 1,
    'schedule_after_task_execution': False,
}


def get_rightmove_prices_run(execution_date, region_code, **kwargs):
    from rightmove_webscraper import RightmoveData
    from pathlib import Path
    import logging
    # region_code = kwargs['region_code']

    logging.info(" get_rightmove_prices_run")
    rightmove_url = f"https://www.rightmove.co.uk/property-to-rent/find.html?locationIdentifier=POSTCODE^{region_code}&radius=5.0&propertyTypes=&mustHave=&dontShow=&furnishTypes=&keywords="
    execution_date_path = f"{execution_date}"
    data_path = "/opt/airflow/data/bronze"
    table_name = "property.csv"
    full_dir = Path(f'{data_path}/{execution_date_path}/')
    full_dir.mkdir(parents=True, exist_ok=True)

    rm = RightmoveData(rightmove_url)
    df_property_prices = rm.get_results
    filename = f"{full_dir}/{table_name}"
    is_file_exists = Path(filename).exists()
    df_property_prices.to_csv(filename, header=not is_file_exists, mode='a' if is_file_exists else 'w')


# should be replaced with human curated data
# SCD
def all_region_code():
    return ['4080771', '4632255',
            '280682', '1475548', '280684']


# '1475549', '280685', '280686',
#            '1328515', '280687', '280688', '4106340', '280690', '1475550', '280691', '280692', '280693',
#            '280694', '1475551'

with DAG('property_prices_dag', default_args=default_args) as dag:
    start_task = DummyOperator(task_id='start')


    def group(number, **kwargs):
        # load the values if needed in the command you plan to execute
        dyn_value = "{{ task_instance.xcom_pull(task_ids='push_func') }}"
        return PythonVirtualenvOperator(
            task_id='get_rightmove_prices_{}'.format(number),
            python_callable=get_rightmove_prices_run,
            requirements=["rightmove-webscraper", "requests==2.22.0", "pandas"],
            system_site_packages=False,
            provide_context=True,
            op_kwargs={'execution_date': '{{ execution_date }}', 'region_code': number}, )


    push_func = PythonVirtualenvOperator(
        task_id='push_func',
        provide_context=True,
        python_callable=all_region_code, )

    end_task = DummyOperator(task_id='end')

    start_task >> push_func

    for region_code in all_region_code():
        push_func >> group(region_code) >> end_task
