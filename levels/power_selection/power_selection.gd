extends Node


var selection_index = 0


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	# let's enjoy return :)
	if Input.is_action_just_pressed("ui_cancel"):
		SceneManager.change_scene("res://levels/title/title.tscn")
	
	# you can enjoy menu! 
	if Input.is_action_just_pressed("ui_up"):
		selection_index -= 1
		
		if selection_index < 0:
			selection_index = 2
	
	if Input.is_action_just_pressed("ui_down"):
		selection_index += 1
		
		if selection_index > 2:
			selection_index = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		pass
