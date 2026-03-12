extends Node2D

const GRID_SIZE = 20
const FOOD_COLOR = Color.RED

var position_grid = Vector2i(15, 10)  # Initial food position
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	respawn()

func respawn():
	# Generate random position avoiding snake body
	var snake_body = get_parent().snake.body_segments
	var valid_position = false
	var grid_capacity = 40 * 30  # Total grid cells (1200)
	
	# Check if snake is too long (prevents infinite loop)
	if snake_body.size() >= grid_capacity:
		push_error("Cannot spawn food - snake occupies entire grid! Game is won!")
		# Trigger game won condition
		get_parent().show_game_won()
		return
	
	# Try to find a valid position with a maximum attempt limit
	var max_attempts = 100
	var attempts = 0
	
	while not valid_position and attempts < max_attempts:
		position_grid = Vector2i(
			rng.randi_range(0, 39),
			rng.randi_range(0, 29)
		)
		
		if position_grid not in snake_body:
			valid_position = true
		
		attempts += 1
	
	# If we couldn't find a valid position after max attempts, log error
	if not valid_position:
		push_warning("Food spawning: Could not find valid position after %d attempts" % max_attempts)
		# Try one more time with a full scan of the grid
		for x in range(40):
			for y in range(30):
				var pos = Vector2i(x, y)
				if pos not in snake_body:
					position_grid = pos
					valid_position = true
					break
			if valid_position:
				break
	
	queue_redraw()

func draw_food():
	var food_pos = (position_grid * GRID_SIZE).as_vector2() + Vector2(GRID_SIZE / 2.0, GRID_SIZE / 2.0)
	draw_circle(food_pos, GRID_SIZE / 2 - 2, FOOD_COLOR)

func _draw():
	draw_food()
