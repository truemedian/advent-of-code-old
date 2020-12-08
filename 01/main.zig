const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("01/input.txt");
    const inputs = try splitAny(input, "\r\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var list: [200]u32 = undefined;

    for (inputs) |num, i| {
        list[i] = try std.fmt.parseInt(u32, num, 10);
    }

    Benchmark.read().print("Input");
    Benchmark.reset();

    var total1: usize = 0;
    var total2: usize = 0;

    for (list) |num1, x| {
        for (list[x + 1 ..]) |num2, y| {
            if (num1 + num2 == 2020) {
                total1 = num1 * num2;
            }

            for (list[x + y + 1 ..]) |num3, z| {
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
