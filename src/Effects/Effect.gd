extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "onAnimationFinished")
	frame = 0
	play("Animate")


func onAnimationFinished():
	queue_free()
