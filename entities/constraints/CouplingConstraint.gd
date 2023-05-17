extends Constaint


const id = 2
export(int) var coupling_limit: int
var coupling_count


func _ready():
	passed()

func get_text():
	return "Number of coupling : " + str(coupling_count) + "/" + str(coupling_limit)


func passed():
	coupling_count = MetricUtils.get_total_coupling(get_tree())
	emit_signal("constraint_updated", self, get_text())
	return coupling_count <= coupling_limit
