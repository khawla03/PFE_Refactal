class_name Message extends Code


# Declare member variables here. Examples:
# var a = 2
export(String) var content = "this is a message" setget setMsgContent, getMsgContent
export(String) var contact = "this is a message" setget setContact, getContact

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show():
	pass


func setMsgContent(newContent:String):
	content=newContent
	_item.set_message(newContent)
	

func getMsgContent() -> String:
	return content


func setContact(newContact:String):
	contact=newContact
	_item.set_message(newContact)
	

func getContact() -> String:
	return contact

func sendMessage():
	_item.send_message()
