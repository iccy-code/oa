EXEFILE = openall.sh
TESTFILE = test.sh

EXEPATH = /bin
EXE = oa

default: install test

install:
	@ if [ -f $(EXEPATH)/$(EXE) ]; then rm $(EXEPATH)/$(EXE); fi
	@ cp $(EXEFILE) $(EXEPATH)/${EXE}
	@ echo "--help"
	@ oa help
	
test:
	@ ./$(TESTFILE)