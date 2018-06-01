from flask import Flask,render_template,redirect,request,session,flash
import re
import pymysql


conn=pymysql.connect(
	host='localhost',
	user='root',
	password='a',
	db='user',
	charset='utf8'
)

curs=conn.cursor()


app=Flask(__name__)

app.secret_key="2342asfkjawesld234kfjsld123111"


now_user=""

EMAIL_REGEX=re.compile(r'^[a-zA-Z0-9\.\+_-]+@[a-zA-Z0-9\._-]+\.[a-zA-Z]*$')


@app.route('/',methods=['GET'])
def index():
	return render_template("login.html")

@app.route('/register', methods=['GET'])
def init_register():
	return render_template("register.html")

@app.route('/register', methods=['POST'])
def register():
	if len(request.form['email'])<1:
		flash('Email cannot be blank!')
		return redirect('/register')

	elif not EMAIL_REGEX.match(request.form['email']):
		flash('Invalid Email Address!')
		return redirect('/register')

	elif len(request.form['name'])<1:
		flash('first_name cannot be blank!')
		return redirect('/register')

	elif len(request.form['password'])<3:
		flash('password short! password is more than 8 character ')
		return redirect('/register')

	elif request.form['password_confirmation'] != request.form['password']:
		flash('password not match ! ')
		return redirect('/register')

	else:
		new_name=request.form['name']
		new_Id=request.form['id']
		new_email=request.form['email']
		new_password=request.form['password']

		sql="INSERT INTO userinfor (name, id, pw, email) VALUES('{}', '{}','{}','{}')".format(new_name, new_Id, new_password, new_email)
		curs.execute(sql)

		return redirect("/")

@app.route('/login', methods=['POST'])
def login():
	login_id=request.form['id']
	login_password=request.form['password']

	sql="SELECT name FROM userinfor WHERE id='{}' AND pw='{}'".format(login_id, login_password)
	curs.execute(sql)
	login_re=curs.fetchall()

	if not login_re :
		flash('invaild input ! ')
		return redirect("/")

	global now_user
	now_user=login_re

	return render_template('/home.html')

@app.route('/logout', methods=['POST'])
def logout():
	return redirect("/")

@app.route('/mybank', methods=['POST'])
def mybank():
	global now_user
	return render_template("/my_bank.html")

@app.route('/makebank', methods=['POST'])
def makebank():
	return render_template("/make_account.html")

@app.route('/checkbank', methods=['POST'])
def checkbank():
	return render_template("/check_bank.html")

@app.route('/transferbank', methods=['POST'])
def transferbank():
	return render_template("/make_account.html")


if __name__ == "__main__":
    app.run(port=5000, debug=True)