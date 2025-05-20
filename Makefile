.PHONY: all build setup sync clean reset

all: build


sync:
	@uv add -r requirements.txt

setup:
	@git clone -b v1.16.3 --depth=1 --recursive https://github.com/microsoft/onnxruntime.git

clean:
	@rm -f *.ort *.config

reset: clean
	@rm -rf ./libs ./model.onnx ./model ./onnxruntime

