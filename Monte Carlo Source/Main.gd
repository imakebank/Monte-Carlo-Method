extends Node2D

var buttonToggled = false

var dot_position = Vector2(0, 0)
var Dot = load("res://Dots.tscn")
var RedDot = load("res://RedDots.tscn")
var completed = false

var dots_in = 0
var dots_out = 0

var rect_size = []

func _ready():
	randomize()
	for a in get_tree().get_nodes_in_group('Dots'):
		a.queue_free()
	$Graph.texture = Globals.image
	$Graph.position = Vector2(0, 0)
	$Graph.centered = false
	rect_size = [$Graph.texture.get_width(), $Graph.texture.get_height()]
	$Dots.text = str(Globals.dots)
	$File.text = Globals.filepath
	
# https://www.reddit.com/r/godot/comments/8yfjhq/comment/e2ajad3/?utm_source=share&utm_medium=web2x&context=3
func pixel_check(x, y):
	var data = Globals.image.get_data()
	data.lock()
	return data.get_pixel(x, y)[2]

func _process(delta):
	if not completed:
		for dot in range(Globals.dots):
			var dot_position = [rand_range(0, rect_size[0]), rand_range(0, rect_size[1])]
			if pixel_check(dot_position[0], dot_position[1]) == 0:
				spawn_dot(dot_position[0], dot_position[1], 'black') 
				dots_in += 1
			else:
				spawn_dot(dot_position[0], dot_position[1], 'red')
				dots_out += 1
		$"Dots inside".text = "Dots inside: " + str(dots_in)
		$"Dots outside".text = "Dots outside: " + str(dots_out)
		completed = true

	
func spawn_dot(position_x, position_y, colour):
	if colour == 'black':
		var dot = Dot.instance()
		get_parent().add_child(dot)
		dot.global_position = Vector2(position_x, position_y)
		dot.add_to_group('Dots')
	elif colour == 'red':
		var dot = RedDot.instance()
		get_parent().add_child(dot)
		dot.global_position = Vector2(position_x, position_y)
		dot.add_to_group('Dots')
		
# https://www.reddit.com/r/godot/comments/ox381i/comment/h7mric4/?utm_source=share&utm_medium=web2x&context=3
func load_external_tex(path):
	var tex_file = File.new()
	tex_file.open(path, File.READ)
	var bytes = tex_file.get_buffer(tex_file.get_len())
	var img = Image.new()
	var data = img.load_png_from_buffer(bytes)
	var imgtex = ImageTexture.new()
	imgtex.create_from_image(img)
	tex_file.close()
	return imgtex
		
func _on_Reload_pressed():
	Globals.filepath = $File.text
	if $File.text != '':
		Globals.image = load_external_tex(Globals.filepath)
	Globals.dots = $Dots.text
	get_tree().change_scene("res://Main.tscn")
	



