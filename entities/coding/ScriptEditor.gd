extends VBoxContainer


signal help_syntax()


const COLOR_ERROR = Color(1, 0.470588, 0.419608)
const COLOR_CLEAN = Color(0.372549, 1, 0.592157)
const ICON_ERROR = preload("res://assets/icons/error.png")
const ICON_CHECK = preload("res://assets/icons/check.png")

var item_ref_menu = PopupMenu.new()
var current_item: Item
var last_popup_press := 0.0

onready var textEdit := $ScriptTextEdit
onready var insertMenu := $MarginContainer/HBoxContainer/InsertMenu
onready var editMenu := $MarginContainer/HBoxContainer/EditMenu
onready var helpMenu := $MarginContainer/HBoxContainer/HelpMenu
onready var parserText := $Parser/HBox/ParserText
onready var parserIcon := $Parser/HBox/ParserIcon
onready var parserLoading := $Parser/HBox/Loading
onready var parserContainer := $Parser
onready var saveTimer := $SaveTimer


func _ready():
	insertMenu.get_popup().connect("id_pressed", self, "_on_insert_id_pressed")
	item_ref_menu.connect("index_pressed", self, "_on_item_ref_index_pressed")
	editMenu.get_popup().connect("id_pressed", self, "_on_edit_id_pressed")
	parserLoading.hide()
	helpMenu.get_popup().connect("id_pressed", self, "_on_help_id_pressed")

	# Item reference submenu
	item_ref_menu.set_name("item_ref_menu")
	insertMenu.get_popup().add_child(item_ref_menu)
	insertMenu.get_popup().add_submenu_item("Insert object reference", "item_ref_menu")


func load_item(item):
	save_current_item()
	current_item = item
	show()
	textEdit.readonly = current_item.locked
	parserContainer.visible = !current_item.locked
	textEdit.text = current_item.staged_srouce_code
#	if item.has_error:
#		textEdit.text = current_item.staged_srouce_code
#	else:
#		textEdit.text = current_item.code.source_code
	update_error(current_item)
	item.connect("parse_status_changed", self, "update_error")


func save_current_item():
	if current_item:
		current_item.save_code(textEdit.text)
	Constraints.check_all()


func reset_current_item():
	if current_item:
		current_item.save_code(current_item.starting_source_code)
		textEdit.text = current_item.starting_source_code


func add_item(item: Item):
	item_ref_menu.add_item(item.display_name, item.get_instance_id())


func update_item(id: int, new_name: String):
	item_ref_menu.set_item_text(item_ref_menu.get_item_index(id), new_name)
	textEdit.text = current_item.code.source_code


func update_error(item):
	if item.locked:
		return
	if item.has_error:
		parserIcon.texture = ICON_ERROR
		parserText.set("custom_colors/default_color", COLOR_ERROR)
		var line = str(item.error_line)
		var col = str(item.error_column)
		var s = "Error at line " + line + " column " + col + " : "
		parserText.text = s + item.error
	else:
		parserIcon.texture = ICON_CHECK
		parserText.set("custom_colors/default_color", COLOR_CLEAN)
		parserText.text = "No error detected."


func _on_insert_id_pressed(id: int):
	if OS.get_ticks_msec() - last_popup_press < 100:
		return
	last_popup_press = OS.get_ticks_msec()
	match id:
		# Basic--------------------
		1: # Function
			insert_function()
		2: # Variable
			insert_variable()
		3: # Constant
			insert_constant()
		# Conditions----------------
		5: # If
			insert_if()
		6: # If / else
			insert_if_else()
		7: # If / elif / else
			insert_if_elif_else()
		8: # Match
			insert_match()
		# Loops----------------------
		10: # For (Range)
			insert_for_range()
		11: # For (Array)
			insert_for_array()
		12: # While
			insert_while()
	request_focus()


func _on_item_ref_index_pressed(idx: int):
	var item_name = item_ref_menu.get_item_text(idx)
	insert("getObject(\"" + item_name + "\")")
	request_focus()


func _on_edit_id_pressed(id: int):
	if OS.get_ticks_msec() - last_popup_press < 100:
		return
	last_popup_press = OS.get_ticks_msec()
	match id:
		0: # Undo
			textEdit.undo()
		1: # Redo
			textEdit.redo()
		3: # Cut
			textEdit.cut()
		4: # Copy
			textEdit.copy()
		5: # Paste
			textEdit.paste()
	request_focus()


func _on_help_id_pressed(id: int):
	if OS.get_ticks_msec() - last_popup_press < 100:
		return
	last_popup_press = OS.get_ticks_msec()
	match id:
		0: # Syntax
			emit_signal("help_syntax")


func get_current_line() -> String:
	return textEdit.get_line(textEdit.cursor_get_line())


func get_current_line_num() -> int:
	return textEdit.cursor_get_line()


func get_current_col_num() -> int:
	return textEdit.cursor_get_column()


func request_focus():
	textEdit.call_deferred("grab_focus")


func select(text: String, from_line):
	var flags = TextEdit.SEARCH_MATCH_CASE
	var query = textEdit.search(text, flags, from_line, 0)
	if query.size() != 0:
		var line = query[TextEdit.SEARCH_RESULT_LINE]
		var column = query[TextEdit.SEARCH_RESULT_COLUMN]
		textEdit.select(line, column, line, column + text.length())
		textEdit.cursor_set_line(line)
		textEdit.cursor_set_column(column)


# Insertions ---------------------------------------------

func insert(text: String):
	textEdit.insert_text_at_cursor(text)

# Call when insert new lines
func insert_tabs(added_tabs := 0, from_line: int = textEdit.cursor_get_line() - 1):
	var line: String = textEdit.get_line(from_line)
	var num_tabs = 0
	for c in line.length():
		if line[c] == '	':
			num_tabs += 1
			continue
		break
	var tabs = ""
	for i in num_tabs + added_tabs:
		tabs += '	'
	insert(tabs)

# Makes sure the current line is empty
func assert_new_line():
	var line = get_current_line()
	var insert_new_line = false
	for c in line.length():
		if line[c] != '	':
			insert_new_line = true
			break
	if insert_new_line:
		insert("\n")
		if line.begins_with("func"):
			insert_tabs(1)
		else:
			insert_tabs()

func insert_function():
	var line := get_current_line()
	var line_num = get_current_line_num()
	var insert_new_lines = line != ""
	while line != "":
		line_num += 1
		line = textEdit.get_line(line_num)
	textEdit.cursor_set_line(line_num)
	if insert_new_lines:
		insert("\n\n")
	insert("func __function_name__():\n")
	insert_tabs(1)
	insert("pass # Replace with function body.\n\n")
	select("__function_name__", get_current_line_num() - 3)

func insert_variable():
	assert_new_line()
	insert("var __variable_name__")
	select("__variable_name__", get_current_line_num())

func insert_constant():
	assert_new_line()
	insert("const __constant_name__ = \"VALUE\"")
	select("__constant_name__", get_current_line_num())

func insert_if():
	assert_new_line()
	insert("if __condition__:\n")
	insert_tabs(1)
	insert("pass # Replace with if body.")
	select("__condition__", get_current_line_num() - 1)

func insert_if_else():
	assert_new_line()
	insert("if __condition__:\n")
	insert_tabs(1)
	insert("pass # Replace with if body.\n")
	insert_tabs(-1)
	insert("else:\n")
	insert_tabs(1)
	insert("pass # Replace with else body.")
	select("__condition__", get_current_line_num() - 3)

func insert_if_elif_else():
	assert_new_line()
	insert("if __condition__:\n")
	insert_tabs(1)
	insert("pass # Replace with if body.\n")
	insert_tabs(-1)
	insert("elif __condition__:\n")
	insert_tabs(1)
	insert("pass # Replace with elif body.\n")
	insert_tabs(-1)
	insert("else:\n")
	insert_tabs(1)
	insert("pass # Replace with else body.")
	select("__condition__", get_current_line_num() - 5)

func insert_match():
	assert_new_line()
	insert("match __variable__:\n")
	insert_tabs(1)
	insert("_value_1_:\n")
	insert_tabs(1)
	insert("pass # Replace with body.\n")
	insert_tabs(-1)
	insert("_value_2_:\n")
	insert_tabs(1)
	insert("pass # Replace with body.")
	select("__variable__", get_current_line_num() - 4)

func insert_for_range():
	assert_new_line()
	insert("for i in range(0, 10):\n")
	insert_tabs(1)
	insert("pass # Replace with for body.")
	select("10", get_current_line_num() - 1)

func insert_for_array():
	assert_new_line()
	insert("for i in __array__:\n")
	insert_tabs(1)
	insert("pass # Replace with for body.")
	select("__array__", get_current_line_num() - 1)

func insert_while():
	assert_new_line()
	insert("while __condition__:\n")
	insert_tabs(1)
	insert("pass # Replace with while body.")
	select("__condition__", get_current_line_num() - 1)


func _on_ScriptTextEdit_text_changed():
	saveTimer.start()
	parserLoading.show()
#	var line = textEdit.cursor_get_line()
#	var col = textEdit.cursor_get_column()
#	var last_car_ascii
#	if col == 0:
#		last_car_ascii = 9
#	else:
#		last_car_ascii = textEdit.get_line(line)[col-1].to_ascii()[0]
#	print(str(last_car_ascii))
#	if last_car_ascii == 9:
#		var before_last = textEdit.get_line(line - 1)[textEdit.get_line(line - 1).length() - 1]
#		if before_last == ':':
#			insert("	")
	pass


func _on_ResetButton_button_up():
	reset_current_item()


func _on_SaveTimer_timeout():
	save_current_item()
	parserLoading.hide()



