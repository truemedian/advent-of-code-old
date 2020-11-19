const std = @import("std");

const fs = std.fs;

pub const allocator = &allocator_instance.allocator;
pub var allocator_instance = std.heap.GeneralPurposeAllocator(.{
    .safety = false,
}){};

pub fn getFileSlice(name: []const u8) ![]const u8 {
    const file = try fs.cwd().openFile(name, .{});

    return file.reader().readAllAlloc(allocator, 4 * 1024 * 1024);
}

pub fn getFileReader(name: []const u8) !fs.File.Reader {
    const file = try fs.cwd().openFile(name, .{});

    return file.reader();
}
