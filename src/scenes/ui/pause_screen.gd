extends CanvasLayer

var is_active: bool = false


func _unhandled_input(event):
	if event.is_action_pressed("pause") && !is_active:
		is_active = true
		get_tree().paused = true
		visible = true
		get_tree().root.set_input_as_handled()
	elif event.is_action_pressed("pause") && is_active:
		is_active = false
		get_tree().paused = false
		visible = false
		get_tree().root.set_input_as_handled()


func _on_button_pressed():
	get_tree().quit()
