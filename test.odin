package game

import "core:fmt"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(1280, 720, "My First Game")
	defer rl.CloseWindow()

	player_pos := rl.Vector2{640, 320}
	player_size := rl.Vector2{64, 64}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLUE)

		if rl.IsKeyDown(.LEFT) && player_pos.x >= 0 {
			player_pos.x -= 400 * rl.GetFrameTime()
		}

		if rl.IsKeyDown(.RIGHT) && player_pos.x + player_size.x <= 1280 {
			player_pos.x += 400 * rl.GetFrameTime()
		}

		rl.DrawRectangleV(player_pos, player_size, rl.GREEN)
		rl.EndDrawing()
	}
}
