const std = @import("std");
usingnamespace @import("utils");

fn check(map: *std.StringHashMap(std.ArrayList([]const u8)), name: []const u8) anyerror!bool {
    const list = map.get(name).?;

    for (list.items) |bag| {
        const split = try splitOne(bag, " ");
        const next = try std.mem.join(allocator, " ", split[1..]);

        if (std.mem.eql(u8, next, "shiny gold")) {
            return true;
        } else {
            if (try check(map, next)) {
                return true;
            }
        }
    }

    return false;
}

fn count(map: *std.StringHashMap(std.ArrayList([]const u8)), name: []const u8) anyerror!usize {
    const list = map.get(name).?;
    var n: usize = 1;

    for (list.items) |bag| {
        const split = try splitOne(bag, " ");
        const num = try std.fmt.parseUnsigned(usize, split[0], 10);
        const next = try std.mem.join(allocator, " ", split[1..]);

        const nnext = try count(map, next);

        n += num * nnext;
    }

    return n;
}


pub fn main() !void {
    const input = try getFileSlice("07/input.txt");
    const inputs = try splitOne(input, "\n");

    var total1: usize = 0;

    var map = std.StringHashMap(std.ArrayList([]const u8)).init(allocator);
    for (inputs) |line| {
        const what = try splitAny(line, " ,.");

        const container = try std.mem.join(allocator, " ", what[0..2]);

        var list = std.ArrayList([]const u8).init(allocator);

        var i: usize = 4;
        while (i + 4 < what.len) : (i += 4) {
            const bag = try std.mem.join(allocator, " ", what[i.. i + 3]);

            try list.append(bag);
        }

        try map.put(container, list);
    }

    var it = map.iterator();
    while (it.next()) |entry| {
        if (try check(&map, entry.key)) {
            total1 += 1;
        }
    }

    var total2 = try count(&map, "shiny gold");

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2 - 1});
}
