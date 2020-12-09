const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("09/input.txt");
    const inputs = try splitOne(input, "\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var total1: usize = 0;
    var total2: usize = 0;

    var nums = try allocator.alloc(u64, inputs.len);
    for (inputs) |line, i| {
        nums[i] = try parseInt(line, 10);
    }

    var pos: usize = 0;
    while (pos + 25 < nums.len) : (pos += 1) {
        var valid = false;

        const num = nums[pos + 25];
        outer: for (nums[pos .. pos + 25]) |a, i| {
            for (nums[pos .. pos + 25]) |b, j| {
                const sum = a + b;

                if (i != j and sum == num) {
                    valid = true;
                    break :outer;
                }
            }
        }

        if (!valid) {
            total1 = num;
            break;
        }
    }

    Benchmark.read().print("Part 1");
    Benchmark.reset();

    var set = std.AutoHashMap(i64, u64).init(allocator);
    try set.ensureCapacity(1024);

    pos = 0;
    var sum: i64 = 0;

    while (pos < nums.len) : (pos += 1) {
        set.putAssumeCapacity(sum, pos);
        sum += @intCast(i64, nums[pos]);

        if (set.contains(sum - @intCast(i64, total1))) {
            var min: u64 = std.math.maxInt(u64);
            var max: u64 = std.math.minInt(u64);

            const start = set.get(sum - @intCast(i64, total1)).?;
            for (nums[start .. pos + 1]) |n| {
                min = std.math.min(min, n);
                max = std.math.max(max, n);
            }

            total2 = min + max;
            break;
        }
    }
    
    Benchmark.read().print("Part 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
