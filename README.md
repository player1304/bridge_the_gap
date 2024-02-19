## Bridge the Gap
A simple Godot 4 demo to learn:

- Player created physical objects

It will also be created by Godot 4.3 Dev 3 to try out the new html export.

### Gameplay
There are multiple levels where the player can draw shapes to bridge a gap for a ball to roll to the destination. Left mouse button will create a new point, and right mouse button will instantiate the shape.

### Coding logic
#### User-created objects
There are two phases in creating a shape: Drawing and Instantiating. As the player clicks, `_unhandled_input(event)` will check which phase the game is currently in.

In Drawing phase:
- new Line2D nodes are created as the player clicks on the screen. These temporary lines are added to a group "DrawingLines"
- Coordinates of clicks (`click_pos`) are appended to `user_input_pts` for use in the Instantiating phase

In Instantiating phase:
- A new shape object r (RigidBody2D) is created
- Center of Gravity (COG) is calculated by using the average of max and min of user-inputted x and y coordinates. COG will be the position of the RigidBody2D
- `user_input_pts` is converted from global to local to the COG
- Lines are drawn again using `Line2D.set_points(pts_array)`, which is then added to the RigidBody2D
- Collision is created by either:
    - a CollisionShape2D (if only 2 points are used) with a SegmentShape2D shape, or
    - a CollisionPolygon2D (if there are more than 2 points)
- At last, nodes in the group DrawingLines are removed

#### Level change
- When a level button is clicked:
    - Current level is removed by queue_free()
    - Corresponding new level is instantiated and added to root
    - Game is unpaused
- When winning condition is triggered:
    - Pauses the entire game by `get_tree().paused = true`
