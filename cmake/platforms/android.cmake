set(QV2RAY_USE_QML ON)

if(NOT ANDROID_SDK)
    set(ANDROID_SDK $ENV{ANDROID_SDK_ROOT})
endif()

include(${ANDROID_SDK}/android_openssl/CMakeLists.txt)

set(ANDROID_LIB_ARCH ${CMAKE_ANDROID_ARCH})
if(${ANDROID_LIB_ARCH} STREQUAL "x86_64")
    set(ANDROID_LIB_ARCH "x64")
endif()

message("Android SDK: ${ANDROID_SDK}, ${CMAKE_ANDROID_ARCH}")

list(APPEND CMAKE_PROGRAM_PATH
    ${CMAKE_SOURCE_DIR}/libs/tools/grpc
    ${CMAKE_SOURCE_DIR}/libs/tools/protobuf
    ${CMAKE_SOURCE_DIR}/libs/tools/openssl
    )

set(QV2RAY_ANDROID_ROOT ${CMAKE_SOURCE_DIR}/libs/${ANDROID_LIB_ARCH}-android)

message("ASS: ${QV2RAY_ANDROID_ROOT}")
if(CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$" OR NOT DEFINED CMAKE_BUILD_TYPE) #Debug build: Put Debug paths before Release paths.
    set(QV2RAY_ANDROID_DEBUG_LIB ON)
    list(APPEND CMAKE_PREFIX_PATH
        ${QV2RAY_ANDROID_ROOT}/debug
        ${QV2RAY_ANDROID_ROOT}
        )
    link_directories(
        ${QV2RAY_ANDROID_ROOT}/debug/lib
        ${QV2RAY_ANDROID_ROOT}/lib
        )
    list(APPEND CMAKE_FIND_ROOT_PATH
        ${QV2RAY_ANDROID_ROOT}/debug
        ${QV2RAY_ANDROID_ROOT}
        )
else() #Release build: Put Release paths before Debug paths. Debug Paths are required so that CMake generates correct info in autogenerated target files.
    set(QV2RAY_ANDROID_DEBUG_LIB OFF)
    list(APPEND CMAKE_PREFIX_PATH
        ${QV2RAY_ANDROID_ROOT}
        ${QV2RAY_ANDROID_ROOT}/debug
        )
    link_directories(
        ${QV2RAY_ANDROID_ROOT}/lib
        ${QV2RAY_ANDROID_ROOT}/debug/lib
        )
    list(APPEND CMAKE_FIND_ROOT_PATH
        ${QV2RAY_ANDROID_ROOT}
        ${QV2RAY_ANDROID_ROOT}/debug
        )
endif()
