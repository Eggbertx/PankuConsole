class_name PankuNativeLoggerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

const _console_scene = "res://addons/panku_console/console.tscn"
const _shell_module_name = "interactive_shell"
const _logger_module_name = "native_logger"
const _overlay_show_opt = PankuModuleNativeLogger.ScreenOverlayDisplayMode.AlwaysShow

var console:PankuConsole
var _console_runner: GdUnitSceneRunner
var _console_ui_runner: GdUnitSceneRunner
var shell: PankuModuleInteractiveShell
var logger: PankuModuleNativeLogger

func before():
	console = get_node(PankuConsole.SingletonPath)
	shell = console.module_manager.get_module(_shell_module_name)
	logger = console.module_manager.get_module(_logger_module_name)
	_console_runner = scene_runner(_console_scene)
	_console_ui_runner = scene_runner("res://addons/panku_console/modules/interactive_shell/console_ui/panku_console_ui.tscn")
	auto_free(_console_runner)
	auto_free(_console_ui_runner)
	PankuConfig.set_config({
		"native_logger": {
			"screen_overlay": _overlay_show_opt
		}
	})

func after():
	if shell._is_gui_open:
		_console_runner.simulate_key_pressed(KEY_QUOTELEFT)

func test_native_logger():
	assert_object(console).is_not_null()
	assert_object(shell).is_not_null()
	assert_object(logger).is_not_null()
	assert_object(logger.native_logs_monitor).is_not_null()
	assert_int(logger.output_overlay_display_mode).is_equal(_overlay_show_opt)
	_console_runner.simulate_key_press(KEY_QUOTELEFT)
	assert_bool(shell._is_gui_open).is_true()

	_console_ui_runner.simulate_key_pressed(KEY_C)
	await await_idle_frame()
	_console_ui_runner.simulate_key_pressed(KEY_C)
	await await_idle_frame()
	# var ba = "general_settings.open()".to_ascii_buffer()
	# for b in ba:
	# 	_console_ui_runner.simulate_key_pressed(KEY_C)
	# 	await await_idle_frame()

	# print("Hello, logger!")
	# _console_runner.await_signal_on(logger.native_logs_monitor, "info_msg_received", ["Hello, loggers!"])

