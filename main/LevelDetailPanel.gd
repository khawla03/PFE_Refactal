extends MenuPanel


signal level_launched(path)

var level_info: LevelInfo

onready var titleLabel = find_node("Title") as Label
onready var splashTexture = find_node("Splash") as TextureRect
onready var descriptionLabel = find_node("Description") as RichTextLabel
onready var stats = find_node("Stats") as Control
onready var scoreLabel = find_node("Score") as Label
onready var linesLabel = find_node("Lines") as Label
onready var minutesLabel = find_node("Minutes") as Label
onready var secondsLabel = find_node("Seconds") as Label
onready var cycLabel = find_node("Cyc") as Label


func _ready():
	Settings.connect("reset_progress", self, "hide")


func show():
	if not active:
		.show()
		titleLabel.text = level_info.title
		descriptionLabel.text = level_info.description
		splashTexture.texture = level_info.splash
	if Progress.is_level_completed(level_info.id):
		scoreLabel.text = str(int(Progress.get_level_score(level_info.id)))
		linesLabel.text = str(Progress.get_level_lines(level_info.id))
		cycLabel.text = str(Progress.get_level_cyc(level_info.id))
		minutesLabel.text = str(Progress.get_level_minutes(level_info.id))
		secondsLabel.text = str(Progress.get_level_seconds(level_info.id))
		stats.show()
	else:
		stats.hide()


func _on_StartButton_pressed():
	sound.play_sound(SoundPlayer.CLICK)
	emit_signal("level_launched", level_info.path)
