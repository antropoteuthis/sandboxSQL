#! /usr/bin/env python

import re
import MySQLdb

MyConnection = MySQLdb.connect(host="localhost", user='root', passwd='sphaeronectes', db='tentilla')
MyCursor = MyConnection.cursor()
meanadult = open("meanadult.tsv","w")

SQL = str('''SELECT obs_id, species, stage, quantitative.character, attribute, state, source FROM quantitative WHERE attribute='"mean"' AND stage='"adult"';''')
SQLlen = MyCursor.execute(SQL)
AllOut = MyCursor.fetchall()

print "obs_id\tspecies\tstage\tcharacter\tattribute\tstate\tsource"
meanadult.write("obs_id\tspecies\tstage\tcharacter\tattribute\tstate\tsource\n")
for i in range(SQLlen):
	print "%d\t%s\t%s\t%s\t%s\t%f\t%s" % AllOut[i]
	meanadult.write("%d\t%s\t%s\t%s\t%s\t%f\t%s\n" % AllOut[i])

meanadult.close()
MyCursor.close()
MyConnection.close()