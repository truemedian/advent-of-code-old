const std = @import("std");

const fs = std.fs;

pub const allocator = &allocator_instance.allocator;
pub var allocator_instance = std.heap.GeneralPurposeAllocator(.{
    .safety = false,
}){};

pub fn getFileSlice(name: []const u8) ![]const u8 {
    const file = try fs.cwd().openFile(name, .{});

    const data = try file.reader().readAllAlloc(allocator, 4 * 1024 * 1024);
    return std.mem.trim(u8, data, &std.ascii.spaces);
}

pub fn getFileReader(name: []const u8) !fs.File.Reader {
    const file = try fs.cwd().openFile(name, .{});

    return file.reader();
}

pub fn count(data: []const u8, delim: []const u8) usize {
    var pos: usize = 0;
    var n: usize = 0;

    while (std.mem.indexOfPos(u8, data, pos, delim)) |next| {
        pos = next + 1;
        n += 1;
    }

    return n;
}

pub fn split(data: []const u8, delim: []const u8) ![][]const u8 {
    var ret = try allocator.alloc([]const u8, count(data, delim) + 1);
    var it = std.mem.split(data, delim);

    for (ret) |_, i| {
        ret[i] = it.next() orelse unreachable;
    }

    return ret;
}
