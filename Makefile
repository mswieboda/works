SHELL = /bin/sh
CC = crystal build
BUILD_DIR = build
OUT_FILE = ${BUILD_DIR}/works.o
SOURCE_FILES = src/works.cr

build_and_run: clean run

clean:
	if [ ! -d "./${BUILD_DIR}" ]; then mkdir "${BUILD_DIR}"; else env echo "cleaning..." && rm -r ${BUILD_DIR}; mkdir "${BUILD_DIR}"; fi

${OUT_FILE}:
	${CC} ${SOURCE_FILES} -o ${OUT_FILE} --error-trace

run: ${OUT_FILE}
	./${OUT_FILE}
