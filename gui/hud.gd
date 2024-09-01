extends CanvasLayer


# Notifies `Main` node that the button has been pressed
signal gameplay_started


@export var score_label: Label
@export var message_label: Label
@export var start_button: Button
@export var message_timer: Timer
@export var input_container: PanelContainer
@onready var h_box_container: HBoxContainer = $InputContainer/HBoxContainer

var texture_array = []

#func _ready() -> void:
	#input_container.modulate = Color()

func add_arrows(amount):
	for index in amount:
		var arrow = GameScenes.ArrowTextureScene.instantiate()
		h_box_container.add_child(arrow, true)
		texture_array.append(arrow)


func rotate_arrows(direction_array):
	for index in texture_array.size():
		texture_array[index].pivot_offset = texture_array[index].size/2
		
		match direction_array[index]:
			Game.LEFT_ARROW:
				texture_array[index].rotation_degrees = -90
			Game.UP_ARROW:
				texture_array[index].rotation_degrees = 0
			Game.RIGHT_ARROW:
				texture_array[index].rotation_degrees = 90
			Game.DOWN_ARROW:
				texture_array[index].rotation_degrees = 180


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
	input_container.modulate = Color(1, 1, 1, 1)
	gameplay_started.emit()


func _on_message_timer_timeout() -> void:
	message_label.hide()
