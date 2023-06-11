#!/bin/bash

# Create the configuration file
read -p "Enter your Telegram API ID: " api_id
read -p "Enter your Telegram API hash: " api_hash
read -p "Enter your Telegram bot token: " bot_token
read -p "Enter your Telegram chat ID: " chat_id
read -p "Enter your MySQL host (default: localhost): " -i "localhost" mysql_host
read -p "Enter your MySQL username: " mysql_user
read -p "Enter your MySQL password: " mysql_password
read -p "Enter your MySQL database name: " mysql_database



# Create the configuration file
echo "api_id = $api_id
api_hash = '$api_hash'
bot_token = '$bot_token'
bot_chat_id = '$chat_id'
mysql_host = '$mysql_host'
mysql_user = '$mysql_user'
mysql_password = '$mysql_password'
mysql_database = '$mysql_database'" > config.py


#install pip
apt install python3-pip
# Install dependencies
pip3 install -r requirements.txt

# Create a systemd service unit file
echo "[Unit]
Description=Telegram Bot
After=network.target

[Service]
User=$USER
WorkingDirectory=$(pwd)
ExecStart=/usr/bin/python3 $(pwd)/telegram_bot.py
Restart=always

[Install]
WantedBy=multi-user.target" > telegram_bot.service

# Move the service unit file to systemd directory
sudo mv telegram_bot.service /etc/systemd/system/

# Reload systemd manager configuration
sudo systemctl daemon-reload

# Enable and start the service
sudo systemctl enable telegram_bot.service
sudo systemctl start telegram_bot.service

# Display service status
sudo systemctl status telegram_bot.service
