class_name Screen
extends Code


func getValue() -> String:
	return _item.value


func getIntValue() -> int:
	return int(_item.value)


func setValue(val):
	if _item.can_set_value:
		_item.set_value(str(val))



func screenOff():
	_item.screenOff()
