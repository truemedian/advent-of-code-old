const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("06/input.txt");
    const inputs = try splitOne(input, "\n\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var total1: usize = 0;
    var total2: usize = 0;

    for (inputs) |batch| {
        var people = mem.split(batch, "\n");

        var map = mem.zeroes([26]u32);
        var count: u32 = 0;

        while (people.next()) |answered| {
            count += 1;
            for (answered) |question| {
                map[question - 'a'] += 1;
            }
        }

        for (map) |entry| {
            if (entry > 0) total1 += 1;

            if (entry == count) {
                total2 += 1;
            }
        }
    }

    Benchmark.read().print("Part 1 & 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
