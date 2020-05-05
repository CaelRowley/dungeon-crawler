extends AudioStreamPlayer


func _on_PlayerHurtSound_finished():
	connect("finished", self, "queue_free")
