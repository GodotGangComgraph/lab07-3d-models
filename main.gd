extends Control

var axonometric_matrix = F.AffineMatrices.get_axonometric_matrix(35.26, 45)
var perspective_matrix = F.AffineMatrices.get_perspective_matrix(-300)
var projection_matrix = axonometric_matrix

var hue_shift = 0.2
var color_speed = 0.1

var rotated_object

func _ready():
	rotated_object = F.RotationSurface.new()
	rotated_object.translate(200, 200, 0)  # Adjust position for better visualization
	queue_redraw()
	
func _draw() -> void:
	draw_by_faces(rotated_object)

func draw_by_faces(obj: F.Spatial):
	for face in obj.faces:
		var old_point = obj.points[face[0]].duplicate()
		old_point.apply_matrix(projection_matrix)
		
		var face_color = get_edge_color()
		
		for index in face.slice(1, face.size()):
			var p = obj.points[index].duplicate()
			p.apply_matrix(projection_matrix)
			draw_line(old_point.get_vec2d(), p.get_vec2d(), face_color, 0.5, true)
			old_point = p
		var first_point = obj.points[face[0]].duplicate()
		first_point.apply_matrix(projection_matrix)
		draw_line(first_point.get_vec2d(), old_point.get_vec2d(), face_color, 0.5, true)

func get_edge_color() -> Color:
	var dynamic_color = Color.from_hsv(hue_shift, 0.8, 0.9)
	return dynamic_color
