class_name RoomMap
extends Code

func open(pw = ""):
	print("open")
	_item.openRoom(pw)
	
func close():
	print("close")
	_item.closeRoom()
	
