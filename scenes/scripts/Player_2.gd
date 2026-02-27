extends CharacterBody2D

@export var walk_speed := 200.0
@export var crouch_speed := 100.0

# Jump Physics
@export var gravity := 900.0
@export var jump_velocity := -350.0
@export var fall_gravity := 1400.0

# Double Jump
@export var max_jumps := 2

# variables
var jump_count := 0
var is_crouching := false

# ukuran collision
var normal_height := 96.0
var crouch_height := 86.0

# Water Physics
var water_gravity := 200.0
var swim_up_speed := -200.0
var water_drag := 0.9
var is_in_water := false

# Ladder
var is_on_ladder := false

# onready vars (HARUS setelah semua var)
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func enter_water():
	is_in_water = true


func exit_water():
	is_in_water = false


func enter_ladder():
	is_on_ladder = true
	velocity = Vector2.ZERO


func exit_ladder():
	is_on_ladder = false


func _physics_process(delta):
	# FLOOR CHECK
	if is_on_floor():
		jump_count = 0

	# CROUCH INPUT
	is_crouching = Input.is_action_pressed("ui_down") and is_on_floor()

	# JUMP + DOUBLE JUMP
	if Input.is_action_just_pressed("ui_up") and jump_count < max_jumps and not is_crouching:
		velocity.y = jump_velocity
		jump_count += 1

	# GRAVITY
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += gravity * delta
		else:
			velocity.y += fall_gravity * delta

	# HORIZONTAL MOVEMENT
	var direction := Input.get_axis("ui_left", "ui_right")

	if is_crouching:
		velocity.x = direction * crouch_speed
	else:
		velocity.x = direction * walk_speed

	# FLIP SPRITE
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	# CROUCH COLLISION SIZE
	var shape := collision.shape as RectangleShape2D

	if is_crouching:
		shape.size.y = crouch_height
		collision.position.y = (normal_height - crouch_height) / 2
	else:
		shape.size.y = normal_height
		collision.position.y = 0

	# SWIM
	if is_in_water:
		velocity.y += water_gravity * delta
		if Input.is_action_pressed("ui_up"):
			velocity.y = swim_up_speed
		velocity.x *= water_drag

	# CLIMB
	if is_on_ladder:
		var vertical := Input.get_axis("ui_up", "ui_down")
		velocity.y = vertical * 120

		var horizontal := Input.get_axis("ui_left", "ui_right")
		velocity.x = horizontal * walk_speed * 0.5
	else:
		if not is_on_floor():
			if velocity.y < 0:
				velocity.y += gravity * delta
			else:
				velocity.y += fall_gravity * delta

	# ANIMATION STATE
	if is_crouching:
		sprite.play("crouch")
	elif is_on_ladder:
		if velocity.y != 0:
			sprite.play("climb")
		else:
			sprite.play("climb_idle")
	elif not is_on_floor():
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("stand")

	move_and_slide()


func update_animation(direction):
	if not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("stand")