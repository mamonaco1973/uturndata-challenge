ls -al /flask
chmod +x /flask/start_flask_app.sh
sudo yum install -y python3-pip
sudo pip3 install -r /flask/requirements.txt
sudo cp /flask/flask_app.service /etc/systemd/system/flask_app.service 
sudo systemctl daemon-reload
sudo systemctl enable flask_app
sudo systemctl start flask_app
sudo systemctl status flask_app
