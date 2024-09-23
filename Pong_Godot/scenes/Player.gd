extends StaticBody2D

var win_height : int
var p_height : int
var input_direction : String = ""  # Variable to store the direction input
const full_tilt = 1.35

# Called when the node enters the scene tree for the first time.
func _ready():
	win_height = get_viewport_rect().size.y
	p_height = $ColorRect.get_size().y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if input_direction == "up":
		position.y -= get_parent().get_parent().PADDLE_SPEED * delta
	if input_direction == "UP":
		position.y -= get_parent().get_parent().PADDLE_SPEED * delta * full_tilt
	if input_direction == "down":
		position.y = position.y + (get_parent().get_parent().PADDLE_SPEED * delta)
	if input_direction == "DOWN":
		position.y = position.y + get_parent().get_parent().PADDLE_SPEED * delta * full_tilt
	if(input_direction == "balanced"):
		position.y = position.y


	# Limit paddle movement to window
	position.y = clamp(position.y, p_height / 2, win_height - p_height / 2)

func SetControllerInput(direction: String):
	if direction == "left":
		input_direction = "up";
	if direction == "right":
		input_direction = "down";
	if direction == "balanced":
			input_direction = "balanced";
	if direction == "LEFT":
			input_direction = "UP";
	if direction == "RIGHT":
			input_direction = "DOWN";
	
