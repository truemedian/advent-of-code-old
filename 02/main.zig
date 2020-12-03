const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    const input = try getFileSlice("02/input.txt");
    const inputs = try splitAny(input, "\r\n");

    var total1: usize = 0;
    var total2: usize = 0;
    for (inputs) |sl| {
        var next = try splitAny(sl, " -:");

        const min = try std.fmt.parseInt(usize, next[0], 10);
        const max = try std.fmt.parseInt(usize, next[1], 10);

        const char = next[2][0];

        // Part 1
        var count: usize = 0;
        for (next[3]) |c| {
            if (c == char) {
                count += 1;
            }
        }

        if (count >= min and count <= max) {
            total1 += 1;
        }

        // Part 2
        const c1 = next[3][min - 1] == char;
        const c2 = next[3][max - 1] == char;

        if (c1 != c2) {
            total2 += 1;
        }
    }

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
