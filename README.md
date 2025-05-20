# ONNX Runtime static library builder

## Fork Notes

This variant includes the following changes from the upstream `ort-builder` project:

- Added `build-macos-native.sh`

- Added support for building using `uv` to make it easy to build using python version `3.11`


## Overview


Converts an [ONNX](https://onnx.ai) model to ORT format and serializes it to C++ source code, generate custom slimmed ONNX Runtime static libs & xcframework for apple platforms.

The goal here is to create a flexible but tiny inference engine for a specific model e.g. [iPlug2 example](https://github.com/olilarkin/iPlug2OnnxRuntime).

*NOTE: due to risk of ODR violations, global/static variable conflicts, and dependency symbol clashes with DAW Hosts that use ORT themselves - think hard before you use this in an audio plugin!*

The scripts here are configured to create a minimal ORT binary using only the CPU provider. If you want to experiment with GPU inference, Core ML etc, you will have to modify.

## Requirements:

CMake v2.6+

## Instructions:

1. Checkout ONNX Runtime submodule `$ git submodule update --init`

2. Create a [virtual environment](https://packaging.python.org/tutorials/installing-packages/#creating-virtual-environments) and activate it

windows
```bash
py -3 -m venv venv
source ./venv/Scripts/activate`
```

mac/linux
```bash
uv add -r requirements.txt
source ./.venv/bin/activate`
```

3. Convert `.onnx` model to `.ort` 

```sh
./scripts/convert-model-to-ort.sh model.onnx
```

This converts the `.onnx` file to `.ort` and produces a `.config` file which slims the `onnxruntime` library build in the next step. It also serializes the `.ort` format model to C++ source code, which can be used to bake the model into your app binary. If the model
is large this might not be a great solution, and it might be better to locate the `.ort` file at runtime.

4. Build customized onnx runtime static libraries

```sh
./scripts/build-mac.sh
```

for a universal macos static library or

```sh
./scripts/build-mac-native.sh
```

for a native macos static library.

for ios,

```sh
./scripts/build-ios.sh
./scripts/build-ios-simulator.sh
```

for windows,

```sh
./scripts/build-xcframework.sh
```

**Note:** windows static lib builds can get very large due to the LTO/LTCG settings in onnxruntime. You can turn that off by applying the change in ltcg_patch_for_windows.patch to the onnxruntime repo. Due to different MSVC runtimes for Debug and Release builds, we need to build two binaries for windows.

```sh
./scripts/build-win.sh
```
