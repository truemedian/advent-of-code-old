const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    const input = try getFileSlice("05/input.txt");
    const inputs = try splitOne(input, "\n");

    var total1: usize = 0;
    var total2: usize = 0;

    var seats = std.mem.zeroes([127 * 8 + 7]bool);

    for (inputs) |line| {
        var row: usize = 0;
        var col: usize = 0;

        var hi: usize = 127;
        var lo: usize = 0;

        for (line[0..7]) |c| {
            if (c == 'F') {
                hi = (lo + hi) / 2;
            } else if (c == 'B') {
                lo = (lo + hi) / 2 + 1;
            } else unreachable;
        }

        row = lo;

        hi = 7;
        lo = 0;

        for (line[7..]) |c| {
            if (c == 'L') {
                hi = (lo + hi) / 2;
            } else if (c == 'R') {
                lo = (lo + hi) / 2 + 1;
            } else unreachable;
        }

        col = lo;

        const id = row * 8 + col;
        seats[id] = true;

        total1 = std.math.max(total1, id);
    }

    var r: usize = 1;
    while (r < 127) : (r += 1) {
        var c: usize = 0;
        while (c < 7) : (c += 1) {
            const id = r * 8 + c;

            if (seats[id] == false and seats[id + 1] == true and seats[id - 1] == true) {
                total2 = id;
            }
        }
    }

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
