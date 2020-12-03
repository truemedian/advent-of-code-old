const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    const input = try getFileSlice("01/input.txt");
    const inputs = try splitOne(input, "\n");

    var list = std.ArrayList(usize).init(allocator);

    for (inputs) |num| {
        const n = try std.fmt.parseInt(usize, num, 10);
        try list.append(n);
    }

    for (list.items) |num1, x| {
        for (list.items[x + 1 ..]) |num2, y| {
            if (num1 + num2 == 2020) {
                std.debug.print("P1: {}\n", .{num1 * num2});
            }

            for (list.items[x + y + 1 ..]) |num3, z| {
                if (num1 + num2 + num3 == 2020) {
                    std.debug.print("P2: {}\n", .{num1 * num2 * num3});
                }
            }
        }
    }
}
