from flask import Flask,render_template,redirect,request,session,flash
import re


app=Flask(__name__)

app.secret_key="2342asfkjawesld234kfjsld123111"


All_user=[]
now_user=0

EMAIL_REGEX=re.compile(r'^[a-zA-Z0-9\.\+_-]+@[a-zA-Z0-9\._-]+\.[a-zA-Z]*$')


class account:
	def __init__ (self):
		self.number= None
		self.money=None
		self.history=None

class user_format(account):
    def __init__(self,name,Id, email, password):
    	account.__init__(self)
        self.name=name
        self.Id=Id
        self.email=email
        self.password=password


All_user.append(user_format("han", "hans", "han@naver.com", "1111"))

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

		All_user.append(user_format(new_name,new_Id,new_email,new_password) ) 

		return redirect("/")

@app.route('/login', methods=['POST'])
def login():
	login_id=request.form['id']
	login_password=request.form['password']

	print (len(All_user))

	num=0

	for i in All_user:
		if i.Id==login_id and i.password==login_password :
			global now_user
			now_user=num
			return render_template('/home.html')
		++num
	flash('invaild input ! ')
	return redirect("/")

@app.route('/logout', methods=['POST'])
def logout():
	return redirect("/")

@app.route('/mybank', methods=['POST'])
def mybank():
	return render_template("/my_bank.html")

@app.route('/makebank', methods=['POST'])
def makebank():
	return render_template("/make_account.html")

@app.route('/checkbank', methods=['POST'])
def checkbank():
	return render_template("/check_bank.html", my_bank=All_user[now_user])

@app.route('/transferbank', methods=['POST'])
def transferbank():
	return render_template("/make_account.html")


if __name__ == "__main__":
    app.run(port=5000, debug=True)