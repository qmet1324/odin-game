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
	player_size := rl.Vector2{128, 128}
  player_vel : rl.Vector2 
  player_grounded : bool
  player_idle_texture := rl.LoadTexture("sprites/idle.png")
  player_idle_num_frames := 7
  player_run_texture := rl.LoadTexture("sprites/run.png")

  // FRAMES DIVISION
  player_idle_width := f32(player_idle_texture.width)
  player_idle_height := f32(player_idle_texture.height)

  draw_player_source := rl.Rectangle {
    x = 0,
    y = 0,
    width = player_idle_width / f32(player_idle_num_frames),
    height = player_idle_height,
  }

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer {
			rl.DrawTextureRec(player_idle_texture, draw_player_source, player_pos, rl.WHITE) // Player Drawing
			rl.EndDrawing()
		}

		rl.ClearBackground(rl.GRAY)
    
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
    
    // Hardcoded Ground 
    if player_pos.y >= f32(WINDOW_HEIGHT) - player_size.y{
      player_pos.y = f32(WINDOW_HEIGHT) - player_size.y
      player_grounded = true
    }
	}
}
