sudo apt-get update
sudo apt-get install python3  awscli wget unzip python3-pip -y
sudo pip3 install Flask

# Start the Flask App.
cd flask-spa
python3 main.py &
