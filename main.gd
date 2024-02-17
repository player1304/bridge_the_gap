extends Node2D

const MAX_POINTS : int = 5 # user cannot input more than this amount

var test_pts : PackedVector2Array = [Vector2(100,100), Vector2(250,150)]
var test_pts2 : PackedVector2Array = [Vector2(200,50), Vector2(300,50), Vector2(300,100), Vector2(200,140), Vector2(250, 100)]

# the points inputted by user
var user_input_pts : PackedVector2Array = []

func _ready():
	
	#draw_shape(test_pts)
	#draw_shape(test_pts2)
	pass
	
func _unhandled_input(event):
	# Takes user mouse input, and returns a PackedVector2Array for draw_shape
	if event is InputEventMouseButton and event.is_pressed():
		var click_pos : Vector2 = event.position
		print("mouse pressed at %s" % click_pos)
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				#print("left to add")
				get_viewport().set_input_as_handled()
				user_input_pts.append(click_pos) # add a point
				
				# check if the user still has "ink" available
				if user_input_pts.size() < MAX_POINTS: # still have capacity:
					if user_input_pts.size() >= 2:
						var last_two_pts : PackedVector2Array = [user_input_pts[-2], user_input_pts[-1]]
						print("Last two points are %s" % last_two_pts)
						
						# draw a line2d for user_input_pts[-2] and [-1]
						draw_temp_lines(last_two_pts)
						
				else: # maxed out, draw the damn thing and clear
					print("maxed out! draw now")
					draw_shape(user_input_pts)
					clean_temp_lines()
			MOUSE_BUTTON_RIGHT:
				#print("right to draw")
				get_viewport().set_input_as_handled()
				user_input_pts.append(click_pos) # add a point
				draw_shape(user_input_pts)
				clean_temp_lines()

func draw_shape(pts_array : PackedVector2Array) -> void:
	'''Takes in an array of points, draws a shape with collision and gravity'''
	# RigidBody2D
	# - Line2D
	# - CollisionPolygon2D
	
	var size_of_array : int = pts_array.size()
	
	# root node of the new shape
	var r : RigidBody2D = RigidBody2D.new()
	
	# calculate and set r.position to CoG
	var x_cords : Array = []
	var y_cords : Array = []
	for i in size_of_array:
		x_cords.append(pts_array[i].x)
		y_cords.append(pts_array[i].y)
	var avg_x : float = (x_cords.max() + x_cords.min()) / 2
	var avg_y : float = (y_cords.max() + y_cords.min()) / 2
	var center_of_g = Vector2(avg_x, avg_y)
	print("Center of G and origin at %s" % center_of_g)
	r.position = center_of_g
	
	# translate pts_array from global to local to CoG
	for i in size_of_array:
		pts_array[i] -= center_of_g
	print("Points local pos: %s" % pts_array)
	
	# draw the visible lines
	var outlines : Line2D = Line2D.new()
	outlines.set_points(pts_array)
	#l.width = 5
	r.add_child(outlines)

	# create collision
	if size_of_array == 2: # only a line
		var c : CollisionShape2D = CollisionShape2D.new()
		var line = SegmentShape2D.new()
		line.a = pts_array[0]
		line.b = pts_array[1]
		c.set_shape(line)
		r.add_child(c)
	else: # a polygon
		var c : CollisionPolygon2D = CollisionPolygon2D.new()
		c.set_build_mode(CollisionPolygon2D.BUILD_SOLIDS)
		c.set_polygon(pts_array)
		r.add_child(c)
		
	add_child(r) # create the rigidbody2D

func clean_temp_lines() -> void:
	'''Removes all temp lines during drawing phase'''
	user_input_pts = []
	print(get_tree().get_nodes_in_group("DrawingLines"))
	for line : Line2D in get_tree().get_nodes_in_group("DrawingLines"):
		line.queue_free()

func draw_temp_lines(last_two_pts : PackedVector2Array):
	var latest_line : Line2D = Line2D.new()
	latest_line.set_points(last_two_pts)
	latest_line.width = 1
	latest_line.add_to_group("DrawingLines") # will be cleaned when drawing the actual shape
	add_child(latest_line)
