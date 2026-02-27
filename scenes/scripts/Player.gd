extends CharacterBody2D

@export var walk_speed := 200.0
@export var crouch_speed := 100

@onready var sprite: Sprite2D = $Sprite2D
@export var idle_texture: Texture2D
@export var walk_texture: Texture2D
@export var jump_texture: Texture2D
@export var crouch_texture: Texture2D

# Jump physics
@export var gravity := 900.0
@export var fall_gravity := 1400.0
@export var jump_velocity := -350.0

# Double jump
@export var max_jumps := 2
var jump_count := 0

@onready var collision: CollisionShape2D = $CollisionShape2D
var is_crouching := false
# ukuran collision
var normal_height := 96.0
var crouch_height := 90.0


func _physics_process(delta):
	# crouch input
	is_crouching = Input.is_action_pressed("ui_down") and is_on_floor()

	# Reset jump saat di lantai
	if is_on_floor():
		jump_count = 0

	# jump (tidak bisa saat crouch)
	if not is_crouching and is_on_floor() and Input.is_action_just_pressed("ui_up"):
		velocity.y = jump_velocity

	# Apply gravity
	if velocity.y < 0:
		velocity.y += gravity * delta
	else:
		velocity.y += fall_gravity * delta

	# Jump input
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps:
		velocity.y = jump_velocity
		jump_count += 1

	# Jump cut (biar natural kalau tombol dilepas)
	if Input.is_action_just_released("ui_up") and velocity.y < 0:
		velocity.y *= 0.5

	# Horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if is_crouching:
		velocity.x = direction * crouch_speed
	else:
		velocity.x = direction * walk_speed

	# Flip sprite
	if direction > 0:
		sprite.flip_h = false  # hadap kanan
	elif direction < 0:
		sprite.flip_h = true  # hadap kiri

	# ganti texture sesuai state
	update_sprite(direction)
	update_collision()

	move_and_slide()


func update_sprite(direction):
	if is_crouching:
		sprite.texture = crouch_texture
	elif not is_on_floor():
		sprite.texture = jump_texture
	elif direction != 0:
		sprite.texture = walk_texture
	else:
		sprite.texture = idle_texture


func update_collision():
	var shape = collision.shape as RectangleShape2D
	if is_crouching:
		shape.size.y = crouch_height
		collision.position.y = (normal_height - crouch_height) / 2
	else:
		shape.size.y = normal_height
		collision.position.y = 0
