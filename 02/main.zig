const std = @import("std");
const utils = @import("utils");

pub fn main() !void {
    const input = try utils.getFileSlice("02/input.txt");
    const inputs = try utils.split(input, "\n");

    var total1: usize = 0;
    var total2: usize = 0;
    for (inputs) |sl| {
        var next = try utils.split(sl, " ");

        var range = try utils.split(next[0], "-");
        const min = try std.fmt.parseInt(usize, range[0], 10);
        const max = try std.fmt.parseInt(usize, range[1], 10);

        const char = next[1][0];

        // Part 1
        var count: usize = 0;
        for (next[2]) |c| {
            if (c == char) {
                count += 1;
            }
        }

        if (count >= min and count <= max) {
            total1 += 1;
        }

        // Part 2
        const c1 = next[2][min - 1] == char;
        const c2 = next[2][max - 1] == char;

        if (c1 != c2) {
            total2 += 1;
        }
    }

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
