const std = @import("std");
usingnamespace @import("utils");

fn check(map: *BagMap, name: []const u8) anyerror!bool {
    const list = map.get(name).?;

    for (list) |bag| {
        if (std.mem.eql(u8, bag.name, "shiny gold")) {
            return true;
        } else if (try check(map, bag.name)) {
            return true;
        }
    }

    return false;
}

fn count(map: *BagMap, name: []const u8) anyerror!usize {
    const list = map.get(name).?;
    var n: usize = 1;

    for (list) |bag| {
        const next = try count(map, bag.name);

        n += bag.count * next;
    }

    return n;
}

const Bag = struct {
    name: []const u8,
    count: usize,
};

const BagMap = std.StringHashMap([]Bag);

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("07/input.txt");
    const inputs = try splitOne(input, "\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var total1: usize = 0;

    var map = BagMap.init(allocator);
    try map.ensureCapacity(1024);
    for (inputs) |line| {
        var what = mem.tokenize(line, " ,.");

        _ = what.next();
        _ = what.next();

        const contain_index = what.index;

        _ = what.next();
        _ = what.next();

        const container = line[0..contain_index];

        var list = try allocator.alloc(Bag, 6);

        var n: usize = 0;
        while (true) : (n += 1) {
            const before = what.index;
            _ = what.next() orelse break;
            const num_index = what.index;
            _ = what.next();
            _ = what.next();
            const name_index = what.index;
            _ = what.next() orelse break;

            const num_shift: usize = if (n == 0) 1 else 2;
            const bag = line[num_index + 1 .. name_index];
            const num = try std.fmt.parseUnsigned(usize, line[before + num_shift .. num_index], 10);

            list[n] = .{
                .name = bag,
                .count = num,
            };
        }

        map.putAssumeCapacity(container, list[0..n]);
    }

    Benchmark.read().print("Input");
    Benchmark.reset();

    var it = map.iterator();
    while (it.next()) |entry| {
        if (try check(&map, entry.key)) {
            total1 += 1;
        }
    }

    Benchmark.read().print("Part 1");
    Benchmark.reset();

    var total2 = try count(&map, "shiny gold");

    Benchmark.read().print("Part 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2 - 1});
}
