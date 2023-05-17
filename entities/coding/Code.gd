class_name Code
extends GDScript



var _item setget _set_item


static func getObject(display_name: String) -> Code:
	for item in Items.get_tree().get_nodes_in_group("Programmable"):
		if item.display_name == display_name:
			return item.code
	return null


func _set_item(item):
	_item = item
	pass


