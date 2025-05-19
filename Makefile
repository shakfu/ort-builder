.PHONY: all build setup

all: build



setup:
	git clone -b v1.16.3 --depth=1 --recursive https://github.com/microsoft/onnxruntime.git
