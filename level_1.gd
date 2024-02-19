extends Node2D


func _on_end_zone_body_entered(body):
	if body.name == "Ball":
		print("Win!")
		get_tree().paused = true
