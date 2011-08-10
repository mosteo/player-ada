.PHONY: all clean

PARAMS=-Pplayer3_ada -XPlayer3_Ada_Include_Test=No -XPlayer3_Ada_Link=Static_Library

all:
	gprbuild ${PARAMS}

clean:
	gprclean ${PARAMS}
	rm -f obj/* libstatic/* libdynamic/*
