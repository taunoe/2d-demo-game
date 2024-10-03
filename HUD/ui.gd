extends CanvasLayer

# Notifies `Main` node that the button has been pressed
signal start_game


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over():
	show_message("tra!\nMäng läbi!")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Põgene toivode eest!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$ScoreNum.text = str(score)

func update_lives(lives):
	$LivesNum.text = str(lives)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScoreNum.hide()
	$ScoreLabel.hide()
	$LivesNum.hide()
	$LivesLabel.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	$ScoreNum.show()
	$ScoreLabel.show()
	$LivesNum.show()
	$LivesLabel.show()
	$StartButton.hide()
	start_game.emit()


func _on_message_timer_timeout() -> void:
	$Message.hide()
