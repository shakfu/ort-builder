#!/usr/bin/env bash
set -euf -o pipefail

ONNX_CONFIG="${1:-model.required_operators_and_types.config}"
CMAKE_BUILD_TYPE=MinSizeRel
ARCH=`uname -m`

build_arch() {
  ONNX_CONFIG="$1"

  python onnxruntime/tools/ci_build/build.py \
  --build_dir "onnxruntime/build/macOS_${ARCH}" \
  --config=${CMAKE_BUILD_TYPE} \
  --parallel \
  --minimal_build \
  --apple_deploy_target="10.13" \
  --disable_ml_ops --disable_rtti \
  --include_ops_by_config "$ONNX_CONFIG" \
  --enable_reduced_operator_type_support \
  --cmake_extra_defines CMAKE_OSX_ARCHITECTURES="${ARCH}" CMAKE_POLICY_VERSION_MINIMUM=3.5 \
  --skip_tests

  BUILD_DIR=./onnxruntime/build/macOS_${ARCH}/${CMAKE_BUILD_TYPE}

  mkdir -p libs
  libtool -static -o "libs/libonnxruntime.a" \
  "${BUILD_DIR}/libonnx.a" \
  "${BUILD_DIR}/libonnxruntime_graph.a" \
  "${BUILD_DIR}/libonnx_proto.a" \
  "${BUILD_DIR}/libonnxruntime_mlas.a" \
  "${BUILD_DIR}/libonnx_test_data_proto.a" \
  "${BUILD_DIR}/libonnxruntime_optimizer.a" \
  "${BUILD_DIR}/libonnx_test_runner_common.a" \
  "${BUILD_DIR}/libonnxruntime_common.a" \
  "${BUILD_DIR}/libonnxruntime_providers.a" \
  "${BUILD_DIR}/libonnxruntime_session.a" \
  "${BUILD_DIR}/libonnxruntime_flatbuffers.a" \
  "${BUILD_DIR}/libonnxruntime_test_utils.a" \
  "${BUILD_DIR}/libonnxruntime_framework.a" \
  "${BUILD_DIR}/libonnxruntime_util.a" \
  "${BUILD_DIR}/_deps/re2-build/libre2.a" \
  "${BUILD_DIR}/_deps/google_nsync-build/libnsync_cpp.a" \
  "${BUILD_DIR}/_deps/protobuf-build/libprotobuf-lite.a" \
  "${BUILD_DIR}/_deps/abseil_cpp-build/absl/hash/libabsl_hash.a" \
  "${BUILD_DIR}/_deps/abseil_cpp-build/absl/hash/libabsl_city.a" \
  "${BUILD_DIR}/_deps/abseil_cpp-build/absl/hash/libabsl_low_level_hash.a" \
  "${BUILD_DIR}/_deps/abseil_cpp-build/absl/base/libabsl_throw_delegate.a" \
  "${BUILD_DIR}/_deps/abseil_cpp-build/absl/container/libabsl_raw_hash_set.a" \
  "${BUILD_DIR}/_deps/abseil_cpp-build/absl/base/libabsl_raw_logging_internal.a"
}

build_arch "$ONNX_CONFIG"
