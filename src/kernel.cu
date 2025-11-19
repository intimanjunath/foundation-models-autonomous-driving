#include "kernel.cuh"

__global__ void update_kernel(const int* current, int* next, int width, int height){
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if(x>=width || y>=height) return;

    int idx = y*width+x;
    int live_neighbors = 0;

    // scan 8 neighbors
    for(int dx = -1; dx <= 1; ++dx){
        for(int dy = -1; dy <= 1; ++dy){
            if(dx == 0 && dy == 0) continue; // skip self

            int nx = x + dx;
            int ny = y + dy;

            // bounds check
            if (nx>=0 && nx < width && ny>=0 && ny<height){
                int neighbor_idx = ny*width+nx;
                live_neighbors += current[neighbor_idx];
            }
        }
    }

    // Apply conways rules
    if (current[idx] == 1) {
        next[idx] = (live_neighbors == 2 || live_neighbors == 3) ? 1 : 0;
    } else {
        next[idx] = (live_neighbors == 3) ? 1 : 0;
    }
}

void launch_update_kernel(const int* current, int* next, int width, int height){
    dim3 threads(16,16);
    dim3 blocks((width+15)/16, (height+15)/16);
    update_kernel<<<blocks, threads>>>(current, next, width, height);
}