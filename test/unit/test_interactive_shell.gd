extends GutTest

@onready var console:PankuConsole = get_node(PankuConsole.SingletonPath)
@onready var _sender = InputSender.new()

const _shell_signal = "toggle_console_action_just_pressed"
const _shell_module_name = "interactive_shell"

func before_all():
	_sender.add_receiver(Input)
	_sender.add_receiver(InputMap)

func after_each():
	_sender.release_all()
	_sender.clear()

func test_console_open():
	console.emit_signal(_shell_signal)
	var shell: PankuModuleInteractiveShell = console.module_manager.get_module(_shell_module_name)
	assert_true(shell._is_gui_open,
		"module %s opened when signal %s was emitted" % [_shell_module_name, _shell_signal])
	
