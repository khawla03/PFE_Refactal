class_name Config
extends Resource


# Display
export(bool) var DISPLAY_FULLSCREEN = true
export(bool) var DISPLAY_VSYNC = true
# Audio
export(float, 0, 100) var AUDIO_VOL_MUSIC = 100
export(bool) var AUDIO_MUTE_MUSIC = false
export(float, 0, 100) var AUDIO_VOL_SFX = 100
export(bool) var AUDIO_MUTE_SFX = false
export(float, 0, 100) var AUDIO_VOL_UI_SFX = 100
export(bool) var AUDIO_MUTE_UI_SFX = false
export(float, 0, 100) var AUDIO_VOL_SPEECH = 100
export(bool) var AUDIO_MUTE_SPEECH = false

