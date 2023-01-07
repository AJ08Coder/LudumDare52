extends RayCast2D

onready var line = $Line2D

var max_distance = 1000

func _ready():
	cast_to = Vector2(max_distance, 0)
	
func _physics_process(delta):
	if is_colliding():
		var coll_point = to_local(get_collision_point())
		line.points[1].x = coll_point.x 
		if get_collider().is_in_group("Enemy"):
			get_collider().state = get_collider().CURING
