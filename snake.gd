extends Node2D

const GRID_SIZE = 20
const BODY_COLOR = Color.LIGHT_GREEN
const HEAD_COLOR = Color.GREEN

var body_segments = []  # Array of Vector2i positions
var direction = Vector2i(1, 0)  # Initial direction: right
var next_direction = Vector2i(1, 0)  # Buffer for next direction
var game_over = false

func _ready():
	# Initialize snake with 3 segments at center of screen
	body_segments = [
		Vector2i(20, 15),  # Head at center (40x30 grid center)
		Vector2i(19, 15),  # Body segment 1
		Vector2i(18, 15)   # Body segment 2
	]

func _process(_delta):
	if not game_over:
		handle_input()

func _physics_process(_delta):
	if not game_over:
		move_snake()

func handle_input():
	if Input.is_action_pressed("ui_right") and direction != Vector2i(-1, 0):
		next_direction = Vector2i(1, 0)
	elif Input.is_action_pressed("ui_left") and direction != Vector2i(1, 0):
		next_direction = Vector2i(-1, 0)
	elif Input.is_action_pressed("ui_down") and direction != Vector2i(0, -1):
		next_direction = Vector2i(0, 1)
	elif Input.is_action_pressed("ui_up") and direction != Vector2i(0, 1):
		next_direction = Vector2i(0, -1)

func move_snake():
	direction = next_direction
	
	# Calculate new head position
	var new_head = body_segments[0] + direction
	
	# Check grid boundaries (40x30 grid)
	if new_head.x < 0 or new_head.x >= 40 or new_head.y < 0 or new_head.y >= 30:
		trigger_game_over()
		return
	
	# Check self collision
	if new_head in body_segments:
		trigger_game_over()
		return
	
	# Add new head
	body_segments.insert(0, new_head)
	
	# Check if food is eaten
	if get_parent().food.position_grid == new_head:
		get_parent().food.respawn()
		get_parent().update_score()
	else:
		# Remove tail if no food eaten
		body_segments.pop_back()
	
	queue_redraw()

func draw_snake():
	# Draw head
	var head_pos = body_segments[0] * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2)
	draw_circle(head_pos, GRID_SIZE / 2 - 1, HEAD_COLOR)
	
	# Draw body
	for i in range(1, body_segments.size()):
		var segment_pos = body_segments[i] * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2)
		draw_circle(segment_pos, GRID_SIZE / 2 - 1, BODY_COLOR)

func _draw():
	draw_snake()

func trigger_game_over():
	game_over = true
	get_parent().show_game_over()

func reset():
	# Reset snake to center position
	body_segments = [
		Vector2i(20, 15),  # Head at center
		Vector2i(19, 15),  # Body segment 1
		Vector2i(18, 15)   # Body segment 2
	]
	direction = Vector2i(1, 0)
	next_direction = Vector2i(1, 0)
	game_over = false
	queue_redraw()
