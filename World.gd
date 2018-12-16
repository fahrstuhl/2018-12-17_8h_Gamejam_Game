extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var mob = preload("res://Mob.tscn")
var item = preload("res://Item.tscn")

func _ready():
	Network.connect("object_received", self, "add_object")

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func add_object(object_dict):
	var name = object_dict["name"]
	var sprite
	match name:
		"acception":
			sprite = mob.instance()
			sprite.mob_type = "Krampus"
		"rejection":
			sprite = item.instance()
			sprite.item_type = ("Cookie" if randi()%2 else "Hat")
		"reindeer":
			sprite = mob.instance()
			sprite.mob_type = "Grinch"
		"Hat", "Cookie":
			sprite = item.instance()
			sprite.start_timer = true
			sprite.item_type = name
			
	sprite.position = object_dict["pos"]
	sprite.velocity = object_dict["vel"]
	add_child(sprite)