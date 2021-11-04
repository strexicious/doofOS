
const VGA_WIDTH: usize = 80;
const VGA_HEIGHT: usize = 25;
 
var terminal_row: usize = undefined;
var terminal_column: usize = undefined;
var terminal_color: u8 = undefined;
var terminal_buffer: [*]u16 = undefined;

const VgaColor = enum(u8) {
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GREY = 7,
    VGA_COLOR_DARK_GREY = 8,
    VGA_COLOR_LIGHT_BLUE = 9,
    VGA_COLOR_LIGHT_GREEN = 10,
    VGA_COLOR_LIGHT_CYAN = 11,
    VGA_COLOR_LIGHT_RED = 12,
    VGA_COLOR_LIGHT_MAGENTA = 13,
    VGA_COLOR_LIGHT_BROWN = 14,
    VGA_COLOR_WHITE = 15,
};

inline fn vga_entry_color(fg: VgaColor, bg: VgaColor) u8 {
    return @enumToInt(bg) << 4 | @enumToInt(fg);
}

inline fn vga_entry(uc: u8, color: u8) u16 {
    return @as(u16, color) << 8 | @as(u16, uc);
}

fn terminal_initialise() void {
    terminal_row = 0;
    terminal_column = 0;
    terminal_color = vga_entry_color(VgaColor.VGA_COLOR_LIGHT_GREY, VgaColor.VGA_COLOR_BLACK);
    terminal_buffer = @intToPtr([*]u16, 0xB8000);
}

fn terminal_setcolor(color: u8) void {
    terminal_color = color;
}

fn terminal_putentryat(c: u8, color: u8, x: usize, y: usize) void {
    const index = y * VGA_WIDTH + x;
    terminal_buffer[index] = vga_entry(c, color);
}

fn terminal_putchar(c: u8) void {
    terminal_putentryat(c, terminal_color, terminal_column, terminal_row);

    terminal_column = (terminal_column + 1) % VGA_WIDTH;
    if (terminal_column == 0) terminal_row = (terminal_row + 1) % VGA_HEIGHT;
}

fn terminal_write(data: []const u8) void {
    for (data) |c| {
        terminal_putchar(c);
    }
}

export fn kernel_main() void {
    terminal_initialise();

    terminal_write("Hello, kernel World!\n");
}
