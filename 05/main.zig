const std = @import("std");
usingnamespace @import("utils");

pub fn main() !void {
    const input = try getFileSlice("05/input.txt");
    const inputs = try splitOne(input, "\n");

    var total1: usize = 0;
    var total2: usize = 0;

    var seats = std.mem.zeroes([127 * 8 + 7]bool);

    for (inputs) |line| {
        var id: usize = 0;

        for (line) |c| {
            id <<= 1;
            id |= @boolToInt(c == 'B' or c == 'R');
        }
        
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
