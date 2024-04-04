extends Area3D



func _on_body_exited(body):
	if body is Character:
		print("aa")
		body.HealthManager.take_damage(100000000)
