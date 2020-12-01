const std = @import("std");
const utils = @import("utils");

pub fn main() !void {
    const input = try utils.getFileSlice("01/input.txt");

    const inputs = try utils.split(input, "\n");
    
    var list = std.ArrayList(usize).init(utils.allocator);
    
    var count: usize = 0;
    for (inputs) |num| {
        const n = try std.fmt.parseInt(usize, num, 10);
        try list.append(n);

        count += 1;
    }

    var i: usize = 0;
    while (i < count) : (i += 1) {
        var j: usize = 0;
        while (j < count) : (j += 1) {
            if (i != j) {
                if (list.items[i] + list.items[j] == 2020) {
                    std.debug.print("P1: {}\n", .{list.items[i] * list.items[j]});
                }
            }

            var z: usize = 0;
            while (z < count) : (z += 1) {
                if (i != j and j != z and i != z) {
                    if (list.items[i] + list.items[j] + list.items[z] == 2020) {
                        std.debug.print("P2: {}\n", .{list.items[i] * list.items[j]* list.items[z]});
                    }
                }
            }
        }
    }
}