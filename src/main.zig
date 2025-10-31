const std = @import("std");

const io = std.io;
const os = std.os;
const fmt = std.fmt;
const fs = std.fs;
const process = std.process;
const ascii = std.ascii;

const max_lines: usize = 1000;
const max_line_length: usize = 256;

const arrow_up: u16 = 1000;
const arrow_down: u16 = 1001;
const arrow_right: u16 = 1002;
const arrow_left: u16 = 1003;

const EditorMode = enum {
    normal_mode,
    insert_mode,
    command_mode,
};

const LineBuffer = struct {
    buf: [max_line_length]u8 = std.mem.zeroes([max_line_length]u8),
    len: usize = 0,

    pub fn slice(self: LineBuffer) []const u8 {
        return self.buf[0..self.len];
    }
};
test "LineBuffer slice helper" {
    var line = LineBuffer{};

    try std.testing.expect(std.mem.eql(u8, line.slice(), ""));

    line.buf[0] = 'h';
    line.buf[1] = 'e';
    line.buf[2] = 'l';
    line.buf[3] = 'l';
    line.buf[4] = 'o';
    line.len = 5;

    try std.testing.expect(std.mem.eql(u8, line.slice(), "hello"));

    line.len = 2;
    try std.testing.expect(std.mem.eql(u8, line.slice(), "he"));
}

const TextEditor = struct {
    text_lines: [max_lines]LineBuffer = undefined,
    total_lines: usize = 1,
    cursor_x: usize = 0,
    cursor_y: usize = 0,
    current_mode: EditorMode = .normal_mode,
    filename: [256]u8 = std.mem.zeroes([256]u8),
    filename_len: usize = 0,
    command_buffer: [256]u8 = std.mem.zeroes([256]u8),
    command_length: usize = 0,
    has_unsaved_changes: bool = false,

    pub fn getFilenameSlice(self: TextEditor) []const u8 {
        return self.filename[0..self.filename_len];
    }

    pub fn getCommandSlice(self: TextEditor) []const u8 {
        return self.command_buffer[0..self.command_length];
    }
};

test "TextEditor slice helpers" {
    var ed = TextEditor{ .text_lines = undefined };

    std.mem.copyForwards(u8, &ed.filename, "testfile.txt");
    ed.filename_len = 12;

    std.mem.copyForwards(u8, &ed.command_buffer, "wq");
    ed.command_length = 2;

    try std.testing.expect(std.mem.eql(u8, ed.getFilenameSlice(), "testfile.txt"));
    try std.testing.expect(std.mem.eql(u8, ed.getCommandSlice(), "wq"));

    var ed_empty = TextEditor{};
    try std.testing.expect(std.mem.eql(u8, ed_empty.getFilenameSlice(), ""));
    try std.testing.expect(std.mem.eql(u8, ed_empty.getCommandSlice(), ""));
}

var original_terminal_settings: os.tty.Termios = undefined;
var editor: TextEditor = .{};

fn ctrlKey(k: u8) u8 {
    return k & 0x1f;
}

test "ctrlKey function" {
    try std.testing.expect(ctrlKey('h') == 0x08);
    try std.testing.expect(ctrlKey('c') == 0x03);
    try std.testing.expect(ctrlKey('q') == 0x11);
}

pub fn main() !void {
    std.debug.print("Skibidi ", .{});
}
