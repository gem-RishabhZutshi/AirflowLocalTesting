import os
from airflow.models import Variable

env = os.getenv("AIRFLOW_ENVS") or Variable.get("AIRFLOW_ENVS", default_var="dev")
os.environ["env"] = env
os.environ["CLIENT_ID"] = os.getenv("CLIENT_ID") or Variable.get("CLIENT_ID")
os.environ["CLIENT_SECRET"] = os.getenv("CLIENT_SECRET") or Variable.get("CLIENT_SECRET")
os.environ["TENANT_ID"] = os.getenv("TENANT_ID") or Variable.get("TENANT_ID")
print(f"Current env: {env}")
