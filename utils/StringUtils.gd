class_name StringUtils

const CHARACTERS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
const NUMBERS = "0123456789"
const OPERATIONS = "+-*/"

static func get_random_string(length: int):
	var result = ""
	for i in range(length):
		result += CHARACTERS[randi() % CHARACTERS.length()]
	return result


static func get_random_number(length: int, not_zero := false):
	var result = ""
	for i in range(length):
		result += NUMBERS[randi() % NUMBERS.length()]
	if not_zero:
			while is_zero_approx(int(result)):
				result = ""
				for i in range(length):
					result += NUMBERS[randi() % NUMBERS.length()]
	return result


static func get_random_operation(operations := OPERATIONS):
	return operations[randi() % operations.length()]


static func get_random_expression(number_length: int, operations := OPERATIONS, result_digit_limit := 0) -> String:
	if result_digit_limit > 0:
		var expression = _get_rand_exp(number_length, operations)
		var result = get_exp_result(expression)
		while result.length() > result_digit_limit:
			expression = _get_rand_exp(number_length, operations)
			result = get_exp_result(expression)
		return expression
	else:
		return _get_rand_exp(number_length, operations)


static func get_exp_result(expression) -> String:
	var e = Expression.new()
	e.parse(expression)
	return str(e.execute())


static func _get_rand_exp(number_length: int, operations := OPERATIONS) -> String:
	var rand1 = get_random_number(number_length, true)
	var rand2 = get_random_number(number_length, true)
	var op = get_random_operation(operations)
	return rand1 + op + rand2

