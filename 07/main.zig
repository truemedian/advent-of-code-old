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

const BagList = std.ArrayList(Bag);
const BagMap = std.StringHashMap([]Bag);

pub fn main() !void {
    const input = try getFileSlice("07/input.txt");
    const inputs = try splitOne(input, "\n");

    try Benchmark.init();

    var total1: usize = 0;

    var map = BagMap.init(allocator);
    for (inputs) |line| {
        const what = try splitAny(line, " ,.");

        const container = try std.mem.join(allocator, " ", what[0..2]);

        var list = BagList.init(allocator);

        var i: usize = 4;
        while (i + 4 < what.len) : (i += 4) {
            const bag = try std.mem.join(allocator, " ", what[i + 1 .. i + 3]);
            const num = try std.fmt.parseUnsigned(usize, what[i], 10);

            try list.append(.{
                .name = bag,
                .count = num,
            });
        }

        try map.put(container, list.items);
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
