from flask import Flask, url_for,redirect,render_template
from flask_mysqldb import MySQL
import yaml

app=Flask(__name__)



@app.route('/')
def home():
    return render_template('index.html')


if __name__=='__main__':
    app.run(debug=True)