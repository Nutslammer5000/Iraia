extends CharacterBody2D


@export var SPEED = 350.0
@export var JUMP_VELOCITY = -450.0
@export var ACCERLERATION : = 15.0 #these are the different variables for the starts of the player character
@export var jumps = 2

enum state {IDLE, RUNNING, JUMPUP, JUMPDOWN, HURT} #these are the different states the main character, also for animations

var anim_state = state.IDLE #basic idle state you start in

@onready var animator = $AnimatedSprite2D #helps animate the player
@onready var animation_player = $AnimationPlayer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") #to help with platforming making sure there is gravity

func update_state(): #these are for playing all the different states as animations
	if anim_state == state.HURT:
		return
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.IDLE
		elif velocity.x != 0:
			anim_state = state.RUNNING
	else:
		if velocity.y < 0:
			anim_state = state.JUMPUP
		else:
			anim_state = state.JUMPDOWN

func update_animation(direction):  #this makes the animations work by telling the game when you play them
	if direction > 0:
		animator.flip_h = true
	elif direction < 0:
		animator.flip_h = false
	match anim_state:
		state.IDLE:
			animation_player.play("idle")
		state.RUNNING:
			animation_player.play("run")
		state.JUMPUP:
			animation_player.play("jump_up")
		state.JUMPDOWN:
			animation_player.play("jump_down")
		state.HURT:
			animation_player.play("hurt")

func _physics_process(delta): #jumping code 
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x,direction*SPEED, ACCERLERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCERLERATION)
	update_state()
	update_animation(direction)
	move_and_slide()
	
	


func _on_area_2d_body_entered(body: Node2D) -> void: #This means when you touch bad stuff it kills you
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()


func _on_area_2d_2_body_entered(body: Node2D) -> void: #same thing, code to kill you, but for level2
	if body.is_in_group("Player"):
		get_tree().change_scene_to_file("res://level_2.tscn")
