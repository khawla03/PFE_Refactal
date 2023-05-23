extends Constaint


const id = 3
export(int) var cyc_limit: int
var cyc_count


func _ready():
	passed()

func get_text():
	return "Total complexity: " + str(cyc_count) + "/" + str(cyc_limit)


func passed():
	cyc_count = MetricUtils.total_cyc(get_tree())
	emit_signal("constraint_updated", self, get_text())
	return cyc_count <= cyc_limit
