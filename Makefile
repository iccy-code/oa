EXEFILE = openall.sh
TESTFILE = test.sh

EXEC = /usr/bin/oa

all: install

install:
	@ cp $(EXEFILE) ${EXEC}
	@ oa help
	
test:
	@ sh $(TESTFILE)