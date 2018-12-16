extends Node2D

export(String, "Hat", "Cookie") var item_type = "Hat"
var velocity = Vector2(0,0)
var start_timer = false
signal collected

func _ready():
	$Sprite.texture = ImageTexture.new()
	$Sprite.texture.load("res://assets/"+item_type+".png")
	$Sprite.modulate = Color(0.5,0,0)
	if item_type == "Hat":
		$Physics/Cookie.disabled = true
	elif item_type == "Cookie":
		$Physics/Hat.disabled = true
	if start_timer:
		$DespawnTimer.start()
		$Physics/Hat.disabled = true
		$Physics/Cookie.disabled = true
	$Tween.interpolate_property(self, "velocity", velocity, Vector2(0, 0), 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()
	var player = get_node("/root/World/Player")
	connect("collected", player, "item_collected")

func _process(delta):
	position += velocity
	
func send_myself():
	var object_dict = {
		"name": item_type,
		"pos": position,
		"vel": velocity,
		}
	Network.send_object(object_dict)
	queue_free()

func _on_Physics_body_entered(body):
	if body.name == "Player":
		emit_signal("collected", item_type)
		queue_free()
