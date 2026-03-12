extends Node2D

var score = 0
var snake: Node2D
var food: Node2D
var game_over_label: Label
var score_label: Label

func _ready():
	# Get references to nodes
	snake = $Snake
	food = $Food
	game_over_label = $UI/GameOverLabel
	score_label = $UI/ScoreLabel
	
	# Set window size for grid (40x30 grid with 20px cells = 800x600)
	get_window().size = Vector2i(800, 600)
	
	update_score_label()

func _process(_delta):
	if game_over_label.visible and Input.is_action_pressed("ui_select"):
		reset_game()

func update_score():
	score += 10
	update_score_label()

func update_score_label():
	score_label.text = "Score: %d" % score

func show_game_over():
	game_over_label.visible = true

func show_game_won():
	# Show game won message (snake fills entire grid)
	game_over_label.text = "YOU WIN!\nSnake filled the entire grid!\nPress SPACE to restart"
	game_over_label.visible = true
	snake.game_over = true

func reset_game():
	score = 0
	game_over_label.text = "GAME OVER\nPress SPACE to restart"
	game_over_label.visible = false
	snake.reset()
	food.respawn()
	update_score_label()
