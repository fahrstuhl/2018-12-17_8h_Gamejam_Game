extends Node2D

export(String, "Krampus", "Grinch") var mob_type

var debris = preload("res://Debris.tscn")

var velocity = Vector2(0,0)
var health = 2
enum {FOLLOWING, HIT}
var state = FOLLOWING

func _process(delta):
	if health <= 0:
		queue_free()
	if state == FOLLOWING:
		position += velocity
	velocity = (position - get_node("/root/World/Player").global_position).normalized() * -3

func _ready():
	$Sprite.texture = ImageTexture.new()
	$Sprite.texture.load("res://assets/"+mob_type+".png")
	if mob_type == "Krampus":
		$Physics/Grinch.disabled = true
	elif mob_type == "Grinch":
		$Physics/Krampus.disabled = true

func hit(body):
	if body.name == "Sword":
		state = HIT
		$HitCooldown.start()
		$Physics.monitoring = false
		$Sprite.modulate = Color(1,0,0)
		print("hit")
		var drop = debris.instance()
		health -= 1
		var a = randf()*4*PI
		drop.position = position
		drop.velocity = Vector2(sin(a),cos(a))*10
		drop.debris_type = mob_type
		get_node("/root/World").add_child(drop)
		print(position)
		var hit_pos = body.global_position
		print(hit_pos)
		var hit_dir = position.angle_to_point(hit_pos)
		print(hit_dir)
		var goal_pos = position + Vector2(sin(hit_dir), cos(hit_dir))*500
		print(goal_pos)
		$Tween.interpolate_property(self, "position", position, goal_pos, 1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.start()
	elif body.name == "Player" and not state == HIT:
		get_node("/root/World/Player").hit(mob_type)

func _on_HitCooldown_timeout():
	state = FOLLOWING
	$Physics.monitoring = true
	$Sprite.modulate = Color(1,1,1)
