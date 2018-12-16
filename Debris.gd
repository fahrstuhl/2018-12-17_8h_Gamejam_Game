extends Node2D

export(String,"Krampus","Grinch") var debris_type

var velocity = Vector2(0,0)

func _ready():
	$Tween.interpolate_property(self, "velocity", velocity, velocity*0.1, 2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	$Sprite.texture = ImageTexture.new()
	if debris_type == "Krampus":
		$Sprite.texture.load("res://assets/Krampus_horn.png")
	elif debris_type == "Grinch":
		$Sprite.texture.load("res://assets/Grinch_ear.png")

func _process(delta):
	position += velocity

func send_myself():
	var object_dict = {
		"name": debris_type,
		"pos": position,
		"vel": velocity,
		}
	Network.send_object(object_dict)
	queue_free()

func despawn():
	send_myself()
