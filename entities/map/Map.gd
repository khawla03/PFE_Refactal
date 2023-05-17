extends GridMap


const DISCOVER_MAT = preload("res://assets/materials/discover_map_mat.tres")

var mats = [
	preload("res://assets/materials/Main.material"),
	preload("res://assets/materials/Accent.material"),
	preload("res://assets/materials/DarkAccent.material"),
	preload("res://assets/materials/Light.material"),
	preload("res://assets/materials/Black.material"),
	preload("res://assets/materials/DarkGrey.material"),
	preload("res://assets/materials/Pipes.material")
]
var albedos = []


func _ready():
	for mat in mats:
		if mat is SpatialMaterial:
			albedos.append(mat.albedo_color)

func set_discover_mode(enabled: bool):
	if enabled:
		for mat in mats:
			if mat is SpatialMaterial:
				mat.albedo_color = DISCOVER_MAT.albedo_color
	else:
		var i = 0
		for mat in mats:
			if mat is SpatialMaterial:
				mat.albedo_color = albedos[i]
				i += 1
	pass
