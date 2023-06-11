import os
import time
import subprocess
# import mysql.connector
from pyrogram import Client
from config import *



# Function to perform database backup
def backup_database():
    # Generate a timestamp for the backup file
    timestamp = time.strftime("%Y%m%d-%H%M%S")
    backup_file = f"database_backup_{timestamp}.sql"

    # Construct the mysqldump command
    command = f"mysqldump -h {mysql_host} -u {mysql_user} -p{mysql_password} {mysql_database} > {backup_file}"

    # Execute the command
    subprocess.run(command, shell=True)

    # Send the backup file to Telegram
    with Client("secure swtich",api_id=api_id,api_hash=api_hash,bot_token=bot_token) as bot:
        bot.send_document(chat_id=bot_chat_id, document=backup_file)

    # Delete the backup file
    os.remove(backup_file)

# Main function to schedule backups
def main():
    while True:
        try:
            # Perform the database backup
            backup_database()
            print("Backup sent successfully.")
        except Exception as e:
            print(f"Error: {e}")

        # Wait for an hour
        time.sleep(3600)

if __name__ == '__main__':
    main()
