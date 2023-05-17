class_name Score
extends Node



static func calc_score(
	lines: int,
	minutes: int,
	seconds: int
):
	return 1000 / (1 + (lines * 0.05) + ((minutes * 60 + seconds) * 0.003))
