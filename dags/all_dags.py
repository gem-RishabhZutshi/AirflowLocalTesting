import os
from airflow.models import Variable

env = os.getenv("AIRFLOW_ENVS") or Variable.get("AIRFLOW_ENVS", default_var="dev")
os.environ["env"] = env
CLIENT_ID = os.getenv("CLIENT_ID") or Variable.get("CLIENT_ID")
os.environ["CLIENT_ID"] = CLIENT_ID
CLIENT_SECRET = os.getenv("CLIENT_SECRET") or Variable.get("CLIENT_SECRET")
os.environ["CLIENT_SECRET"] = CLIENT_SECRET
TENANT_ID = os.getenv("TENANT_ID") or Variable.get("TENANT_ID")
os.environ["TENANT_ID"] = TENANT_ID

print(f"Current env: {env}")
print(f"CLIENT_ID: {CLIENT_ID}")
print(f"CLIENT_SECRET: {CLIENT_SECRET}")
print(f"TENANT_ID : {TENANT_ID}")


