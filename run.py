
from lib2to3.pgen2 import driver
from flask import Flask, url_for,redirect,render_template,request
from flask_mysqldb import MySQL


app=Flask(__name__)


app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '12345'
app.config['MYSQL_DB'] = 'ULA'
mysql = MySQL(app)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/customerlogin',methods=['POST','GET'])
def clogin():
    if request.method == 'POST':
        
        customerlogin = request.form
        mobileno= customerlogin['phone']
        pwd = customerlogin['pwd']

        cur = mysql.connection.cursor()
             
        cur.execute("SELECT pwd FROM USER where phoneNo="+mobileno)
        rows=cur.fetchall()
        
        for i in rows:
            if pwd == i[0]:
            
                return 'success'
        
        cur.close()
       
    return 'failure'

@app.route('/driverlogin',methods=['POST','GET'])
def dlogin():
    if request.method == 'POST':
        
        driverlogin = request.form
        mobileno= driverlogin['phone']
        pwd = driverlogin['pwd']

        cur = mysql.connection.cursor()
        
        cur.execute("SELECT pwd FROM DRIVER where phoneNo="+mobileno)
        rows=cur.fetchall()
        
        for i in rows:
            if pwd == i[0]:
            
                return 'success'
        
        cur.close()
       
    return 'failure'

@app.route('/driversign',methods=['POST','GET'])
def dsign():

    if request.method=='POST':
        driversign=request.form
        pwd=driversign['pwd']
        name=driversign['fname']
        phone=driversign['phone']
        age=50
        gender=driversign['gender']
        licenseno=driversign['licenseNo']  
        cur = mysql.connection.cursor()
        
        cur.execute("insert into DRIVER (driverID, name, age, gender, phoneNo, totalAmountEarned, ratings, vehicleID, password) values (1, %s, %d, %s, %s, 0, 0, NA, %s)",(name,age,gender,phone,pwd))

        mysql.connection.commit()
        cur.close()

        return 'success'
    return 'hatt'  
    


   


if __name__=='__main__':
    app.run(debug=True)