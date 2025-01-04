package game

import "core:fmt"
import rl "vendor:raylib"

WINDOW_WIDTH: i32 : 1280
WINDOW_HEIGHT: i32 : 720

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "My First Game")
	defer rl.CloseWindow()
  
  // PLAYER STATS
	player_pos := rl.Vector2{640, 320}
	player_size := rl.Vector2{64, 64}
  player_vel : rl.Vector2 

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer {
			rl.DrawRectangleV(player_pos, player_size, rl.GREEN)
			rl.EndDrawing()
		}

		rl.ClearBackground(rl.BLUE)
    
    // Player Movement
		if rl.IsKeyDown(.LEFT) && player_pos.x >= 0 {
      player_vel.x = -300
		} else if rl.IsKeyDown(.RIGHT) && player_pos.x + player_size.x <= f32(WINDOW_WIDTH) {
      player_vel.x = 300
		} else {
      player_vel.x = 0
    }
    
    // Player Jump
    if rl.IsKeyPressed(.SPACE) {
      player_vel.y = -600
    }
    
    // Gravity
    player_vel.y += 2000 * rl.GetFrameTime()

    player_pos += player_vel * rl.GetFrameTime()

    if player_pos.y >= f32(WINDOW_HEIGHT) - player_size.y {
      player_pos.y = f32(WINDOW_HEIGHT) - player_size.y
    }

	}
}
