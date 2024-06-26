class_name PankuConsoleTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const _console_scene = "res://addons/panku_console/console.tscn"
const _shell_signal = "toggle_console_action_just_pressed"
const _shell_module_name = "interactive_shell"

var shell: PankuModuleInteractiveShell
var console:PankuConsole
var _console_runner: GdUnitSceneRunner


func before():
	console = get_node(PankuConsole.SingletonPath)
	shell = console.module_manager.get_module(_shell_module_name)
	_console_runner = scene_runner(_console_scene)
	auto_free(_console_runner)

func after():
	if shell._is_gui_open:
		_console_runner.simulate_key_pressed(KEY_QUOTELEFT)
	
func test_shell_toggle() -> void:
	assert_object(shell).is_not_null()
	assert_signal(console).is_emitted(_shell_signal)

	# simulate ~ and check that the signal was fired and the
	# shell is open
	_console_runner.simulate_key_pressed(KEY_QUOTELEFT)
	_console_runner.await_signal(_shell_signal)
	assert_bool(shell._is_gui_open).is_true()
	
	# simulate ~ then check that the signal was fired and the
	# shell is now closed
	_console_runner.simulate_key_pressed(KEY_QUOTELEFT)
	_console_runner.await_signal(_shell_signal)
	assert_bool(shell._is_gui_open).is_false()
