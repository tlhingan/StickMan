extends Area2D

export (int) var speed
var screensize
var can_jump = true
var kneeling = false
var jumping = false
var attack = false
var heading = 0

func start():
	show()
	pass

func _ready():
	hide()
	screensize = get_viewport_rect().size
	pass

func _process(delta):
	var velocity = Vector2()

	kneeling = false
	attack = false
	if position.y < 300:
		jumping = true
		velocity.y += 0.5
	if position.y > 300:
		can_jump = true
		jumping = false
	if Input.is_action_pressed("ui_right") and (!Input.is_action_pressed("ui_down") or jumping):
		velocity.x += 1
		kneeling = false
	if Input.is_action_pressed("ui_left") and (!Input.is_action_pressed("ui_down") or jumping):
		velocity.x -= 1
		kneeling = false
	if Input.is_action_pressed("ui_up") and can_jump == true:
		velocity.y -= 1
		kneeling = false
	if Input.is_action_pressed("ui_down"):
		kneeling = true
	if Input.is_action_pressed("ui_accept"):
		attack = true
	if velocity.y > 0 or position.y < 150:
		can_jump = false
	if velocity.length() > 0:
		if velocity.x != 0:
			heading = velocity.x
		velocity.x = velocity.x * 1 * speed
		velocity.y = velocity.y * 2 * speed
	position += velocity * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	if velocity.x != 0 and !kneeling and !attack:
		$AnimatedSprite.animation = "running_right"
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.x == 0 and !kneeling and !attack:
		$AnimatedSprite.animation = "standing_right"
		$AnimatedSprite.flip_h = heading < 0
	if velocity.y != 0 and !kneeling and !attack:
		$AnimatedSprite.animation = "jumping_right"
		$AnimatedSprite.flip_h = heading < 0
	if kneeling and !attack:
		$AnimatedSprite.animation = "kneeling_right"
		$AnimatedSprite.flip_h = heading < 0
	if velocity.x != 0 and !kneeling and attack:
		$AnimatedSprite.animation = "running_attack"
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.x == 0 and !kneeling and attack:
		$AnimatedSprite.animation = "standing_attack"
		$AnimatedSprite.flip_h = heading < 0
	if velocity.y != 0 and !kneeling and attack:
		$AnimatedSprite.animation = "running_attack"
		$AnimatedSprite.flip_h = heading < 0
	if kneeling and attack:
		$AnimatedSprite.animation = "kneeling_attack"
		$AnimatedSprite.flip_h = heading < 0
	$AnimatedSprite.play()
	pass