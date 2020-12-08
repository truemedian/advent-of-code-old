const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    const input = try getFileSlice("01/input.txt");
    const inputs = try splitAny(input, "\r\n");

    var list = std.ArrayList(usize).init(allocator);

    try Benchmark.init();

    for (inputs) |num| {
        const n = try std.fmt.parseInt(usize, num, 10);
        try list.append(n);
    }

    Benchmark.read().print("Input");
    Benchmark.reset();

    var total1: usize = 0;
    var total2: usize = 0;

    for (list.items) |num1, x| {
        for (list.items[x + 1 ..]) |num2, y| {
            if (num1 + num2 == 2020) {
                total1 = num1 * num2;
            }

            for (list.items[x + y + 1 ..]) |num3, z| {
                if (num1 + num2 + num3 == 2020) {
                    total2 = num1 * num2 * num3;
                }
            }
        }
    }

    Benchmark.read().print("Part 1 & 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
