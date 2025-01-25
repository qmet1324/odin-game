package game

import "core:fmt"
import rl "vendor:raylib"

WINDOW_WIDTH: i32 : 1280
WINDOW_HEIGHT: i32 : 720

Animation_Name :: enum {
  IDLE,
  RUN,
}

Animation :: struct {
  texture : rl.Texture2D,
  num_frames : int,
  frame_timer : f32,
  current_frame : int,
  frame_length : f32,
  name: Animation_Name
}

main :: proc() {
	rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "My First Game")
	defer rl.CloseWindow()
  
  // PLAYER STATS

  player_idle := Animation {
    texture = rl.LoadTexture("sprites/idle.png"),
    num_frames = 7,
    frame_length = 0.1,
    name = .IDLE
  }

  player_run := Animation {
    texture = rl.LoadTexture("sprites/run.png"),
    num_frames = 7,
    frame_length = 0.1,
    name = .RUN
  }

  player_current_anim := player_idle
  player_idle_width := f32(player_current_anim.texture.width)
  player_idle_height := f32(player_current_anim.texture.height)
  player_run_width := f32(player_current_anim.texture.width)
  player_run_height := f32(player_current_anim.texture.height)
  
	player_pos := rl.Vector2{640, 320}
	player_size := rl.Vector2{64, 64}
  player_vel : rl.Vector2 
  player_grounded : bool
  player_flip: bool

	for !rl.WindowShouldClose() {
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground(rl.GRAY)
    
    // Player Movement
		if rl.IsKeyDown(.LEFT) && player_pos.x >= 0 {
      player_vel.x = -300
      player_flip = true
      if player_current_anim.name != .RUN {
        player_current_anim = player_run
      }
		} else if rl.IsKeyDown(.RIGHT) && player_pos.x + player_size.x <= f32(WINDOW_WIDTH) {
      player_vel.x = 300
      player_flip = false
      if player_current_anim.name != .RUN {
        player_current_anim = player_run
      }
		} else {
      player_vel.x = 0
      if player_current_anim.name != .IDLE {
        player_current_anim = player_idle
      }
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
    if player_pos.y >= f32(WINDOW_HEIGHT) - player_size.y {
      player_pos.y = f32(WINDOW_HEIGHT) - player_size.y
      player_grounded = true
    }
    
    // Animation Frame Counter
    player_current_anim.frame_timer += rl.GetFrameTime()

    if player_current_anim.frame_timer > player_idle.frame_length {
      player_current_anim.current_frame += 1
      player_current_anim.frame_timer = 0

      if player_current_anim.current_frame == player_idle.num_frames {
        player_current_anim.current_frame = 0
      }
    }
 
    draw_player_source := rl.Rectangle {
      x = f32(player_current_anim.current_frame) * player_idle_width / f32(player_idle.num_frames),
      y = 0,
      width = player_idle_width / f32(player_idle.num_frames),
      height = player_idle_height
    }

    if player_flip {
      draw_player_source.width = -draw_player_source.width
    }

    draw_player_dest := rl.Rectangle {
      x = player_pos.x,
      y = player_pos.y,
      width = player_idle_width / f32(player_idle.num_frames),
      height = player_idle_height,
    }

		rl.DrawTexturePro(player_current_anim.texture, draw_player_source, draw_player_dest, 0, 0, rl.WHITE) // Player Drawing
	}
}
