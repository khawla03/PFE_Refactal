class_name Item, "res://assets/icons/item.svg"
extends StaticBody


signal parse_status_changed(parser)

const HIGHLIGHT_NEXT_PASS = preload("res://assets/shaders/highlight.tres")
const SCRIPT_FOLDER = "user://temp"

const CODE_TEMPLATE = """extends Code\n\n
# Called when you apply the code
func _init():\n	\n	pass\n\n"""

export(Script) var code: Script
export(String) var display_name := ""
export(String) var description := ""
export(bool) var is_programmable : bool
export(bool) var is_interactable : bool
export(String) var interaction_message := ""
export(bool) var locked := false
export(bool) var built_in = true
export(String, MULTILINE) var starting_script

var sound_player
var starting_source_code: String
var staged_srouce_code: String
var icon : Texture = preload("res://assets/icons/ic_item.png")
var animation : AnimationPlayer
var parser #= GDScriptParserWrap.new()
var has_error := false
var error := ""
var error_line := -1
var error_column := -1
var highlight_meshes := []
var path: String


func _ready():
	add_to_group("Item")
	if is_interactable:
		add_to_group("Interactable")

	if is_programmable:
		add_to_group("Programmable")
		if type_exists("GDScriptParserWrap"):
			parser = ClassDB.instance("GDScriptParserWrap")
		if not code and built_in:
			code = Code.new()
			code.source_code = CODE_TEMPLATE
			code.reload()
		if not built_in:
			path = SCRIPT_FOLDER + "/" + display_name + ".gd"
			var dir = Directory.new()
			if not dir.dir_exists(SCRIPT_FOLDER):
				dir.make_dir(SCRIPT_FOLDER)
			save_script_file(path, starting_script)
			var scipt_load_timer = Timer.new()
			scipt_load_timer.one_shot = true
			scipt_load_timer.autostart = true
			scipt_load_timer.wait_time = 2
			scipt_load_timer.connect("timeout", self, "_load_non_built_in_script")
			add_child(scipt_load_timer)
		starting_source_code = code.source_code if built_in else starting_script
		staged_srouce_code = starting_source_code
#		Server.connect("connected", self, "update_error")

	# Auto-assign animation player
	for child in get_children():
		if child is AnimationPlayer:
			animation = child
			animation.connect("animation_finished", self, "on_animation_finished")
			break


func _load_non_built_in_script():
	code = load(path)
	code.set_source_code(starting_script)
	code.reload(true)
	code._set_item(self)


func queue_free():
	remove_from_group("Item")
	if is_interactable:
		remove_from_group("Interactable")
	if is_programmable:
		remove_from_group("Programmable")
	.queue_free()


func set_highlight(enabled):
	for mesh in highlight_meshes:
		for index in mesh.mesh.get_surface_count():
			if enabled:
				var surf = mesh.mesh.surface_get_material(index)
				mesh.mesh.surface_get_material(index).next_pass = HIGHLIGHT_NEXT_PASS
			else:
				mesh.mesh.surface_get_material(index).next_pass = null


func init_code():
	if not code and built_in:
			code = Code.new()
			code.source_code = CODE_TEMPLATE
			code.reload()
	var source = code.source_code if built_in else starting_script
	staged_srouce_code = source
	update_error()
	apply_code()


func play_anim(anim: String, force := false, reset := false) -> bool:
	var played = false
	if animation and animation is AnimationPlayer:
		if animation.is_playing() and force:
			animation.stop(reset)
			animation.play(anim)
			played = true
		elif not animation.is_playing():
			animation.play(anim)
			played = true
	return played


func play_backward_anim(anim: String, force := false, reset := false):
	if animation and animation is AnimationPlayer:
		if animation.is_playing() and force:
			animation.stop(reset)
			animation.play_backwards(anim)
		elif not animation.is_playing():
			animation.play_backwards(anim)


func save_code(new_source: String):
	if locked:
		return
	staged_srouce_code = new_source
	update_error()


func update_error():
	if parser:
		# local parse
		parser.parse_script(staged_srouce_code)
		error = parser.get_error()
		error_line = parser.get_error_line()
		error_column = parser.get_error_column()
		has_error = parser.has_error()
		emit_signal("parse_status_changed", self)
#	elif Server.is_connected:
#		# remote parse
#		Server.parse(staged_srouce_code, display_name)


func set_error(result):
	has_error = result["has_error"]
	error = result["error"]
	error_line = result["line"]
	error_column = result["column"]
	emit_signal("parse_status_changed", self)


func apply_code():
	if locked or (not has_error and Constraints.all_passed):
		if built_in:
			code.set_source_code(staged_srouce_code)
			code.reload()
			code = code.new()
			code.set_source_code(staged_srouce_code)
			code._set_item(self)
		elif code:
			save_script_file(path, staged_srouce_code)
			code.set_source_code(staged_srouce_code)
			code.reload(true)
			code._set_item(self)


func save_script_file(path, source):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(source)
	file.close()


func get_lines_count():
	var line_counted = false
	var count = 0
	for i in staged_srouce_code.length():
		var c = staged_srouce_code[i]
		if c == '\n':
			line_counted = false
		elif c == '#':
			line_counted = true
		elif c == ' ' or c == '	':
			continue
		elif not line_counted:
			line_counted = true
			count += 1
	return count


func get_methods() -> Array:
	var methods = []
	for fun in code.get_method_list():
		if fun["flags"] == METHOD_FLAG_FROM_SCRIPT + METHOD_FLAG_NORMAL:
			if not fun["name"].begins_with("_"):
				methods.append(fun["name"])
	return methods

func replace_in_code(replace: String, by: String) -> bool:
	var save = false
	if code.source_code.find(replace) != -1:
		save = true
	code.source_code = code.source_code.replace(replace, by)
	if save:
		save_code(code.source_code)
	return save


func play_sound(sound):
	if sound_player and sound_player is AudioStreamPlayer3D:
		sound_player.stream = sound
		sound_player.play()

func on_animation_finished(anim_name):
	pass

#________________________________khawla's part_______________________________

func get_coupling():
	var count = 0
	count = staged_srouce_code.count("getObject")
	return count

func get_cyc_count():
	var line_counted = false
	var comment_line =""
	var current_line=""
	
	var count = 0 
	var i=0
	var c
	while i < staged_srouce_code.length():
		
		if staged_srouce_code[i]!="	":
			c = staged_srouce_code[i]
			if c != "\n":
				current_line=current_line+staged_srouce_code[i]
			else:
				if current_line.begins_with("if ") or current_line.begins_with("if(") or  current_line.begins_with("elif") or  current_line.begins_with("while ")or  current_line.begins_with("while("):
					count=count+1
					if current_line.count("and")>0:
						count=count+current_line.count("and")
					if current_line.count("or")>0:
						count=count+current_line.count("or")
				if current_line.begins_with("for") or  current_line.begins_with("func"):
					count=count+1
				
				current_line=""
			
		i=i+1

	return count

