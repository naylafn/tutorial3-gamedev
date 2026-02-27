extends CharacterBody2D

@export var walk_speed: float = 200.0
@export var crouch_speed: float = 100.0

@export var idle_texture: Texture2D
@export var walk_texture: Texture2D
@export var jump_texture: Texture2D
@export var crouch_texture: Texture2D

# Jump physics
@export var gravity: float = 900.0
@export var fall_gravity: float = 1400.0
@export var jump_velocity: float = -350.0

# Double jump
@export var max_jumps: int = 2

# variables
var jump_count: int = 0
var is_crouching: bool = false

# ukuran collision
var normal_height: float = 96.0
var crouch_height: float = 90.0

# onready variables (HARUS setelah var biasa)
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


func _physics_process(delta: float) -> void:
	# crouch input (hanya saat di lantai)
	is_crouching = Input.is_action_pressed("ui_down") and is_on_floor()

	# reset jump saat di lantai
	if is_on_floor():
		jump_count = 0

	# jump
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps and not is_crouching:
		velocity.y = jump_velocity
		jump_count += 1

	# apply gravity
	if velocity.y < 0.0:
		velocity.y += gravity * delta
	else:
		velocity.y += fall_gravity * delta

	# jump cut
	if Input.is_action_just_released("ui_up") and velocity.y < 0.0:
		velocity.y *= 0.5

	# horizontal movement
	var direction: float = Input.get_axis("ui_left", "ui_right")

	if is_crouching:
		velocity.x = direction * crouch_speed
	else:
		velocity.x = direction * walk_speed

	# flip sprite sesuai arah
	if direction > 0.0:
		sprite.flip_h = false
	elif direction < 0.0:
		sprite.flip_h = true

	update_sprite(direction)
	update_collision()

	move_and_slide()


func update_sprite(direction: float) -> void:
	if is_crouching:
		sprite.texture = crouch_texture
	elif not is_on_floor():
		sprite.texture = jump_texture
	elif direction != 0.0:
		sprite.texture = walk_texture
	else:
		sprite.texture = idle_texture


func update_collision() -> void:
	var shape: RectangleShape2D = collision.shape as RectangleShape2D

	if shape == null:
		return

	if is_crouching:
		shape.size.y = crouch_height
		collision.position.y = (normal_height - crouch_height) / 2.0
	else:
		shape.size.y = normal_height
		collision.position.y = 0.0
