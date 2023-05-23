class_name Score
extends Node



static func calc_score(
	lines: int,
	cyc : int,
	minutes: int,
	seconds: int
):
	return 1000 / (1 + ((lines+10)*0.25/20)+((cyc-1)*0.25/10) + ((minutes * 60 + seconds)*0.5/300))
