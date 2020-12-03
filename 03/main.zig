const std = @import("std");
const utils = @import("utils");

fn countTrees(map: [][]const u8, inc_x: usize, int_y: usize) usize {
    var count: usize = 0;

    var row: usize = 0;
    var col: usize = 0;
    while (row < map.len) : ({
        row += inc_x;
        col += int_y;
    }) {
        if (map[row][col % map[0].len] == '#') count += 1;
    }

    return count;
}

pub fn main() !void {
    const input = try utils.getFileSlice("03/input.txt");
    const inputs = try utils.split(input, "\n");

    const count11 = countTrees(inputs, 1, 1);
    const count13 = countTrees(inputs, 1, 3);
    const count15 = countTrees(inputs, 1, 5);
    const count17 = countTrees(inputs, 1, 7);
    const count21 = countTrees(inputs, 2, 1);

    std.debug.print("P1: {}\n", .{count13});
    std.debug.print("P2: {}\n", .{count11 * count13 * count15 * count17 * count21});
}
