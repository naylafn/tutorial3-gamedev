extends Area2D


func _on_body_entered(body):
	if body.has_method("enter_ladder"):
		body.enter_ladder()


func _on_body_exited(body):
	if body.has_method("exit_ladder"):
		body.exit_ladder()
