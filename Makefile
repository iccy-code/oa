CHMOD = chmod +x
CP = cp
FILE = ./openall.sh
EXE = /bin/oa


default: install

install:
	@ $(CP) $(FILE) $(EXE)
	@ $(CHMOD) $(EXE)
	