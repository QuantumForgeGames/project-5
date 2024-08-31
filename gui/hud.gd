extends CanvasLayer


# Notifies `Main` node that the button has been pressed
signal gameplay_started


@export var score_label: Label
@export var message_label: Label
@export var start_button: Button
@export var message_timer: Timer


func show_message(text):
	message_label.text = text
	message_label.show()
	message_timer.start()
	

func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await message_timer.timeout
	message_label.text = "Dodge the Creeps!"
	message_label.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	start_button.show()


func update_score(score):
	score_label.text = str(score)


func _on_start_button_pressed() -> void:
	start_button.hide()
	gameplay_started.emit()


func _on_message_timer_timeout() -> void:
	message_label.hide()
