extends Sprite

var velocity = Vector2(0,0)
var mouse_over = false

func _ready():
	$Area2D.connect("mouse_entered",self,"_mouse_over", [true])
	$Area2D.connect("mouse_exited",self,"_mouse_over", [false])
	set_process_unhandled_input(true)

func _process(delta):
	position += velocity
	position.x = clamp(position.x, 0, Network.width)
	position.y = clamp(position.y, 0, Network.height)

func send_myself():
	var object_dict = {
		"name": "geschenk",
		"pos": position,
		"vel": velocity,
		}
	Network.send_object(object_dict)
	queue_free()

func _unhandled_input(event):
	if mouse_over and event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().set_input_as_handled() # Mark the current input event as "handled"
		clicked() #Executes your clicked function

func _mouse_over(over):
	self.mouse_over = over

func clicked():
	get_tree().set_input_as_handled()
	print("clicked")
	send_myself()
