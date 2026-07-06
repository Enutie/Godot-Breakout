extends Node2D

var brick := preload("res://scenes/brick.tscn")
@export var gap_size := 10
@export var start_position := Vector2(105, 50)
@export var number_of_bricks := 16
@export var rows := 8  # Adding rows for traditional Breakout layout

var lives := 3
var game_over := false
var score := 0

func _on_brick_destroyed(points: int) -> void:
	score += points
	%ScoreLabel.text = "SCORE %d" % score


func generate_bricks():
	var viewport_width = get_viewport_rect().size.x
	var playable_width = viewport_width - (1.5 * start_position.x)  # Account for margins
	
	# Calculate brick width based on available space and gaps
	var total_gap_space = gap_size * (number_of_bricks - 1)
	var brick_width = (playable_width - total_gap_space) / number_of_bricks
	
	# Create a grid of bricks
	for row in rows:
		var current_y = start_position.y + (row * (gap_size + 20))  # 20 is brick height
		
		for col in number_of_bricks:
			var brick_instance: StaticBody2D = brick.instantiate()
			brick_instance.destroyed.connect(_on_brick_destroyed)

			
			# Calculate position for each brick
			var x_pos = start_position.x + (col * (brick_width + gap_size))
			brick_instance.position = Vector2(x_pos, current_y)
			
			# Adjust collision shape and sprite
			var collision_shape = brick_instance.get_node("CollisionShape2D")
			var sprite = brick_instance.get_node("Sprite2D")
			
			if collision_shape.shape is RectangleShape2D:
				# Assuming the original sprite and collision shape are 1 unit wide
				sprite.scale.x = brick_width
				collision_shape.shape.size.x = brick_width
			
			# Optional: Assign different colors per row
			var colors = [Color.RED, Color.ORANGE, Color.GREEN, Color.YELLOW]
			if sprite:
				sprite.modulate = colors[row % colors.size()]
			
			add_child(brick_instance)

func _ready():
	generate_bricks()
	


func _on_death_zone_body_entered(body: Node2D) -> void:
	if not body.has_method("reset_ball"):
		return
	lives -= 1
	%LivesLabel.text = "LIVES %d" % lives
	if lives > 0:
		body.reset_ball()
	else:
		body.queue_free()
		game_over = true
		%GameOverLabel.visible = true

func _unhandled_input(event: InputEvent) -> void:
	if game_over and event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
