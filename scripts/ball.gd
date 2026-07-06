extends CharacterBody2D

# Ball properties
@export var initial_speed = 400.0
@export var max_speed = 800.0
@export var speed_multiplier = 1.02
var direction = Vector2.ZERO

func _ready():
	# Start the ball moving in a random diagonal direction
	randomize()
	direction = Vector2(randf_range(-1, 1), -1).normalized()
	velocity = direction * initial_speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		# Get the collision normal and bounce the ball
		var normal = collision.get_normal()
		velocity = velocity.bounce(normal)
		
		# Play bounce sound (optional)
		#$BounceSound.play()
		
		velocity = (velocity * speed_multiplier).limit_length(max_speed)

		var collider = collision.get_collider()
		if collider.has_method("hit"):
			collider.hit()

func reset_ball():
	# Reset ball to starting position (adjust position as needed)
	position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y * 0.7)
	direction = Vector2(randf_range(-1, 1), -1).normalized()
	velocity = direction * initial_speed
