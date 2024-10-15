# GP2 Framework - Git Publish to Workshop

import sys
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
        print(f"Message '{message}' sent successfully!")
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
    command = f'fastgmad update -id "{ADDON_ID}" -addon "{current_folder}" -changes "Built from {git_commit}"'

    try:
        result = subprocess.run(command, shell=True, check=True, text=True, capture_output=True)
        print(f"Output:\n{result.stdout}")

        if 'ERROR:' in result.stdout:
            return False
    except subprocess.CalledProcessError as e:
        print(f"An error occurred:\n{e.stderr}")
        return False
    except FileNotFoundError as e:
        print(f"Command not found:\n{str(e)}")
        return False
    except Exception as e:
        print(f"An unexpected error occurred:\n{str(e)}")
        return False

    return True

# Write .gitversion
with open(".gitversion", 'w') as f:
    dt = datetime.datetime.now()
    f.write(f"{dt.date()}|{dt.strftime('%I:%M %p')}")
    
# Write lua/gp2/version
with open("lua/gp2/version.lua", 'w') as f:
    dt = datetime.datetime.now()
    f.write(f"return 'GP2 Framework {dt.date()}|{dt.strftime('%I:%M %p')}'")

# Publish to Workshop and send webhook to server
if not execute_fastgmad_update(get_latest_git_commit()):
    send_discord_webhook("Failed to publish to workshop")
else:
    send_discord_webhook("Published update to workshop")
