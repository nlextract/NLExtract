import os, sqlite3

filename = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'process.db')
conn = sqlite3.connect(filename)
c = conn.cursor()
c.execute('''CREATE TABLE process(guid text primary key , pid integer)''')
