#!/usr/bin/env python3.2

import psycopg2
import sys
from sys import argv

if len(argv) != 3:
    print("Potrzeba dokładnie dwóch argumentów: ",argv[0]," [database] [user]",file=sys.stderr)
    sys.exit(1)

connection= psycopg2.connect(database=argv[1], user=argv[2])
cursor=connection.cursor()

cursor.execute("select id,kod from statusy where waga>= 0 order by waga;")
status=cursor.fetchall()

result="select shortname as name"

for t in status:
    result+=", nullif(count(nullif(status="+str(t[0])+",False)),0) as "+t[1]

result+=", count(*) as all";
result+=" from submits full outer join problems p on p.id=problemsid where p.id!=28 group by p.id order by p.name;"

print(result)
