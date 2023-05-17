extends Constaint


const id = 1
export(int) var lines_limit: int
var line_count


func _ready():
	passed()

func get_text():
	return "Lines limit : " + str(line_count) + "/" + str(lines_limit)


func passed():
	line_count = MetricUtils.total_line_count(get_tree())
	emit_signal("constraint_updated", self, get_text())
	return line_count <= lines_limit
