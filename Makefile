SHELL = /bin/sh
CC = /usr/bin/time crystal build
BUILD_DIR = build
OUT_FILE = ${BUILD_DIR}/works
SOURCE_FILES = src/works.cr

build_and_test: clean test

clean:
	if [ ! -d "./${BUILD_DIR}" ]; then mkdir "${BUILD_DIR}"; else env echo "cleaning..." && rm -r ${BUILD_DIR}; mkdir "${BUILD_DIR}"; fi

build_test:
	${CC} ${SOURCE_FILES} -o ${OUT_FILE}_test.o --error-trace

test: build_test
	./${OUT_FILE}_test.o

${OUT_FILE}.o:
	${CC} ${SOURCE_FILES} -o ${OUT_FILE}.o --release --no-debug

release: clean ${OUT_FILE}.o
	./${OUT_FILE}.o
