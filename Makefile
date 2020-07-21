CHMOD = chmod +x
CP = cp
ELFFILE = ./openall.sh
TESTFILE = ./test.sh
EXE = /bin/oa

default: install test

install:
	# @ if [ -x $(EXE) ]; then rm $(EXE); fi
	@ $(CP) $(ELFFILE) $(EXE)
	@ $(CHMOD) $(EXE)
	
test:
	@ $(CHMOD) $(TESTFILE)
	@ ./$(TESTFILE)