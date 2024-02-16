extends Node2D
var pts : PackedVector2Array = [Vector2(100,100), Vector2(200,150), Vector2(150,150)]
var pts2 : PackedVector2Array = [Vector2(200,50), Vector2(300,50), Vector2(300,100), Vector2(200,140), Vector2(250, 100)]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	draw_shape(pts2)
	pass
	

func draw_shape(pts_array : PackedVector2Array):
	# RigidBody2D
	# - Line2D
	# - CollisionPolygon2D
	
	var size_of_array : int = pts_array.size()
	
	# root node of the new shape
	var r : RigidBody2D = RigidBody2D.new()
	
	# calculate and set r.position to CoG
	var x_cords : Array
	var y_cords : Array
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
	var l : Line2D = Line2D.new()
	l.set_points(pts_array)
	#l.width = 5
	r.add_child(l)

	# create collision
	var c : CollisionPolygon2D = CollisionPolygon2D.new()
	c.set_build_mode(CollisionPolygon2D.BUILD_SOLIDS)
	c.set_polygon(pts_array)
	r.add_child(c)
		
	add_child(r) # create the rigidbody2D
