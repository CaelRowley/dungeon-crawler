extends MenuButton

var stats = PlayerStats

func _on_MenuButton_pressed():
	stats.setHealth(3)
	get_tree().change_scene("res://World.tscn")
