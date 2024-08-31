extends Control


@export var hud: CanvasLayer
@export var score_timer: Timer


var score


func start():
	score = 0
	hud.update_score(score)
	hud.show_message("Get Ready")


func end():
	score_timer.stop()
	hud.show_game_over()


func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)
