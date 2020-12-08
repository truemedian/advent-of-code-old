const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    const input = try getFileSlice("06/input.txt");
    const inputs = try splitOne(input, "\n\n");

    var total1: usize = 0;
    var total2: usize = 0;

    try Benchmark.init();

    for (inputs) |batch| {
        const people = try splitOne(batch, "\n");

        var map = std.AutoHashMap(u8, usize).init(allocator);

        for (people) |answered| {
            for (answered) |question| {
                var entry = try map.getOrPutValue(question, 0);
                entry.*.value = entry.value + 1;
            }
        }

        var it = map.iterator();
        while (it.next()) |entry| {
            total1 += 1;

            if (entry.value == people.len) {
                total2 += 1;
            }
        }
    }

    Benchmark.read().print("Part 1 & 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
