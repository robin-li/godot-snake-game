extends Node

# Test runner for Snake Game
# Run this script to test the game functionality

var test_results = []
var game_manager
var snake
var food

func _ready():
	game_manager = get_parent()
	snake = game_manager.snake
	food = game_manager.food
	
	# Run tests
	run_tests()
	
	# Print results
	print_test_results()

func run_tests():
	print("\n=== STARTING SNAKE GAME TESTS ===\n")
	
	# Test 1: Snake movement
	test_snake_movement()
	
	# Test 2: Food collision
	test_food_collision()
	
	# Test 3: Death detection
	test_death_detection()
	
	# Test 4: Game reset
	test_game_reset()
	
	# Test 5: Boundary values
	test_boundary_values()
	
	print("\n=== TESTS COMPLETED ===\n")

func test_snake_movement():
	print("TEST 1: Snake Movement")
	var initial_head = snake.body_segments[0]
	print("  Initial head position: ", initial_head)
	
	# Simulate movement
	for i in range(5):
		snake.move_snake()
		await get_tree().process_frame
	
	var new_head = snake.body_segments[0]
	print("  New head position after 5 moves: ", new_head)
	print("  Distance moved: ", initial_head.distance_to(new_head))
	
	if initial_head != new_head:
		add_test_result("TC-001-1: Snake moves right", "PASS")
		print("  ✓ PASS: Snake moved successfully\n")
	else:
		add_test_result("TC-001-1: Snake moves right", "FAIL")
		print("  ✗ FAIL: Snake did not move\n")

func test_food_collision():
	print("TEST 2: Food Collision")
	
	# Reset game
	game_manager.reset_game()
	
	# Get initial score
	var initial_score = game_manager.score
	var initial_length = snake.body_segments.size()
	
	print("  Initial score: ", initial_score)
	print("  Initial snake length: ", initial_length)
	
	# Position food at snake head for testing
	var head_pos = snake.body_segments[0]
	food.position_grid = head_pos
	print("  Food positioned at: ", food.position_grid)
	
	# Move snake towards food
	snake.move_snake()
	
	# Wait a frame
	await get_tree().process_frame
	
	var new_score = game_manager.score
	var new_length = snake.body_segments.size()
	
	print("  New score: ", new_score)
	print("  New snake length: ", new_length)
	
	if new_score == initial_score + 10 and new_length == initial_length + 1:
		add_test_result("TC-002-1: Food collision increases score and length", "PASS")
		print("  ✓ PASS: Food collision working correctly\n")
	else:
		add_test_result("TC-002-1: Food collision increases score and length", "FAIL")
		print("  ✗ FAIL: Food collision not working\n")

func test_death_detection():
	print("TEST 3: Death Detection")
	
	# Reset game
	game_manager.reset_game()
	
	# Test boundary collision
	snake.body_segments[0] = Vector2i(-1, 15)  # Out of bounds
	var initial_game_over = snake.game_over
	
	snake.move_snake()
	
	if snake.game_over and not initial_game_over:
		add_test_result("TC-003-1: Boundary collision triggers game over", "PASS")
		print("  ✓ PASS: Boundary collision detected\n")
	else:
		add_test_result("TC-003-1: Boundary collision triggers game over", "FAIL")
		print("  ✗ FAIL: Boundary collision not detected\n")
	
	# Test self collision
	game_manager.reset_game()
	snake.body_segments = [
		Vector2i(10, 10),
		Vector2i(9, 10),
		Vector2i(8, 10),
		Vector2i(9, 9)
	]
	snake.direction = Vector2i(0, 1)
	snake.next_direction = Vector2i(0, 1)
	snake.game_over = false
	
	snake.move_snake()
	
	if snake.game_over:
		add_test_result("TC-004-1: Self collision triggers game over", "PASS")
		print("  ✓ PASS: Self collision detected\n")
	else:
		add_test_result("TC-004-1: Self collision triggers game over", "FAIL")
		print("  ✗ FAIL: Self collision not detected\n")

func test_game_reset():
	print("TEST 4: Game Reset")
	
	# Play for a bit
	game_manager.reset_game()
	for i in range(10):
		snake.move_snake()
	
	# Eat some food
	game_manager.score = 100
	var long_body_size = snake.body_segments.size()
	
	print("  Score before reset: ", game_manager.score)
	print("  Snake length before reset: ", long_body_size)
	
	# Reset
	game_manager.reset_game()
	
	print("  Score after reset: ", game_manager.score)
	print("  Snake length after reset: ", snake.body_segments.size())
	
	if game_manager.score == 0 and snake.body_segments.size() == 3:
		add_test_result("TC-008-3: Game reset clears score and resets snake", "PASS")
		print("  ✓ PASS: Reset working correctly\n")
	else:
		add_test_result("TC-008-3: Game reset clears score and resets snake", "FAIL")
		print("  ✗ FAIL: Reset not working correctly\n")

func test_boundary_values():
	print("TEST 5: Boundary Value Testing")
	
	game_manager.reset_game()
	
	# Test top boundary
	snake.body_segments[0] = Vector2i(20, 0)
	snake.direction = Vector2i(0, -1)
	snake.next_direction = Vector2i(0, -1)
	snake.game_over = false
	
	snake.move_snake()
	if snake.game_over:
		add_test_result("TC-003-3: Top boundary collision", "PASS")
		print("  ✓ PASS: Top boundary detected\n")
	else:
		add_test_result("TC-003-3: Top boundary collision", "FAIL")
		print("  ✗ FAIL: Top boundary not detected\n")
	
	# Test bottom boundary
	game_manager.reset_game()
	snake.body_segments[0] = Vector2i(20, 29)
	snake.direction = Vector2i(0, 1)
	snake.next_direction = Vector2i(0, 1)
	snake.game_over = false
	
	snake.move_snake()
	if snake.game_over:
		add_test_result("TC-003-4: Bottom boundary collision", "PASS")
		print("  ✓ PASS: Bottom boundary detected\n")
	else:
		add_test_result("TC-003-4: Bottom boundary collision", "FAIL")
		print("  ✗ FAIL: Bottom boundary not detected\n")
	
	# Test left boundary
	game_manager.reset_game()
	snake.body_segments[0] = Vector2i(0, 15)
	snake.direction = Vector2i(-1, 0)
	snake.next_direction = Vector2i(-1, 0)
	snake.game_over = false
	
	snake.move_snake()
	if snake.game_over:
		add_test_result("TC-003-1: Left boundary collision", "PASS")
		print("  ✓ PASS: Left boundary detected\n")
	else:
		add_test_result("TC-003-1: Left boundary collision", "FAIL")
		print("  ✗ FAIL: Left boundary not detected\n")
	
	# Test right boundary
	game_manager.reset_game()
	snake.body_segments[0] = Vector2i(39, 15)
	snake.direction = Vector2i(1, 0)
	snake.next_direction = Vector2i(1, 0)
	snake.game_over = false
	
	snake.move_snake()
	if snake.game_over:
		add_test_result("TC-003-2: Right boundary collision", "PASS")
		print("  ✓ PASS: Right boundary detected\n")
	else:
		add_test_result("TC-003-2: Right boundary collision", "FAIL")
		print("  ✗ FAIL: Right boundary not detected\n")

func add_test_result(test_name: String, result: String):
	test_results.append({
		"name": test_name,
		"result": result
	})

func print_test_results():
	print("\n" + "="*50)
	print("TEST SUMMARY")
	print("="*50)
	
	var passed = 0
	var failed = 0
	
	for result in test_results:
		var status = "✓" if result["result"] == "PASS" else "✗"
		print("%s %s: %s" % [status, result["name"], result["result"]])
		
		if result["result"] == "PASS":
			passed += 1
		else:
			failed += 1
	
	print("\n" + "="*50)
	print("Total: %d PASS, %d FAIL" % [passed, failed])
	print("="*50 + "\n")
	
	# Save results to file
	save_results_to_file()

func save_results_to_file():
	# This will be implemented after testing
	pass
