extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready():
	for child in get_children():
		if child is AnimatedSprite2D:
			child.play("water")


func _on_body_entered(body):
	if body.has_method("enter_water"):
		body.enter_water()


func _on_body_exited(body):
	if body.has_method("exit_water"):
		body.exit_water()
