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
	
	while not valid_position:
		position_grid = Vector2i(
			rng.randi_range(0, 39),
			rng.randi_range(0, 29)
		)
		
		if position_grid not in snake_body:
			valid_position = true
	
	queue_redraw()

func draw_food():
	var food_pos = position_grid * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2)
	draw_circle(food_pos, GRID_SIZE / 2 - 2, FOOD_COLOR)

func _draw():
	draw_food()
