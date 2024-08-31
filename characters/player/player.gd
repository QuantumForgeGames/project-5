extends Area2D

signal gameplay_ended


@export var animated_sprite: AnimatedSprite2D
@export var collision_shape: CollisionShape2D


const SPEED = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.


func _ready():
	screen_size = get_viewport_rect().size
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		animated_sprite.play()
	else:
		animated_sprite.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x != 0:
		animated_sprite.animation = "walk"
		animated_sprite.flip_v = false
		# See the note below about the following boolean assignment.
		animated_sprite.flip_h = velocity.x < 0
	elif velocity.y != 0:
		animated_sprite.animation = "up"
		animated_sprite.flip_v = velocity.y > 0


func _on_body_entered(body):
	hide() # Player disappears after being hit.
	gameplay_ended.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	collision_shape.set_deferred("disabled", true)


func start(pos):
	position = pos
	show()
	collision_shape.disabled = false
