extends Area2D

signal player_arrived

@export var SPEED: int = 200
@export var player: CharacterBody2D
@export var arrows: Node2D

var arrow_pattern: Array
const AMOUNT_OF_ARROWS: int = 3
var current_arrow: int

var should_follow_player: bool = false
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for arrow in AMOUNT_OF_ARROWS:
		var my_random_number = rng.randi_range(0, 3)
		arrow_pattern.append(my_random_number)
	
	for arrow in AMOUNT_OF_ARROWS:
		match arrow_pattern[arrow]:
			Game.LEFT_ARROW:
				arrows.get_child(arrow).rotation_degrees = -90
			Game.UP_ARROW:
				arrows.get_child(arrow).rotation_degrees = 0
			Game.RIGHT_ARROW:
				arrows.get_child(arrow).rotation_degrees = 90
			Game.DOWN_ARROW:
				arrows.get_child(arrow).rotation_degrees = 180
				
	current_arrow = 0
	arrows.get_child(current_arrow).set("modulate", Color(.1, .8, .1))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO # The chicken's movement vector.
	var direction = (player.global_position - position).normalized()
	blink_arrows()
	if should_follow_player == true:
		arrows.hide()
		#var direction = (player.position - global_position).normalized()
		#var desired_velocity = direction * SPEED
		#var steering = (desired_velocity - velocity) * delta * 2.5
		#velocity += steering
		#position += velocity
		position = position.move_toward(player.global_position - (direction * 16), delta * SPEED)
		#var target_position = player.global_position - (player.global_transform.origin * 5)
		#position = position.move_toward(target_position, delta * SPEED)
		#print(player.global_position)
	#if velocity.length() > 0:
		#velocity = velocity.normalized() * SPEED
	#position += velocity * delta
		

func progress_arrows():
	if current_arrow < 3:
		if arrows.get_child(current_arrow) and current_arrow < AMOUNT_OF_ARROWS:
			arrows.get_child(current_arrow).set("modulate", Color(.1, .1, .1))
			current_arrow += 1
	if current_arrow < 3:
		if arrows.get_child(current_arrow):
			arrows.get_child(current_arrow).set("modulate", Color(.1, .8, .1))
	

func blink_arrows():
	var tween = get_tree().create_tween()
	#tween.tween_property(arrows, "modulate", Color(1, 1, 1, 0), .1)
	tween.tween_interval(.5).finished
	tween.tween_property(arrows, "modulate", Color(1, 1, 1, 1), .1)


func get_angry():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite, "modulate", Color(1, .3, .3, 1), 0.25)
	tween.tween_interval(1).finished
	tween.tween_property($Sprite, "modulate", Color(1, 1, 1, 1), 1)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("This happened!@")
		player_arrived.emit(self)
