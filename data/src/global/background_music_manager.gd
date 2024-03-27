extends Node

# TODO: set default audio volume.
# TODO: allow user to set audio volume.
# TODO: allow user to mute songs.
# TODO: manage fade in and fade out.

var   is_setup           : bool              = false
var   root               : Node              = null
var   menu_player        : AudioStreamPlayer = AudioStreamPlayer.new()
var   game_player        : AudioStreamPlayer = AudioStreamPlayer.new()
var   last_active_player : AudioStreamPlayer = null
var   BUS_NAME           : String            = AudioManager.MUSIC_BUS

# TODO: load all songs from dedicated directory.
const main_track_path    : String            = "res://data/assets/soundtrack/00_main.mp3"

# TODO: load all songs from dedicated directory.
const soundtrack_paths   : Array             = [
	"res://data/assets/soundtrack/01_anttis-instrumentals+happy-thingies.mp3",
	"res://data/assets/soundtrack/02_anttis-instrumentals+hrdelli.mp3",
	"res://data/assets/soundtrack/03_anttis-instrumentals+hysteria-in-the-jungle.mp3"
]

func resume_playing():
	if last_active_player != null:
		last_active_player.play()

func init_manager(_root : Node):
	root = _root

func load_audio_dir():
	pass
#	var sounds = []
#	var sound_directory = Directory.new()
#	sound_directory .open("res://Sounds")
#	sound_directory.list_dir_begin(true)
#
#	var sound = sound_directory.get_next()
#	while sound != "":
#	    sounds.append(load("res://Sounds/" + sound))
#	    sound = sound_directory.get_next()

func setup():
	if not is_setup and root != null:
		# set the bus for each player.
		menu_player.bus = BUS_NAME
		# setup players.
		menu_player.autoplay = false
		game_player.autoplay = false
		root.add_child(menu_player)
		root.add_child(game_player)
		# infinitely loop.
		menu_player.finished.connect(resume_playing)
		game_player.finished.connect(resume_playing)
		# add main menu track.
		var mp3 : AudioStreamMP3 = Helpers.load_mp3(main_track_path)
		menu_player.set_stream(mp3)
		# add game music tracks.
		var streamRandomizer : AudioStreamRandomizer = AudioStreamRandomizer.new()
		const APPEND : int = -1
		for i in range(len(soundtrack_paths)):
			streamRandomizer.add_stream(APPEND, Helpers.load_mp3(soundtrack_paths[i]))
		game_player.set_stream(streamRandomizer)
		# mark as started.
		is_setup = true

func transition_to_game_music():
	last_active_player = game_player
	setup()
	menu_player.stop()
	game_player.play()

func transition_to_menu_music():
	last_active_player = menu_player
	setup()
	game_player.stop()
	menu_player.play()
