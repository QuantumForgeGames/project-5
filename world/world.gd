extends Node2D


@export var player: Area2D
@export var start_position: Marker2D
@export var mob_spawn_location: PathFollow2D
@export var mob_timer: Timer



func start():
	player.start(start_position.position)


func end():
	#$DeathSound.play()
	mob_timer.stop()


func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = GameScenes.MobScene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = mob_spawn_location
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
