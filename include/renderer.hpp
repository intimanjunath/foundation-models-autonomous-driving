#pragma once
#include <vector>

void init_renderer(int width, int height, int cell_size);
void render_grid(const std::vector<int>& grid, int width, int height, int cell_size);
void shutdown_renderer();
void update_cell_size(int delta);
void handle_mouse_drag(int dx, int dy);
