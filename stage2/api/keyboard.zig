/// Abstraction over key codes returned by a keyboard interface
/// Unlike most parts of the bootloader, this is exhaustive across keys from all platforms, to support as much as possible.
pub const Scancode = union(enum) {
    printable: u16,
    function: enum {
        invalid,
        F1,
        F2,
        F3,
        F4,
        F5,
        F6,
        F7,
        F8,
        F9,
        F10,
        F11,
        F12,
        alt_left,
        shift_left,
        control_left,
        alt_right,
        shift_right,
        control_right,
        caps_lock,
        enter,
        backspace,
        escape,
        number_lock,
        scroll_lock,
        multimedia_search,
        multimedia_previous_track,
        multimedia_favorites,
        multimedia_refresh,
        multimedia_volume_up,
        multimedia_volume_down,
        multimedia_mute,
        multimedia_forward,
        multimedia_back,
        multimedia_stop,
        multimedia_calculator,
        multimedia_pause,
        multimedia_home,
        multimedia_computer,
        multimedia_email,
        multimedia_next_track,
        multimedia_select,
        acpi_wake,
        hibernate,
        acpi_sleep,
        acpi_power,
        left_gui,
        right_gui,
        apps,
        print_screen,
        pause,
        end,
        up,
        down,
        left,
        right,
        home,
        insert,
        delete,
        page_up,
        page_down,
        brightness_up,
        brightness_down,
        toggle_display,
        recovery,
        eject,
    },
};

/// Stores both a scancode and whether it was pressed or released
pub const KeyEvent = struct {
    pub const EventType = enum { pressed, released };
    pub const Modifiers = struct {
        alt: bool = false,
        ctrl: bool = false,
        shift: bool = false,
    };

    code: Scancode = Scancode{ .printable = 0 },
    event_type: EventType = .pressed,
    modifiers: Modifiers = .{},
};

pub const KeyboardInfo = struct {
    init: ?*const fn () anyerror!void,
    getInput: *const fn () ?KeyEvent,
    deinit: ?*const fn () anyerror!void,
};
