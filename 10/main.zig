const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("10/input.txt");
    const inputs = try splitOne(input, "\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var total1: usize = 0;
    var total2: usize = 0;

    var adapters = std.ArrayList(u64).init(allocator);
    try adapters.ensureCapacity(165);
    var max: u64 = 0;

    for (inputs) |line, i| {
        const num = try parseInt(line, 10);

        adapters.appendAssumeCapacity(num);
        max = std.math.max(max, num);
    }

    adapters.appendAssumeCapacity(0);
    adapters.appendAssumeCapacity(max + 3);

    std.sort.sort(u64, adapters.items, {}, comptime std.sort.asc(u64));

    Benchmark.read().print("Input");
    Benchmark.reset();

    var differences = mem.zeroes([4]u32);
    for (adapters.items) |n, i| {
        if (i < 1) continue;

        const diff = n - adapters.items[i - 1];
        differences[diff] += 1;
    }

    total1 = differences[1] * differences[3];

    Benchmark.read().print("Part 1");
    Benchmark.reset();

    var counts = try allocator.alloc(u64, adapters.items.len + 1);
    for (counts) |*c| {
        c.* = 0;
    }

    counts[0] = 1;
    for (adapters.items) |n, i| {
        var count: u64 = 0;

        if (i > 0 and adapters.items[i - 1] <= n and n - adapters.items[i - 1] <= 3)
            count += counts[i - 1];
        if (i > 1 and adapters.items[i - 2] <= n and n - adapters.items[i - 2] <= 3)
            count += counts[i - 2];
        if (i > 2 and adapters.items[i - 3] <= n and n - adapters.items[i - 3] <= 3)
            count += counts[i - 3];

        counts[i + 1] = count;
    }

    total2 = counts[inputs.len];

    Benchmark.read().print("Part 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
