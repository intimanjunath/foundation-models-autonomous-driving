#include "renderer.hpp"
#include <SDL2/SDL.h>

static SDL_Window* window = nullptr;
static SDL_Renderer* renderer = nullptr;

static int g_grid_width = 0;
static int g_grid_height = 0;

static int g_offset_x = 0;
static int g_offset_y = 0;

static int g_cell_size = 2;

static int g_window_width = 1024;
static int g_window_height = 1024;

void init_renderer(int width, int height, int cell_size){
    g_grid_width = width;
    g_grid_height = height;
    g_cell_size = cell_size;

    g_window_width = width * cell_size;
    g_window_height = height * cell_size;

    SDL_Init(SDL_INIT_VIDEO);
    window = SDL_CreateWindow("GPU Occupancy Grid Simulator",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED,
        g_window_width, g_window_height, SDL_WINDOW_SHOWN);
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
}

void render_grid(const std::vector<int>& grid, int width, int height, int /*unused*/) {
    SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
    SDL_RenderClear(renderer);

    SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);

    int visible_cols = g_window_width / g_cell_size;
    int visible_rows = g_window_height / g_cell_size;

    for (int y = 0; y < visible_rows; ++y) {
        for (int x = 0; x < visible_cols; ++x) {
            int gx = x + g_offset_x;
            int gy = y + g_offset_y;
            if (gx >= 0 && gx < width && gy >= 0 && gy < height) {
                if (grid[gy * width + gx]) {
                    SDL_Rect cell = { x * g_cell_size, y * g_cell_size, g_cell_size, g_cell_size };
                    SDL_RenderFillRect(renderer, &cell);
                }
            }
        }
    }

    SDL_RenderPresent(renderer);
}

void shutdown_renderer(){
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void update_cell_size(int delta) {
    g_cell_size += delta;
    if (g_cell_size < 1) g_cell_size = 1;
    if (g_cell_size > 40) g_cell_size = 40;
}

void handle_mouse_drag(int dx, int dy) {
    g_offset_x -= dx / g_cell_size;
    g_offset_y -= dy / g_cell_size;

    if (g_offset_x < 0) g_offset_x = 0;
    if (g_offset_y < 0) g_offset_y = 0;
}
