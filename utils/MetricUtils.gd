class_name MetricUtils

# Return the total line count of all existing item in the level
static func total_line_count(tree_node: SceneTree) -> int:
	var count = 0
	for item in tree_node.get_nodes_in_group("Programmable"):
		if not item.locked:
			count += item.get_lines_count()
	return count


static func get_total_coupling(tree_node: SceneTree) -> int:
	var count = 0
	for item in tree_node.get_nodes_in_group("Programmable"):
		if not item.locked:
			count += item.get_coupling()
	return count
	
static func total_cyc(tree_node: SceneTree) -> int:
	var count = 0
	for item in tree_node.get_nodes_in_group("Programmable"):
		if not item.locked:
			count += item.get_cyc_count()
	return count
