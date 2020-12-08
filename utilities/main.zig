const std = @import("std");

const fs = std.fs;

pub const allocator = &allocator_instance.allocator;
pub var allocator_instance = std.heap.GeneralPurposeAllocator(.{
    .safety = false,
    .enable_memory_limit = true,
}){};

pub fn getFileSlice(name: []const u8) ![]const u8 {
    const file = try fs.cwd().openFile(name, .{});

    const data = try file.readToEndAlloc(allocator, 4 * 1024 * 1024);
    return std.mem.trim(u8, data, &std.ascii.spaces);
}

pub fn getFileReader(name: []const u8) !fs.File.Reader {
    const file = try fs.cwd().openFile(name, .{});

    return file.reader();
}

pub fn countOne(data: []const u8, delim: []const u8) usize {
    var pos: usize = 0;
    var n: usize = 0;

    while (std.mem.indexOfPos(u8, data, pos, delim)) |next| {
        pos = next + 1;
        n += 1;
    }

    return n;
}

pub fn countAny(data: []const u8, delims: []const u8) usize {
    var pos: usize = 0;
    var n: usize = 0;

    while (std.mem.indexOfAnyPos(u8, data, pos, delims)) |next| {
        pos = next + 1;
        n += 1;
    }

    return n;
}

pub fn splitOne(data: []const u8, delim: []const u8) ![][]const u8 {
    var ret = try allocator.alloc([]const u8, countOne(data, delim) + 1);
    var it = std.mem.split(data, delim);

    for (ret) |_, i| {
        ret[i] = it.next() orelse unreachable;
    }

    return ret;
}

pub fn splitAny(data: []const u8, delims: []const u8) ![][]const u8 {
    var ret = try allocator.alloc([]const u8, countAny(data, delims) + 1);
    var it = std.mem.tokenize(data, delims);

    // The countAny implementation doesn't ignore sequences of delimitors, while tokenize does, so this will fill as much as possible
    var i: usize = 0;
    while (it.next()) |v| {
        ret[i] = v;
        i += 1;
    }

    return ret;
}

pub fn parseIntSigned(buffer: []const u8, radix: u8) !i64 {
    return std.fmt.parseInt(i64, buffer, radix);
}

pub fn parseInt(buffer: []const u8, radix: u8) !u64 {
    return std.fmt.parseInt(u64, buffer, radix);
}

pub const Benchmark = struct {
    pub const Result = struct {
        time_taken: u64 = 0,
        bytes_used: isize = 0,

        pub fn print(self: Result, name: []const u8) void {
            const seconds = self.time_taken / 1_000_000_000;
            const milliseconds = (self.time_taken / 1_000_000) % 1_000;
            const microseconds = (self.time_taken / 1_000) % 1_000;
            const nanoseconds = (self.time_taken) % 1_000;

            const megabytes = @mod(@divFloor(self.bytes_used, 1_024 * 1_024), 1024);
            const kilobytes = @mod(@divFloor(self.bytes_used, 1_024), 1024);
            const bytes = @mod(self.bytes_used, 1024);

            std.debug.print(
                \\Benchmark {}:
                \\  Time:   {}s {}ms {}us {}ns
                \\  Memory: {}MB {}KB {}B
                \\
            , .{ name, seconds, milliseconds, microseconds, nanoseconds, megabytes, kilobytes, bytes });
        }
    };

    var timer: std.time.Timer = undefined;
    var starting_memory: usize = 0;

    pub fn init() !void {
        timer = try std.time.Timer.start();

        Benchmark.reset();
    }

    pub fn reset() void {
        timer.reset();
        starting_memory = allocator_instance.total_requested_bytes;
    }

    pub fn read() Result {
        return .{
            .time_taken = timer.read(),
            .bytes_used = @intCast(isize, allocator_instance.total_requested_bytes) - @intCast(isize, starting_memory),
        };
    }
};
