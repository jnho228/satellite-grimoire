extends Node

# TODO: Border for Options Menu
# TODO: Options Menu UI Elements Bigger

# 0 Select, 1 Confirm, 2 Cancel, 3 Error
export (Array, AudioStream) var soundEffects

var main_menu_index: int = 0
var options_menu_index: int = 0
var is_options_showing: bool = false

var config_file = "user://config.save"


func _ready() -> void:

	print("Hello World!")

	# Load config file!
	var file = File.new()
	if file.file_exists(config_file):
		file.open(config_file, File.READ)
		AudioServer.set_bus_volume_db(1, file.get_var())
		AudioServer.set_bus_volume_db(2, file.get_var())
		OS.window_fullscreen = file.get_var()
		file.close()
	else:
		AudioServer.set_bus_volume_db(1, linear2db(0.8))
		AudioServer.set_bus_volume_db(2, linear2db(0.5))
		OS.window_fullscreen = false
		
	
	# Main menu setup
	$UI/MarginContainer/VBoxContainer/StartText.modulate.a = 1.0 if main_menu_index == 0 else 0.25
	$UI/MarginContainer/VBoxContainer/ExtraText.modulate.a = 1.0 if main_menu_index == 1 else 0.25
	$UI/MarginContainer/VBoxContainer/OptionsText.modulate.a = 1.0 if main_menu_index == 2 else 0.25
	$UI/MarginContainer/VBoxContainer/QuitText.modulate.a = 1.0 if main_menu_index == 3 else 0.25
	
	# Options menu setup
	$UI/OptionsMenu/BGMText.modulate.a = 1.0 if options_menu_index == 0 else 0.25
	$UI/OptionsMenu/SFXText.modulate.a = 1.0 if options_menu_index == 1 else 0.25
	$UI/OptionsMenu/FullscreenText.modulate.a = 1.0 if options_menu_index == 2 else 0.25
	
	$UI/OptionsMenu/BGMSlider.value = db2linear(AudioServer.get_bus_volume_db(1))
	$UI/OptionsMenu/SFXSlider.value = db2linear(AudioServer.get_bus_volume_db(2))
	$UI/OptionsMenu/FullscreenCheckBox.pressed = OS.window_fullscreen
	
	# Window setup
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	# Background scroll offset randomization
	$ParallaxBackground.scroll_offset.y = rand_range(0, 1080)


func _process(delta: float) -> void:
	# Background Scrolling
	$ParallaxBackground.scroll_offset.y -= delta * 10.0
	
	# Menu Input
	if is_options_showing:
		if Input.is_action_just_pressed("ui_up"):
			options_menu_index -= 1
			
			if options_menu_index < 0:
				options_menu_index = 2
			
			$UI/OptionsMenu/BGMText.modulate.a = 1.0 if options_menu_index == 0 else 0.25
			$UI/OptionsMenu/SFXText.modulate.a = 1.0 if options_menu_index == 1 else 0.25
			$UI/OptionsMenu/FullscreenText.modulate.a = 1.0 if options_menu_index == 2 else 0.25
			
			SFXPlayer.play_sound(soundEffects[0])
		
		if Input.is_action_just_pressed("ui_down"): 
			options_menu_index += 1
			
			if options_menu_index > 2:
				options_menu_index = 0
			
			$UI/OptionsMenu/BGMText.modulate.a = 1.0 if options_menu_index == 0 else 0.25
			$UI/OptionsMenu/SFXText.modulate.a = 1.0 if options_menu_index == 1 else 0.25
			$UI/OptionsMenu/FullscreenText.modulate.a = 1.0 if options_menu_index == 2 else 0.25
			
			SFXPlayer.play_sound(soundEffects[0])
		
		if Input.is_action_just_pressed("ui_left"):
			if options_menu_index == 0:
				$UI/OptionsMenu/BGMSlider.value -= 0.1
				AudioServer.set_bus_volume_db(1, linear2db($UI/OptionsMenu/BGMSlider.value))
			if options_menu_index == 1:
				$UI/OptionsMenu/SFXSlider.value -= 0.1
				AudioServer.set_bus_volume_db(2, linear2db($UI/OptionsMenu/SFXSlider.value))
			
			SFXPlayer.play_sound(soundEffects[0])
		
		if Input.is_action_just_pressed("ui_right"):
			if options_menu_index == 0:
				$UI/OptionsMenu/BGMSlider.value += 0.1
				AudioServer.set_bus_volume_db(1, linear2db($UI/OptionsMenu/BGMSlider.value))
			if options_menu_index == 1:
				$UI/OptionsMenu/SFXSlider.value += 0.1
				AudioServer.set_bus_volume_db(2, linear2db($UI/OptionsMenu/SFXSlider.value))
			
			SFXPlayer.play_sound(soundEffects[0])
		
		if Input.is_action_just_pressed("ui_accept"):
			if options_menu_index == 2:
				SFXPlayer.play_sound(soundEffects[1])
				OS.window_fullscreen = !OS.window_fullscreen
				$UI/OptionsMenu/FullscreenCheckBox.pressed = OS.window_fullscreen
				
				Input.action_release("ui_accept") # since it wants to hold accept until a new event b/c the screen change, this releases it!
		
		if Input.is_action_just_pressed("ui_cancel"):
			# Save our settings
			var file = File.new()
			file.open(config_file, File.WRITE)
			file.store_var(AudioServer.get_bus_volume_db(1))
			file.store_var(AudioServer.get_bus_volume_db(2))
			file.store_var(OS.window_fullscreen)
			file.close()
			
			is_options_showing = false
			$UI/OptionsMenu/AnimationPlayer.play("hide")
			SFXPlayer.play_sound(soundEffects[2])
		
		return
	
	if Input.is_action_just_pressed("ui_up"):
		main_menu_index -= 1
		
		if main_menu_index < 0:
			main_menu_index = 3
		
		$UI/MarginContainer/VBoxContainer/StartText.modulate.a = 1.0 if main_menu_index == 0 else 0.25
		$UI/MarginContainer/VBoxContainer/ExtraText.modulate.a = 1.0 if main_menu_index == 1 else 0.25
		$UI/MarginContainer/VBoxContainer/OptionsText.modulate.a = 1.0 if main_menu_index == 2 else 0.25
		$UI/MarginContainer/VBoxContainer/QuitText.modulate.a = 1.0 if main_menu_index == 3 else 0.25
		
		SFXPlayer.play_sound(soundEffects[0])
	
	if Input.is_action_just_pressed("ui_down"):
		main_menu_index += 1
		
		if main_menu_index > 3:
			main_menu_index = 0
		
		$UI/MarginContainer/VBoxContainer/StartText.modulate.a = 1.0 if main_menu_index == 0 else 0.25
		$UI/MarginContainer/VBoxContainer/ExtraText.modulate.a = 1.0 if main_menu_index == 1 else 0.25
		$UI/MarginContainer/VBoxContainer/OptionsText.modulate.a = 1.0 if main_menu_index == 2 else 0.25
		$UI/MarginContainer/VBoxContainer/QuitText.modulate.a = 1.0 if main_menu_index == 3 else 0.25
		
		SFXPlayer.play_sound(soundEffects[0])
	
	if Input.is_action_just_pressed("ui_accept"):
		if main_menu_index == 0:
			SFXPlayer.play_sound(soundEffects[1])
			SceneManager.change_scene("res://levels/power_selection/power_selection.tscn")
		if main_menu_index == 1:
			SFXPlayer.play_sound(soundEffects[3])
			pass # this will be for extra! :)
		if main_menu_index == 2:
			SFXPlayer.play_sound(soundEffects[1])
			$UI/OptionsMenu/AnimationPlayer.play("show")
			is_options_showing = true
		if main_menu_index == 3:
			get_tree().quit(-1)
	
	if Input.is_action_just_pressed("ui_cancel"):
		main_menu_index = 3
		
		$UI/MarginContainer/VBoxContainer/StartText.modulate.a = 1.0 if main_menu_index == 0 else 0.25
		$UI/MarginContainer/VBoxContainer/ExtraText.modulate.a = 1.0 if main_menu_index == 1 else 0.25
		$UI/MarginContainer/VBoxContainer/OptionsText.modulate.a = 1.0 if main_menu_index == 2 else 0.25
		$UI/MarginContainer/VBoxContainer/QuitText.modulate.a = 1.0 if main_menu_index == 3 else 0.25
		
		SFXPlayer.play_sound(soundEffects[2])
