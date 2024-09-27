# GP2 Framework - Git Publish to Workshop

import os
import json
import datetime
import requests
import subprocess
from dotenv import load_dotenv

load_dotenv()

WEBHOOK_URL = os.getenv('WEBHOOK_URL')
ADDON_ID = os.getenv('ADDON_ID')

def send_discord_webhook(message):
    data = {
        "content": message,
    }

    headers = {
        "Content-Type": "application/json"
    }

    response = requests.post(WEBHOOK_URL, data=json.dumps(data), headers=headers)

    if response.status_code == 204:
        print("Message sent successfully!")
    else:
        print(f"Failed to send message: {response.status_code}")
        print(response.json())


def get_latest_git_commit():
    try:
        result = subprocess.run(
            ["git", "rev-parse", "HEAD"],
            check=True, text=True, capture_output=True
        )

        latest_commit_hash = result.stdout.strip()
        return latest_commit_hash
    except subprocess.CalledProcessError as e:
        print(f"An error occurred while retrieving the latest commit:\n\n{e.stderr}")
        return None


def execute_fastgmad_update(git_commit):
    current_folder = os.path.dirname(os.path.abspath(__file__))
    command = f"fastgmad update -id {ADDON_ID} -addon {current_folder} -changes \"Built from {git_commit}\""

    try:
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        print(f"Output:\n{result.stdout}")
    except subprocess.CalledProcessError as e:
        print(f"An error occurred:\n{e.stderr}")

# Write .gitversion
with open(".gitversion", 'w') as f:
    dt = datetime.datetime.now()
    f.write(f"{dt.date()}|{dt.strftime('%I:%M %p')}")

# Publish to Workshop
execute_fastgmad_update(get_latest_git_commit())

# Send webhook to server
send_discord_webhook("Published update to workshop")