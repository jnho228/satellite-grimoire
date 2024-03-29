extends Node
"""
	SFXPlayer Class Script
	Plays Sound effects on up to N channels.
	Will queue or discard sounds if all channels are busy.
"""
const TOTAL_CHANNELS: int = 16
const BUS: String = "SFX"
const SKIP_IF_BUSY: bool = true

var _channels: Array = []
var _free_streams: Array = []
var _sounds_todo: Array = []


	#initialize streams
func _ready() -> void:
	for i in TOTAL_CHANNELS:
		var n: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(n)
		_channels.append(n)
		_free_streams.append(n)
		if n.connect("finished", self, "on_stream_finished", [n]) != OK:
			print("Error connecting SFX Player's AudioStream.")
		n.autoplay = true
		n.bus = BUS


func _process(_delta):
	if not _sounds_todo.empty():
		if _free_streams.empty() and SKIP_IF_BUSY:
			_sounds_todo.pop_front()
		elif not _free_streams.empty():
			var s: AudioStreamPlayer = _free_streams.pop_front()
			s.stream = _sounds_todo.pop_front()
			s.play()


func play_sound(sound_file: AudioStream):
	if not _sounds_todo.has(sound_file):
		_sounds_todo.append(sound_file)


func on_stream_finished(stream: AudioStreamPlayer) -> void:
	_free_streams.append(stream)
