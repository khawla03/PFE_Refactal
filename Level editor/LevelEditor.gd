extends Control


signal exit_coding()
signal item_pressed(item_name)

const ICON_CONNECTED = preload("res://assets/icons/ic_circle_green.png")
const ICON_DISCONNECTED = preload("res://assets/icons/ic_circle_black.png")

var ItemNode = preload("res://entities/Item.tscn")
var ItemListElement = preload("res://entities/coding/ItemListElement.tscn")
var MethodUI = preload("res://entities/coding/MethodUI.tscn")
var new_object 

var level= preload("res://Level editor/00_test/Level0-0.tscn").instance()
var slide= preload("res://Level editor/00_test/slides/Slide.tscn").instance()
var slider = level.get_node("Slider")
var door=level.get_node("Door")


var selected_item
var item_to_rename
var y=2
var x=2.5
var z=-4



onready var codingGUI := get_node("CodingGUI")
onready var itemsContainer := $CodingGUI/MarginContainer/VBoxContainer/HSplitContainer/VBoxContainer/TabContainer/Objects/MarginContainer/VBoxContainer/ScrollContainer/ItemsContainer
onready var marginContainer := $CodingGUI/MarginContainer
onready var methodContainer := $CodingGUI/MarginContainer/VBoxContainer/HSplitContainer/VBoxContainer/TabContainer2/Methods/MarginContainer/ScrollContainer/MethodContainer
onready var scriptEditor := $CodingGUI/MarginContainer/VBoxContainer/HSplitContainer/VSplitContainer/TabContainer/Code/MarginContainer/Control/ScriptEditor
onready var pressed=$CodingGUI/MarginContainer/VBoxContainer/HSplitContainer/VBoxContainer/TabContainer2/Settings/MarginContainer/ScrollContainer/SettingsContainer/ObjectLocked/CheckBox
onready var objectLockedSettings=$CodingGUI/MarginContainer/VBoxContainer/HSplitContainer/VBoxContainer/TabContainer2/Settings/MarginContainer/ScrollContainer/SettingsContainer/ObjectLocked

# Dialogs
onready var dialogBg = $CodingGUI/DialogBg
onready var newObjectDialog = $CodingGUI/NewObjectDialog
onready var newObjectName = $CodingGUI/NewObjectDialog/MarginContainer/VBoxContainer/HBoxContainer/NewObjectNameLabel
onready var newObjectDescription = $CodingGUI/NewObjectDialog/MarginContainer/VBoxContainer/NewObjectDescriptionLabel
onready var renameDialog = $CodingGUI/RenameObjectDialog
onready var renameLineEdit = $CodingGUI/RenameObjectDialog/MarginContainer/VBoxContainer/HBoxContainer/RenameLineEdit
onready var cnxStatus = $CodingGUI/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/ConnexionStatus
onready var syntaxDialog = find_node("SyntaxSheet") as Popup

onready var ObjectsListDialog = $CodingGUI/ObjectsList

func _ready():
	print("leveleditor start")
	codingGUI.hide()
	marginContainer.show()
	door.locked=false
	register_item(door)
	for item in get_tree().get_nodes_in_group("Programmable"):
		register_item(item)
	
	objectLockedSettings.hide()
	
	
	#scriptEditor.hide()
#	Server.connect("connected", self, "_on_parser_connected")
#	Server.connect("disconnected", self, "_on_parser_disconnected")
	
	_on_ApplyButton_pressed()


func register_item(item, custom = false):
	var new_element = ItemListElement.instance()
	new_element.item = item
	new_element.connect("rename", self, "_on_item_request_rename")
	new_element.connect("item_pressed", self, "_on_item_pressed")
	if custom:
		new_element.is_custom = true
	itemsContainer.add_child(new_element)
	scriptEditor.add_item(item)
	item.init_code()


func add_method(method):
	var new_method = MethodUI.instance()
	new_method.set_method(method)
	new_method.connect("method_pressed", self, "_on_method_pressed")
	methodContainer.add_child(new_method)


func start_coding():
	codingGUI.show()


func stop_coding():
	scriptEditor.save_current_item()
	codingGUI.hide()


func _update_methods_ui():
	for child in methodContainer.get_children():
		child.queue_free()
	for met in selected_item.item.get_methods():
		add_method(met)


func _on_item_pressed(itemElement):
	scriptEditor.load_item(itemElement.item)
	selected_item = itemElement
	_reset_items_highlight()
	itemElement.set_highlight(true)
	_update_methods_ui()
	emit_signal("item_pressed", itemElement.item.display_name)
	objectLockedSettings.show()


func _on_method_pressed(method):
	pass


func _reset_items_highlight():
	for itemElement in itemsContainer.get_children():
		itemElement.set_highlight(false)


func _on_ApplyButton_pressed():
	#stop_coding()
	#emit_signal("exit_coding")
	for item_ui in itemsContainer.get_children():
		item_ui.item.apply_code()

func add_object():
	dialogBg.show()
	newObjectName.clear()
	newObjectDescription.text = ""
	newObjectDialog.popup_centered_minsize()

func _on_NewObjectButton_pressed():
	dialogBg.show()
	ObjectsListDialog.popup_centered_minsize()
	



func _on_CreateObjectButton_pressed():
	newObjectDialog.hide()
	dialogBg.hide()
	
	new_object.display_name = newObjectName.text
	new_object.description = newObjectDescription.text
	new_object.is_programmable = true
	new_object.built_in = true
	new_object.add_to_group("Programmable")
	level.add_child(new_object)
	register_item(new_object, true)


func _on_item_request_rename(item_ui):
	item_to_rename = item_ui
	renameLineEdit.text = item_ui.item.display_name
	renameLineEdit.select_all()
	dialogBg.show()
	renameLineEdit.call_deferred("grab_focus")
	renameDialog.popup_centered()


func _on_RenameObjectButton_pressed():
	var old_name = item_to_rename.item.display_name
	var new_name = renameLineEdit.text
	if old_name == new_name:
#		renameDialog.hide()
#		dialogBg.hide()
		return
	item_to_rename.item.display_name = new_name
	item_to_rename.update_ui()
	for item_ui in itemsContainer.get_children():
		item_ui.item.replace_in_code(
			"getObject(\"" + old_name + "\")",
			"getObject(\"" + new_name + "\")")
	scriptEditor.update_item(item_to_rename.item.get_instance_id(), new_name)
	renameDialog.hide()
	dialogBg.hide()

func _on_parser_connected():
	cnxStatus.texture = ICON_CONNECTED
	cnxStatus.hint_tooltip = "Connected to the remote server"


func _on_parser_disconnected():
	cnxStatus.texture = ICON_DISCONNECTED
	cnxStatus.hint_tooltip = "Not connected to the remote server"


func _on_ScriptEditor_help_syntax():
	dialogBg.show()
	syntaxDialog.popup_centered()


func _on_Next_pressed():
	#get_tree().get_root().add_child(level)
	for item_ui in itemsContainer.get_children():
		item_ui.item.apply_code()
	
	get_tree().change_scene("res://Level editor/00_test/Level.tscn")
	get_tree().get_root().add_child(level)
	get_tree().get_root().remove_child(self)
	print("hello")
	#var new_scene = level.duplicate()
	#ResourceSaver.save("res://Level editor/level.tscn", new_scene)
	#add_child(level)
	#get_tree().change_scene("res://Level editor/00_test/Level.tscn")
	pass # Replace with function body.


func _on_CheckBox_pressed():
	
	selected_item.item.locked = pressed.is_pressed()
	print(selected_item.item.locked)
	
	pass # Replace with function body.


func _on_ScreenButton_pressed():
	ItemNode = preload("res://entities/Screen/WideScreen.tscn")
	add_object()
	
	new_object=ItemNode.instance()
	new_object.translate(Vector3(-6.8, x, z))
	new_object.rotation_degrees=Vector3(0,90,0)
	if x<3.3:
		x=x+0.4
	else:
		x=2.5 
		z=z+1
	
	pass # Replace with function body.


func _on_AddNewButton_pressed():
	ItemNode = preload("res://entities/button/ButtonItem.tscn")
	new_object=ItemNode.instance()
	new_object.translate(Vector3(1.5, y, -5))
	y=y+0.4
	pass # Replace with function body.


func _on_level_settings_Next_pressed(title, description, sliderTitle,slideContent):
	level.level_info.title=title
	level.level_info.shortDescription=description
	slide.slideTitle=sliderTitle
	slide.slideCont=slideContent
	var scene= PackedScene.new() 
	scene.pack(slide)
	slider.slide_scenes.append(scene)
	codingGUI.show()
	
