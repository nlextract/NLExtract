import os,sys
print "CWD: ",os.getcwd()
print "Script: ",sys.argv[0]
print ".EXE: ",os.path.dirname(sys.executable)
print "Script dir: ", os.path.realpath(os.path.dirname(sys.argv[0]))
pathname, scriptname = os.path.split(sys.argv[0])
print "Relative script dir: ",pathname
print "Script dir: ", os.path.abspath(pathname)
