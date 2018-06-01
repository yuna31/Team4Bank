import pymysql

conn=pymysql.connect(
	host='localhost',
	user='root',
	password='a',
	db='db3',
	charset='utf8')

curs=conn.cursor()

sql="INSERT INTO topic (title, description, author) VALUES ('aaa','bbb','cc')"

curs.execute(sql)

sql="select author from topic where id=100"

curs.execute(sql)

rows=curs.fetchall()

if not rows :
	print ("not")


conn.close()