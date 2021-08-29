extends Node


var is_changing_scene: bool = false


func change_scene(path: String) -> void:
	if is_changing_scene:
		return
	
	is_changing_scene = true
	
	# Start the transistion animation and wait.
	$AnimationPlayer.play("start")
	yield(get_tree().create_timer(0.6), "timeout")
	
	# Change the scene
	# Might need to change this in the future to a yield that waits for  the new scene's "ready" signal just in case loading stuff seems to be an issue.
	if get_tree().change_scene(path) != OK:
		get_tree().quit(-1)
	
	# Finish the transistion animation and wait
	$AnimationPlayer.play("end")
	yield(get_tree().create_timer(0.6), "timeout")
	
	is_changing_scene = false
