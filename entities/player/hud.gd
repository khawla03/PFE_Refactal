extends CanvasLayer



onready var crosshair = $Crosshair
onready var root = $MarginContainer
onready var iconTexture := $MarginContainer/VBoxContainer/HBoxContainer/IconTextureRect
onready var itemNameLabel := $MarginContainer/VBoxContainer/HBoxContainer/ItemNameLabel
onready var descriptionLabel := $MarginContainer/VBoxContainer/DescriptionLabel
onready var interactionLabel := $MarginContainer/VBoxContainer/HBox/InteraactionLabel
onready var interactionContainer := $MarginContainer/VBoxContainer/HBox


func _ready():
	_clear()


func show():
	root.show()
	crosshair.show()


func hide():
	root.hide()
	crosshair.hide()


func _clear():
	iconTexture.texture = null
	itemNameLabel.text = ""
	descriptionLabel.text = ""
	interactionLabel.text = ""
	interactionContainer.hide()


func _on_AimRayCast_item_entred(item):
	iconTexture.texture = item.icon
	itemNameLabel.text = item.display_name
	descriptionLabel.text = item.description
	if item.is_interactable:
		#interactionLabel.text = "(" + InputMap.get_action_list("interact")[0].as_text() + ") "
		interactionLabel.text = item.interaction_message
		interactionContainer.show()
	else:
		interactionLabel.text = ""
		interactionContainer.hide()


func _on_AimRayCast_item_exited():
	_clear()


func _on_AimRayCast_item_can_interact(can_interact):
	if can_interact:
		interactionLabel.set("custom_colors/font_color", Color(1, 1, 1, 1))
	else:
		interactionLabel.set("custom_colors/font_color", Color(1, 1, 1, 0.2))

