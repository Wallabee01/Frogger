extends Obstacle

const color_yellow: Color = Color(247.0/255.0, 205.0/255.0, 118.0/255.0, 1.0)
const color_red: Color = Color(144.0/255.0, 40.0/255.0, 29.0/255.0, 1.0)
const color_orange: Color = Color(212.0/255.0, 109.0/255.0, 42.0/255.0, 1.0)
const color_green: Color = Color(90.0/255.0, 126.0/255.0, 110.0/255.0, 1.0)


func init(speed: float):
		super.init(speed)
		
		var rng = randf()
		if rng >= 0 && rng < 0.25:
			modulate = color_yellow
		elif rng >= 0.25 && rng < 0.50:
			modulate = color_red
		elif rng >= 0.50 && rng < 0.75:
			modulate = color_orange
		elif rng >= 0.75 && rng <= 1.0:
			modulate = color_green
