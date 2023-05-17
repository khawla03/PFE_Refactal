class_name LevelInfo
extends Resource


export(String) var id
export(String) var title := "Level Title"
export(String, MULTILINE) var shortDescription := "Level short description."
export(String, MULTILINE) var description := "Level description."
export(Texture) var splash
export(String) var path
export(Resource) var next_level
