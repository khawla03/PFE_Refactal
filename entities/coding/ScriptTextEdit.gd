extends TextEdit

# Colors
const COLOR_KEYWORD = Color(1, 0.44, 0.52)
const COLOR_CONTROL = Color(1, 0.54902, 0.8)
const COLOR_SYMBOL = Color(0.67, 0.78, 1)
const COLOR_STRING = Color(1, 0.92, 0.63)
const COLOR_COMMENT = Color(0.8, 0.8, 0.82, 0.5)
const COLOR_REPLACE = Color.gold

# Keywords
const keywords = ["class", "extends", "func", "static", "const", "var", "setget", \
	"in", "not", "and", "or", "range", "class_name"]
const control_flow = ["if", "else", "elif", "match", "for", "while", "break", "continue", \
	"pass", "return"]
const operators = ["is", "~", "*", "/", "%", "+", "-", "&", "^", \
	"|", "<", ">", "="]
const built_in_types = ["null", "bool", "int", "float", "String"]


func _ready():
# Syntax highlight
	for keyword in  keywords:
		add_keyword_color(keyword, COLOR_KEYWORD)
	for control in  control_flow:
		add_keyword_color(control, COLOR_CONTROL)
	for operator in operators:
		add_keyword_color(operator, COLOR_SYMBOL)
	for type in built_in_types:
		add_keyword_color(type, COLOR_KEYWORD)
	add_color_region('"','"', COLOR_STRING)
	add_color_region("'","'", COLOR_STRING)
	add_color_region('#','', COLOR_COMMENT, true)

