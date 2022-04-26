from crypt import methods
from flask import Flask, url_for,redirect,render_template,request
from flask_mysqldb import MySQL
import yaml

app=Flask(__name__)

db = yaml.load(open('db.yaml'))
app.config['MYSQL_HOST'] = db['mysql_host']
app.config['MYSQL_USER'] = db['mysql_user']
app.config['MYSQL_PASSWORD'] = db['mysql_password']
app.config['MYSQL_DB'] = db['mysql_db']

mysql = MySQL(app)


@app.route('/',methods=['POST','GET'])
def home():
    if request.method == 'POST':
        
        customerlogin = request.form
        mobileno= customerlogin['mobileno']
        pwd = customerlogin['pwd']

        cur = mysql.connection.cursor()
        check = cur.execute("SELECT * FROM tablename where mobileno="+mobileno+" and pwd="+pwd)
        if check>0:
            return redirect(url_for())
        
        cur.close()
       
    return render_template('index.html')
   


if __name__=='__main__':
    app.run(debug=True)