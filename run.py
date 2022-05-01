
from lib2to3.pgen2 import driver
import sys
from flask import Flask, flash, url_for,redirect,render_template,request
from flask_mysqldb import MySQL


app=Flask(__name__)


app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
# app.config['MYSQL_PASSWORD'] = '12345'
app.config['MYSQL_PASSWORD'] = 'Diya@1204'
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
             
        cur.execute("SELECT phoneNo,pwd FROM USER where phoneNo="+mobileno)
        rows=cur.fetchall()
        
        for i in rows:
            if (mobileno == i[0]) and (pwd == i[1]):
                
                return redirect(url_for('ulogged', phoneno=mobileno,password=pwd))
        
        cur.close()
       
    return 'failure'

@app.route('/driverlogin',methods=['POST','GET'])
def dlogin():
    if request.method == 'POST':
        
        driverlogin = request.form
        mobileno= driverlogin['phone']
        pwd = driverlogin['pwd']

        cur = mysql.connection.cursor()
        
        cur.execute("SELECT phoneNo,password FROM DRIVER where phoneNo="+mobileno)
        rows=cur.fetchall()
        
        for i in rows:
            if mobileno == i[0] and pwd == i[1]:
                arr={mobileno,pwd}
                
                # return redirect(url_for('driverlogged'))
                return redirect(url_for('dlogged', phoneno=mobileno,password=pwd))
        
        cur.close()
       
    return 'failure'

@app.route('/driverlogged')
def dlogged():
    phoneno= request.args['phoneno']
    pwd=request.args['password']
    cur = mysql.connection.cursor()
    cur.execute('Select driverID, name, age, gender, phoneNo, totalAmountEarned, ratings, vehicleID from Driver where phoneNo=%s and password=%s;',(phoneno,pwd))
    rows=cur.fetchone()
    cur.close()
    

    return render_template("driverprofile.html",driverID=rows[0], name=rows[1],age=rows[2], gender=rows[3],phoneNo=rows[4],totalAmountEarned=rows[5],ratings=rows[6],vehicleID=rows[7])

@app.route('/userlogged')
def ulogged():
    phoneno= request.args['phoneno']
    pwd=request.args['password']
    cur = mysql.connection.cursor()
    cur.execute('Select userID, name, phoneNo , age, gender from User where phoneNo=%s and pwd=%s;',(phoneno,pwd))
    rows=cur.fetchone()
    cur.close()
    

    return render_template("profile.html", userID=rows[0], name=rows[1],phoneNo=rows[2] ,age=rows[3], gender=rows[4])




@app.route('/driversign',methods=['POST','GET'])
def dsign():

    if request.method=='POST':
        driversign=request.form
        pwd=driversign['pwd']
        name=driversign['fname']
        phone=driversign['phone']
        year=2022-int(driversign['birthday'][0:4])        
        age=str(year)
        gender=driversign['gender']
        licenseno=driversign['licenseNo']  
        cur = mysql.connection.cursor()

        cur.execute("select count(*) from USER")
        num=str(cur.fetchall()[0][0]+1)

        # cur.execute("select vehicleID from Vehicle not in(select vehicleID from DRIVER")
        # vehicleID=cur.fetchall()[0][0]


        
        gender=gender[:1]
        cur.execute("insert into DRIVER (driverID, name, age, gender, phoneNo, totalAmountEarned, ratings, vehicleID, password) values (%s, %s, %s, %s, %s, '1', '1',%s , %s)",(1011,name,age,gender,phone,3,pwd))


        mysql.connection.commit()
        cur.close()

        # flash('You were successfully signed up')
        return render_template('index.html')
    return 'hatt'  
    

@app.route('/customersign',methods=['POST','GET'])
def csign():

    if request.method=='POST':
        usersign=request.form
        pwd=usersign['pwd']
        name=usersign['fname']
        phone=usersign['phone']
        year=2022-int(usersign['birthday'][0:4])        
        age=str(year)
        gender=usersign['gender']

        cur = mysql.connection.cursor()
        cur.execute("select count(*) from USER")
        num=str(cur.fetchall()[0][0]+1)

        cur = mysql.connection.cursor()
        
        gender=gender[:1]
        cur.execute("insert into USER (userID, name, phoneNo, age, gender, pwd) values (%s, %s, %s, %s, %s, %s)",(num,name,phone,age,gender,pwd))

        mysql.connection.commit()
        cur.close()
        
        
        return render_template('index.html')

        
    return 'hatt'  
    


   


if __name__=='__main__':
    app.run(debug=True)