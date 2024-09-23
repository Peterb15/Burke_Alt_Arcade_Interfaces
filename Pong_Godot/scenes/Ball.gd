extends CharacterBody2D

var win_size : Vector2
const START_SPEED : int = 500
const ACCEL : int = 50
var speed : int
var dir : Vector2
const MAX_Y_VECTOR : float = 0.6

# Called when the node enters the scene tree for the first time.
func _ready():
	win_size = get_viewport_rect().size

func new_ball():
	# Randomize start position and direction
	position.x = win_size.x / 2
	position.y = randi_range(200, win_size.y - 200)
	speed = START_SPEED
	dir = random_direction()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		#if ball hits paddle
		if collider == $"../Player_Input/Player" or collider == $"../CPU":
			play_paddle_audio()
			speed += ACCEL
			dir = new_direction(collider)
			
		#if it hits a wall
		else:
			play_wall_audio()
			dir = dir.bounce(collision.get_normal())


func random_direction():
	var new_dir := Vector2()
	new_dir.x = [1, -1].pick_random()
	new_dir.y = randf_range(-1, 1)
	return new_dir.normalized()

func new_direction(collider):
	var ball_y = position.y
	var pad_y = collider.position.y
	var dist = ball_y - pad_y
	var new_dir := Vector2()
	
	# Flip the horizontal direction
	if dir.x > 0:
		new_dir.x = -1
	else:
		new_dir.x = 1
	new_dir.y = (dist / (collider.p_height / 2)) * MAX_Y_VECTOR
	return new_dir.normalized()

# Reset audio playback flags when needed (e.g., when starting a new ball)
func play_paddle_audio():
	$"../paddle_audio".play()  # Play the audio
	$"../collision_timer".start()  # Start the timer
	
func play_wall_audio():
	$"../wall_audio".play()  # Play the audio
	$"../collision_timer".start()  # Start the timer

func _on_AudioTimer_timeout():
	if($"../wall_audio".playing):
		$"../wall_audio".stop()
	else:
		$"../paddle_audio".stop()  # Stop the audio when the timer times out
