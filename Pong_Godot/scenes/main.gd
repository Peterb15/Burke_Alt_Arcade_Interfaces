extends Sprite2D

var gameOver: bool = false
var score := [0, 0]# 0:Player, 1: CPU
const PADDLE_SPEED : int = 450


func _on_ball_timer_timeout():
	$Ball.new_ball()

func _on_score_left_body_entered(_body):
	score[1] += 1
	$Hud/CPUScore.text = str(score[1])
	if score[1] == 13:
		gameOver = true
		$game_end.text = ("CPU Wins!")
		#$play_again.text ="Click to play again"

	else:
		$BallTimer.start()

func _on_score_right_body_entered(_body):
	score[0] += 1
	$Hud/PlayerScore.text = str(score[0])
	if score[0] == 13:
		gameOver = true
		$game_end.text = "You Win!"
		#$play_again.text ="Click to play again"
	else:
		$BallTimer.start()
		
func _input(event):
	if gameOver == true:
		#if $"Player_Input/RichTextLabel".text == "balanced":
			$game_end_timer.start()
			gameOver = false
func _on_AudioTimer_timeout_game():
	get_tree().reload_current_scene()
	
		
