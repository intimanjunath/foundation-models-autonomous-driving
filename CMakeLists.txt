cmake_minimum_required(VERSION 3.12)

set(CMAKE_CUDA_HOST_COMPILER /usr/bin/g++-10)
set(CMAKE_C_COMPILER /usr/bin/gcc-10)
set(CMAKE_CXX_COMPILER /usr/bin/g++-10)

project(gpu_occupancy_grid_sim LANGUAGES C CXX CUDA)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CUDA_ARCHITECTURES 89)

include_directories(${CMAKE_SOURCE_DIR}/include)

find_package(SDL2 REQUIRED)
include_directories(${SDL2_INCLUDE_DIRS})

file(GLOB_RECURSE SRC_FILES src/*.cu src/*.cpp)

add_executable(occupancy_grid_sim ${SRC_FILES})
target_link_libraries(occupancy_grid_sim ${SDL2_LIBRARIES})
set_target_properties(occupancy_grid_sim PROPERTIES CUDA_SEPARABLE_COMPILATION ON)
