# Address-sanitizer library
ASAN_FLAGS := -lasan
ifneq ($(OS),Windows_NT)
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Darwin)
		# macOS requires different a flag
		ASAN_FLAGS := -fsanitize=address
	endif
endif

gpmftovbp : main.o GPMF_parser.o GPMF_utils.o GPMF_mp4reader.o GPMF_print.o
		gcc -o gpmftovbp main.o GPMF_parser.o GPMF_utils.o GPMF_mp4reader.o GPMF_print.o $(ASAN_FLAGS)
gpmfdemo : GPMF_demo.o GPMF_parser.o GPMF_utils.o GPMF_mp4reader.o GPMF_print.o
		gcc -o gpmfdemo GPMF_demo.o GPMF_parser.o GPMF_utils.o GPMF_mp4reader.o GPMF_print.o $(ASAN_FLAGS)

main.o : main.c
		gcc -g -c main.c
GPMF_demo.o : GPMF_demo.c
		gcc -g -c GPMF_demo.c
GPMF_mp4reader.o : GPMF_mp4reader.c gpmf-parser/GPMF_parser.h
		gcc -g -c GPMF_mp4reader.c
GPMF_print.o : GPMF_print.c gpmf-parser/GPMF_parser.h
		gcc -g -c GPMF_print.c
GPMF_parser.o : gpmf-parser/GPMF_parser.c gpmf-parser/GPMF_parser.h
		gcc -g -c gpmf-parser/GPMF_parser.c
GPMF_utils.o : gpmf-parser/GPMF_utils.c gpmf-parser/GPMF_utils.h
		gcc -g -c gpmf-parser/GPMF_utils.c
clean :
		rm gpmfdemo *.o
