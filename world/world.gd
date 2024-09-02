extends Node2D


@export var player: CharacterBody2D
@export var mob_spawn_location: PathFollow2D
@export var mob_timer: Timer
@export var player_path_follow: PathFollow2D

var arrow_array: Array
var current_arrow: int
var current_arrow_index: int
var is_player_seducing_chicken: bool
var found_chicken: Area2D
#enum {LEFT_ARROW, UP_ARROW, RIGHT_ARROW, DOWN_ARROW}

func start(array: Array):
	arrow_array = array
	player.start()
	current_arrow_index = 0
	current_arrow = arrow_array[current_arrow_index]
	player_path_follow.progress_ratio = move_toward(player_path_follow.progress_ratio, 0.01, 0.001)
	# TODO: Link all chickens to player_found_chicken on their emit
	$Chicken.player_arrived.connect(player_found_chicken)


func end():
	#$DeathSound.play()
	mob_timer.stop()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_right"):
		check_arrow_direction(Game.RIGHT_ARROW)
	if event.is_action_pressed("move_left"):
		check_arrow_direction(Game.LEFT_ARROW)
	if event.is_action_pressed("move_down"):
		check_arrow_direction(Game.DOWN_ARROW)
	if event.is_action_pressed("move_up"):
		check_arrow_direction(Game.UP_ARROW)


func check_arrow_direction(input_arrow):
	# Check if moving or if aquiring a chicken
	# IF moving do this:
	if input_arrow == current_arrow:
		if !is_player_seducing_chicken:
			move_player()
		current_arrow_index += 1
		if current_arrow_index < arrow_array.size():
			current_arrow = arrow_array[current_arrow_index]
		else:
			if found_chicken:
				found_chicken.should_follow_player = true
				is_player_seducing_chicken = false
				# Reset the list?
				current_arrow_index = 0
				current_arrow = arrow_array[current_arrow_index]
	else:
		$Chicken.get_angry() # Maybe all chickens get angry?


func player_found_chicken(chicken: Area2D):
	is_player_seducing_chicken = true
	found_chicken = chicken
	arrow_array.append_array(chicken.arrow_pattern)


func move_player():
	var new_position = player_path_follow.progress_ratio + .025
	var tween = create_tween()
	tween.tween_property(self, "player_path_follow:progress_ratio", new_position, 1)


#func _on_mob_timer_timeout() -> void:
	## Create a new instance of the Mob scene.
	#var mob = GameScenes.MobScene.instantiate()
#
	## Choose a random location on Path2D.
	#var mob_spawn_location = mob_spawn_location
	#mob_spawn_location.progress_ratio = randf()
#
	## Set the mob's direction perpendicular to the path direction.
	#var direction = mob_spawn_location.rotation + PI / 2
#
	## Set the mob's position to a random location.
	#mob.position = mob_spawn_location.position
#
	## Add some randomness to the direction.
	#direction += randf_range(-PI / 4, PI / 4)
	#mob.rotation = direction
#
	## Choose the velocity for the mob.
	#var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	#mob.linear_velocity = velocity.rotated(direction)
#
	## Spawn the mob by adding it to the Main scene.
	#add_child(mob)
