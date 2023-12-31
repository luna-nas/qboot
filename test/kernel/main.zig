const fmt = @import("std").fmt;
const mem = @import("std").mem;
const Writer = @import("std").io.Writer;

const VGA_WIDTH = 80;
const VGA_HEIGHT = 25;
const VGA_SIZE = VGA_WIDTH * VGA_HEIGHT;

pub const ConsoleColors = enum(u8) {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Magenta = 5,
    Brown = 6,
    LightGray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightMagenta = 13,
    LightBrown = 14,
    White = 15,
};

var row: usize = 0;
var column: usize = 0;
var color = vgaEntryColor(ConsoleColors.LightGray, ConsoleColors.Black);
var buffer: *volatile [25][160]u8 = @ptrFromInt(0xB8000);

fn vgaEntryColor(fg: ConsoleColors, bg: ConsoleColors) u8 {
    return @intFromEnum(fg) | (@intFromEnum(bg) << 4);
}

fn vgaEntry(uc: u8, new_color: u8) u16 {
    var c: u16 = new_color;

    return uc | (c << 8);
}

pub fn initialize() void {
    row = 0;
    column = 0;
    clear();
}

pub fn setColor(new_color: u8) void {
    color = new_color;
}

pub fn clear() void {
    for (0..24) |y| {
        for (0..80) |x| {
            putCharAt(0, @intCast(x), @intCast(y));
        }
    }
}

pub fn putCharAt(c: u8, x: usize, y: usize) void {
    buffer[y][x * 2] = c;
    buffer[y][x * 2 + 1] = color;
}

pub fn putChar(c: u8) void {
    putCharAt(c, column, row);
    column += 1;
    if (column == VGA_WIDTH) {
        column = 0;
        row += 1;
        if (row == VGA_HEIGHT)
            row = 0;
    }
}

pub fn puts(data: []const u8) void {
    for (data) |c|
        putChar(c);
}

export fn main() void {
    asm volatile ("mov $0x80000, %esp");
    initialize();
    puts("Hello from kernel!");
    while (true) asm volatile ("hlt");
}
