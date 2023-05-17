extends CanvasLayer


const ConstraintUI = preload("res://globals/constaints/ConstrainUI.tscn")

var all_passed = false

onready var root = find_node("Root") as Control
onready var constraintContainer = find_node("ConstraintContainer") as Container


func _ready():
	hide()


func check_all():
	var passed = true
	for constraint in get_tree().get_nodes_in_group("Constraint"):
		if not constraint.passed():
			passed = false
	all_passed = passed
	return passed


func show():
	var constraints = get_tree().get_nodes_in_group("Constraint")
	if constraints.size() > 0:
		for constraint in constraints:
			var ui = ConstraintUI.instance()
			ui.id = constraint.id
			ui.text = constraint.get_text()
			constraintContainer.add_child(ui)
			constraint.connect("constraint_updated", self, "_on_constraint_updated")
		root.show()
		check_all()


func hide():
	root.hide()
	NodeUtils.clear_children(constraintContainer)


func _on_constraint_updated(constraint, text):
	for constraint_ui in constraintContainer.get_children():
		if constraint_ui.id == constraint.id:
			constraint_ui.text = text
