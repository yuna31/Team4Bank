from flask import Flask,render_template,redirect,request,session,flash
import re
import pymysql
import datetime


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
now_user_id=""
choice_account=""
now_accounts=""

EMAIL_REGEX=re.compile(r'^[a-zA-Z0-9\.\+_-]+@[a-zA-Z0-9\._-]+\.[a-zA-Z]*$')

class transfer_class:
	def __init__(self, date, what, who, money, sum):
		self.date=date
		self.what=what
		self.who=who
		self.money=money
		self.sum=sum

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
		print (request.form['email'])
		print (type(request.form['email']))
		new_name=request.form['name']
		new_Id=request.form['id']
		new_email=request.form['email']
		new_password=request.form['password']

		sql="INSERT INTO userinfor (name, id, pw, email) VALUES('{}', '{}','{}','{}')".format(new_name, new_Id, new_password, new_email)
		curs.execute(sql)
		conn.commit();

		return redirect("/")

@app.route('/login', methods=['POST'])
def login():
	login_id=request.form['id']
	login_password=request.form['password']

	sql="SELECT * FROM userinfor WHERE id='{}' AND pw='{}'".format(login_id, login_password)

	print (sql)
	curs.execute(sql)
	login_re=curs.fetchall()

	if not login_re :
		flash('invaild input ! ')
		return redirect("/")

	global now_user
	global now_user_id
	now_user=login_re[0][1]
	now_user_id=login_re[0][2]

	return render_template('/home.html',now_user_name=now_user)

@app.route('/logout', methods=['POST'])
def logout():
	return redirect("/")

@app.route('/mybank', methods=['POST'])
def mybank():
	global now_user_id
	global now_accounts
	sql="SELECT * FROM accountinfor WHERE id='{}'".format(now_user_id)
	curs.execute(sql)
	now_accounts=curs.fetchall()

	return render_template("/my_bank.html", now_accounts=now_accounts)

@app.route('/account_work', methods=['GET'])
def account_work():
	global choice_account
	choice_account= request.args.get('account')
	global now_user
	if request.args.get('transfer') == 'transfer' :
		return render_template("/transfer.html",now_user_name=now_user,choice_account=choice_account)
	elif request.args.get('history') == 'history' :
		transfer_infor=[]
		sql="SELECT * FROM transferinfor WHERE sender_account='{}'".format(choice_account)
		curs.execute(sql)
		t_infor=curs.fetchall()
	
		for t in t_infor :
			transfer_infor.append(transfer_class(t[1], "send", t[3], t[4], t[8]))

		sql="SELECT * FROM transferinfor WHERE receiver_account='{}'".format(choice_account)
		curs.execute(sql)
		t_infor=curs.fetchall()
	
		for t in t_infor :
			transfer_infor.append(transfer_class(t[1], "receive", t[5], t[4], t[9]))

		return render_template("/history.html", now_user_name=now_user, choice_account=choice_account, transfer_infor=transfer_infor)

@app.route('/send_money', methods=['POST'])
def send_money():
	global choice_account
	global now_user

	sql="SELECT * FROM accountinfor WHERE accountid='{}'".format(choice_account)
	curs.execute(sql)
	check_account=curs.fetchall()
	if  check_account[0][3] != request.form['password'] :
		return render_template("transfer.html")
	
	if request.form['send_money'] < 1 :
		return render_template("transfer.html")

	if request.form['receiver_account'] < 1 :
		return render_template("transfer.html")

	want_send_money=int(request.form['send_money'])
	if  check_account[0][4] < want_send_money :
		return render_template("transfer.html")

	receiver_account=request.form['receiver_account']

	sql="SELECT * FROM accountinfor WHERE accountid='{}'".format(receiver_account)
	curs.execute(sql)
	sql_receiver_account=curs.fetchall()

	print (sql_receiver_account)

	if not sql_receiver_account :
		re_receiver_account=receiver_account
		re_receiver='don`t know'
		re_receiver_money=want_send_money
	else :
		re_receiver_account=sql_receiver_account[0][2]
		re_receiver=sql_receiver_account[0][1]
		re_receiver_money=sql_receiver_account[0][4]+want_send_money

		sql="UPDATE accountinfor SET Money={} WHERE accountid='{}'".format(re_receiver_money, re_receiver_account)
		curs.execute(sql)
		conn.commit()


	now=datetime.datetime.now()
	date=now.strftime('%y-%m-%d')
	change_money=check_account[0][4]-want_send_money


	sql="INSERT INTO transferinfor (date, what, sender, receiver, money, receiver_sum, sender_sum, sender_account, receiver_account)VALUES ('{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}')".format(date, 'send',now_user, re_receiver, want_send_money,re_receiver_money, change_money, choice_account, re_receiver_account   )
	curs.execute(sql)
	conn.commit()

	sql="UPDATE accountinfor SET money={} WHERE accountid='{}'".format(change_money, choice_account)
	curs.execute(sql)
	conn.commit()
	global now_accounts

	return render_template("my_bank.html",now_accounts=now_accounts)

@app.route('/go_change_myinfor', methods=['POST'])
def go_change_myinfor():
	return render_template("change_myinfor.html")

@app.route('/change_myinfor', methods=['POST'])
def change_myinfor():
	if request.form['password'] != request.form['re_password'] :
		flash('password not match ! ')
		return render_template("change_myinfor.html")

	if request.form['email'] <1 :
		flash('email is blank ! ')
		return render_template("change_myinfor.html")

	new_password=request.form['password']
	new_email=request.form['email']
	global now_user_id

	sql="UPDATE userinfor SET pw='{}', email='{}' WHERE id='{}'".format(new_password, new_email,now_user_id)
	curs.execute(sql)
	conn.commit()

	global now_accounts

	return render_template("my_bank.html",now_accounts=now_accounts)

@app.route('/myloan', methods=['POST'])
def myloan():
	global now_user_id

	global now_loan_accounts
	sql="SELECT * FROM loan_accountinfor WHERE id='{}'".format(now_user_id)
	curs.execute(sql)
	now_accounts=curs.fetchall()

	return render_template("/my_loan.html", now_loan_accounts=now_loan_accounts)



if __name__ == "__main__":
    app.run(port=5000, debug=True)