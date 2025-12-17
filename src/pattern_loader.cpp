#include "pattern_loader.hpp"

void spawn_glider(std::vector<int>& grid, int width, int height, int x, int y) {
    std::vector<std::pair<int, int>> glider = {
        {1, 0}, {2, 1}, {0, 2}, {1, 2}, {2, 2}
    };
    for (auto [dx, dy] : glider) {
        int gx = x + dx, gy = y + dy;
        if (gx < width && gy < height)
            grid[gy * width + gx] = 1;
    }
}

void spawn_blinker(std::vector<int>& grid, int width, int height, int x, int y) {
    for (int i = 0; i < 3; ++i)
        if (x + i < width && y < height)
            grid[y * width + (x + i)] = 1;
}

void spawn_block(std::vector<int>& grid, int width, int height, int x, int y) {
    for (int dx = 0; dx < 2; ++dx)
        for (int dy = 0; dy < 2; ++dy)
            if (x + dx < width && y + dy < height)
                grid[(y + dy) * width + (x + dx)] = 1;
}

void spawn_toad(std::vector<int>& grid, int width, int height, int x, int y) {
    std::vector<std::pair<int, int>> cells = {
        {1,0}, {2,0}, {3,0},
        {0,1}, {1,1}, {2,1}
    };
    for (auto [dx, dy] : cells) {
        int gx = x + dx, gy = y + dy;
        if (gx < width && gy < height)
            grid[gy * width + gx] = 1;
    }
}

void spawn_gosper_glider_gun(std::vector<int>& grid, int width, int height, int x, int y) {
    std::vector<std::pair<int, int>> gun = {
        {0,4},{0,5},{1,4},{1,5},
        {10,4},{10,5},{10,6},{11,3},{11,7},{12,2},{12,8},{13,2},{13,8},
        {14,5},{15,3},{15,7},{16,4},{16,5},{16,6},{17,5},
        {20,2},{20,3},{20,4},{21,2},{21,3},{21,4},
        {22,1},{22,5},{24,0},{24,1},{24,5},{24,6},
        {34,2},{34,3},{35,2},{35,3}
    };
    for (auto [dx, dy] : gun) {
        int gx = x + dx, gy = y + dy;
        if (gx < width && gy < height)
            grid[gy * width + gx] = 1;
    }
}
