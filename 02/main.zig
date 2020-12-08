const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("02/input.txt");
    const inputs = try splitAny(input, "\r\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var total1: usize = 0;
    var total2: usize = 0;
    for (inputs) |sl| {
        var it = mem.tokenize(sl, " -:");

        const min = try std.fmt.parseInt(u32, it.next().?, 10);
        const max = try std.fmt.parseInt(u32, it.next().?, 10);

        const char = it.next().?[0];
        const word = it.next().?;

        // Part 1
        var count: usize = 0;
        for (word) |c| {
            if (c == char) {
                count += 1;
            }
        }

        if (count >= min and count <= max) {
            total1 += 1;
        }

        // Part 2
        const c1 = word[min - 1] == char;
        const c2 = word[max - 1] == char;

        if (c1 != c2) {
            total2 += 1;
        }
    }

    Benchmark.read().print("Part 1 & 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
