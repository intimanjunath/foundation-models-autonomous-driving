#include "kernel.cuh"
#include "renderer.hpp"
#include <iostream>
#include <vector>
#include <random>
#include <SDL2/SDL.h>
#include "pattern_loader.hpp"

const int WIDTH = 420, HEIGHT = 420, CELL_SIZE = 2;
const int SIZE = WIDTH * HEIGHT;
const float density = 0.05;

void random_init(std::vector<int>& grid) {
    std::mt19937 rng(std::random_device{}());
    std::bernoulli_distribution d(density);
    for (auto& cell : grid) cell = d(rng);
}

int main(int argc, char* argv[]){
    std::vector<int> host_grid(SIZE);

    std::string mode = (argc > 1) ? argv[1] : "simulate";
    std::string pattern = (argc > 2) ? argv[2] : "";

    if (mode == "simulate") {
        std::mt19937 rng(std::random_device{}());
        std::bernoulli_distribution d(0.2);
        for (auto& cell : host_grid) cell = d(rng);
    }
    else if (mode == "observe") {
        // int cx = WIDTH / 2;
        // int cy = HEIGHT / 2;
        int cx = 10;
        int cy = 10;

        if (pattern == "glider") {
            spawn_glider(host_grid, WIDTH, HEIGHT, cx - 1, cy - 1);
        } else if (pattern == "blinker") {
            spawn_blinker(host_grid, WIDTH, HEIGHT, cx - 1, cy);
        } else if (pattern == "block") {
            spawn_block(host_grid, WIDTH, HEIGHT, cx - 1, cy - 1);
        } else if (pattern == "toad") {
            spawn_toad(host_grid, WIDTH, HEIGHT, cx - 2, cy - 1);
        } else if (pattern == "gun") {
            spawn_gosper_glider_gun(host_grid, WIDTH, HEIGHT, cx - 18, cy - 4);
        } else {
            std::cerr << "Unknown pattern: " << pattern << "\n";
            return 1;
        }
    }
    else {
        std::cerr << "Usage:\n";
        std::cerr << "  " << argv[0] << " simulate\n";
        std::cerr << "  " << argv[0] << " observe [glider|blinker|block|toad|gun]\n";
        return 1;
    }

    int *dev_current, *dev_next;
    cudaMalloc(&dev_current, SIZE * sizeof(int));
    cudaMalloc(&dev_next, SIZE * sizeof(int));
    cudaMemcpy(dev_current, host_grid.data(), SIZE * sizeof(int), cudaMemcpyHostToDevice);

    init_renderer(WIDTH, HEIGHT, CELL_SIZE);

    bool running = true;
    SDL_Event event;

    bool dragging = false;
    int last_x = 0, last_y = 0;

    while (running) {

        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) running = false;

            if (event.type == SDL_MOUSEWHEEL) {
                update_cell_size(event.wheel.y > 0 ? +1 : -1);
            }

            if (event.type == SDL_MOUSEBUTTONDOWN && event.button.button == SDL_BUTTON_LEFT) {
                dragging = true;
                last_x = event.button.x;
                last_y = event.button.y;
            }

            if (event.type == SDL_MOUSEBUTTONUP && event.button.button == SDL_BUTTON_LEFT) {
                dragging = false;
            }

            if (event.type == SDL_MOUSEMOTION && dragging) {
                int dx = event.motion.x - last_x;
                int dy = event.motion.y - last_y;
                handle_mouse_drag(dx, dy);
                last_x = event.motion.x;
                last_y = event.motion.y;
            }
        }

        launch_update_kernel(dev_current, dev_next, WIDTH, HEIGHT);
        cudaDeviceSynchronize();
        std::swap(dev_current, dev_next);

        cudaMemcpy(host_grid.data(), dev_current, SIZE * sizeof(int), cudaMemcpyDeviceToHost);
        render_grid(host_grid, WIDTH, HEIGHT, CELL_SIZE);
        SDL_Delay(30);
    }

    shutdown_renderer();
    cudaFree(dev_current);
    cudaFree(dev_next);
    return 0;
}