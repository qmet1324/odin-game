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
  player_grounded : bool
  player_idle_anim := rl.LoadTexture("sprites/idle.png")
  player_run_anim := rl.LoadTexture("sprites/run.png")

  // GROUND STATS
  ground_pos := rl.Vector2{0, f32(WINDOW_HEIGHT) - player_size.y}
  ground_size := rl.Vector2{1280, 64}

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer {
			rl.DrawRectangleV(player_pos, player_size, rl.GREEN) // Player Drawing
      rl.DrawRectangleV(ground_pos, ground_size, rl.BROWN) // Ground Drawing
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
    
    // Gravity
    player_vel.y += 2000 * rl.GetFrameTime()
    
    // Player Jump
    if rl.IsKeyPressed(.SPACE) && player_grounded {
      player_vel.y = -600
      player_grounded = false
    }
    
    // Player Velocity
    player_pos += player_vel * rl.GetFrameTime()

    if player_pos.y >= ground_pos.y - ground_size.y{
      player_pos.y = ground_pos.y - ground_size.y
      player_grounded = true
    }
	}
}
