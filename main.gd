extends Node


@export var world: Node2D
@export var gui: Control
@export var start_timer: Timer
@export var music_player: AudioStreamPlayer2D

var arrow_array: Array = [Game.LEFT_ARROW, Game.UP_ARROW, Game.RIGHT_ARROW, Game.DOWN_ARROW]

func _ready() -> void:
	#world.player.gameplay_ended.connect(game_over)
	gui.hud.gameplay_started.connect(new_game)
	gui.hud.add_arrows(arrow_array.size())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("quit"):
		get_tree().quit()


func game_over():
	gui.end()
	world.end()
	music_player.stop()


func new_game():
	gui.start(arrow_array)
	world.start(arrow_array)
	start_timer.start()
	get_tree().call_group("mobs", "queue_free")
	music_player.play()


func _on_start_timer_timeout() -> void:
	world.mob_timer.start()
	gui.score_timer.start()
