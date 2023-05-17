class_name NodeUtils


static func clear_children(node: Node):
	if node:
		for child in node.get_children():
			node.remove_child(child)
			child.queue_free()
