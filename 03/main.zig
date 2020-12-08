const std = @import("std");
usingnamespace @import("utils");

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
    try Benchmark.init();

    const input = try getFileSlice("03/input.txt");
    const inputs = try splitAny(input, "\r\n");
    
    Benchmark.read().print("File");
    Benchmark.reset();

    const count13 = countTrees(inputs, 1, 3);

    Benchmark.read().print("Part 1");
    Benchmark.reset();

    const count11 = countTrees(inputs, 1, 1);
    const count15 = countTrees(inputs, 1, 5);
    const count17 = countTrees(inputs, 1, 7);
    const count21 = countTrees(inputs, 2, 1);
    
    Benchmark.read().print("Part 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{count13});
    std.debug.print("P2: {}\n", .{count11 * count13 * count15 * count17 * count21});
}
