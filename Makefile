# Basic Makefile for building the necessary infrastructure.

# The default target only builds the backend database.
.PHONY: default
default: database

# Setup directory paths. You can override these on the command line by passing
# Make variables (`make SOURCE_ROOT=... ...`) which you may want to do if you
# are performing an out-of-tree build.
BUILD_ROOT  ?=${PWD}
SOURCE_ROOT ?=${PWD}

# Verbosity setting. Run `make V=1 ...` to display more information.
ifeq (${V},1)
Q:=
else
Q:=@
endif

# Build the backend database.
.PHONY: database
database: ${BUILD_ROOT}/refs.db
${BUILD_ROOT}/refs.db: ${SOURCE_ROOT}/refs.sql |sqlite3
	@echo " [SQL]   $@"
	@# XXX: The strange piping of .exit into sqlite3 is because it doesn't seem to
	@# listen to exit commands from within its init script.
	${Q}echo ".exit" | sqlite3 -init ${SOURCE_ROOT}/refs.sql ${BUILD_ROOT}/refs.db

# Check whether SQLite is installed.
.PHONY: sqlite3
sqlite3:
	@echo " [CHECK] $@"
	${Q}which sqlite3 >/dev/null || { echo "$@ not found." ; exit 1; }

.PHONY: clean
clean:
	@echo " [CLEAN]"
	${Q}rm -f ${BUILD_ROOT}/refs.db
