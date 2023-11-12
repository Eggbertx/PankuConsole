extends GutTest

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)
@onready var _sender = InputSender.new()

const _shell_signal = "toggle_console_action_just_pressed"
const _shell_module_name = "interactive_shell"

func before_all():
	_sender.add_receiver(console)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_shell_toggle():
	watch_signals(console)

	var event:InputEventKey = InputFactory.key_down(KEY_QUOTELEFT)
	event.physical_keycode = event.keycode
	event.pressed = true

	_sender.send_event(event)
	_sender.release_all()
	assert_signal_emitted(console, _shell_signal, "The interactive shell toggle signal should be emitted")
	var shell: PankuModuleInteractiveShell = console.module_manager.get_module(_shell_module_name)
	assert_not_null(shell)
	assert_true(shell._is_gui_open,
		"module %s opened when signal %s was emitted" % [_shell_module_name, _shell_signal])

	# "press" it again to close the console
	_sender.send_event(event)
	assert_signal_emitted(console, _shell_signal, "The interactive shell toggle signal should be emitted")
	assert_false(shell._is_gui_open,
		"interactive shell opened when signal %s was emitted" % [_shell_module_name, _shell_signal])
