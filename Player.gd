extends Node2D

var sword_right = true
var velocity = Vector2(0,0)
var up = 0
var down = 0
var right = 0
var left = 0
var hats_collected = 0
var cookies_collected = 0

func _process(delta):
	velocity.y = up * -10 + down * 10
	velocity.x = left * -10 + right * 10
	position += velocity

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		swing()
	elif event is InputEventMouseMotion:
		look_at(event.position)
	elif event is InputEventKey:
		var p = int(event.pressed)
		match event.scancode:
			KEY_UP:
				up = p
			KEY_DOWN:
				down = p
			KEY_LEFT:
				left = p
			KEY_RIGHT:
				right = p

func hit(mob):
	var item_type
	match mob:
		"Grinch":
			hats_collected -= 1
			item_type = "Hat"
		"Krampus":
			cookies_collected -= 1
			item_type = "Cookie"
	var world = get_node("/root/World")
	var item_vel = Vector2((1 if velocity.x < 0 else -1) *10, (1 if velocity.y < 0 else -1)*10)
	world.add_object({ "name": item_type, "pos": global_position, "vel": item_vel})

func swing():
	if sword_right:
		$AnimationPlayer.play("Sword Swing Left")
		sword_right = false
	else:
		$AnimationPlayer.play("Sword Swing Left",-1,-1.0,true)
		sword_right = true

func item_collected(item):
	match item:
		"Hat":
			hats_collected += 1
			print(hats_collected)
		"Cookie":
			cookies_collected += 1
			print(cookies_collected)
