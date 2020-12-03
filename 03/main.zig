const std = @import("std");
const utils = @import("utils");

fn countTrees(map: [][]u8, inc_x: usize, int_y: usize) usize {
    var count: usize = 0;

    var row: usize = 0;
    var col: usize = 0;
    while (row < map.len) {
        if (map[row][col % map[0].len] == '#') {
            count += 1;
        }

        row += inc_x;
        col += int_y;
    }

    return count;
}

pub fn main() !void {
    const input = try utils.getFileSlice("03/input.txt");
    const inputs = try utils.split(input, "\n");

    const map = try utils.allocator.alloc([]u8, inputs.len);
    for (map) |*ptr| {
        ptr.* = try utils.allocator.alloc(u8, inputs[0].len);
    }

    for (inputs) |line, i| {
        for (line) |c, col| {
            map[i][col] = c;
        }
    }

    var row: usize = 0;
    var col: usize = 0;

    const count11 = countTrees(map, 1, 1);
    const count13 = countTrees(map, 1, 3);
    const count15 = countTrees(map, 1, 5);
    const count17 = countTrees(map, 1, 7);
    const count21 = countTrees(map, 2, 1);

    std.debug.print("P1: {}\n", .{count13});
    std.debug.print("P2: {}\n", .{count11 * count13 * count15 * count17 * count21});
}
