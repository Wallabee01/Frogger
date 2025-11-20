extends Obstacle

const COLOR_YELLOW: Color = Color(247.0/255.0, 205.0/255.0, 118.0/255.0, 1.0)
const COLOR_RED: Color = Color(144.0/255.0, 40.0/255.0, 29.0/255.0, 1.0)
const COLOR_ORANGE: Color = Color(212.0/255.0, 109.0/255.0, 42.0/255.0, 1.0)
const COLOR_GREEN: Color = Color(90.0/255.0, 126.0/255.0, 110.0/255.0, 1.0)


func init(speed: float, flipped: bool):
	super.init(speed, flipped)
	
	var color_roll = randi_range(1, 4)
	match color_roll:
		1:
			$Sprite2D.modulate = COLOR_YELLOW
		2:
			$Sprite2D.modulate = COLOR_RED
		3:
			$Sprite2D.modulate = COLOR_ORANGE
		4:
			$Sprite2D.modulate = COLOR_GREEN
