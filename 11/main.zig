const std = @import("std");
usingnamespace @import("utils");

const math = std.math;

fn check(game: []const []const u8, y: usize, x: usize, comptime dy: i8, comptime dx: i8, comptime pass_floor: bool) u8 {
    var dfy = dy;
    var dfx = dx;

    if (pass_floor) {
        while (true) {
            const ify = @intCast(isize, y) + dfy;
            const ifx = @intCast(isize, x) + dfx;

            if (ify < 0 or ify >= game.len) return 0;
            if (ifx < 0 or ifx >= game[y].len) return 0;

            const fy = @intCast(usize, ify);
            const fx = @intCast(usize, ifx);

            if (game[fy][fx] == '#') return 1;
            if (game[fy][fx] == 'L') return 0;

            dfy += dy;
            dfx += dx;
        }
    } else {
        const ify = @intCast(isize, y) + dfy;
        const ifx = @intCast(isize, x) + dfx;

        if (ify < 0 or ify >= game.len) return 0;
        if (ifx < 0 or ifx >= game[y].len) return 0;

        const fy = @intCast(usize, ify);
        const fx = @intCast(usize, ifx);

        if (game[fy][fx] == '#') return 1;
    }

    return 0;
}

fn adjacent(game: []const []const u8, x: usize, y: usize, comptime pass_floor: bool) u8 {
    var count: u8 = 0;

    count += check(game, y, x, -1, -1, pass_floor);
    count += check(game, y, x, -1, 0, pass_floor);
    count += check(game, y, x, -1, 1, pass_floor);

    count += check(game, y, x, 0, -1, pass_floor);
    count += check(game, y, x, 0, 1, pass_floor);

    count += check(game, y, x, 1, -1, pass_floor);
    count += check(game, y, x, 1, 0, pass_floor);
    count += check(game, y, x, 1, 1, pass_floor);

    return count;
}

fn step(game: []const []const u8, out: [][]u8, comptime pickiness: u8, comptime pass_floor: bool) bool {
    var changed = false;

    for (game) |line, y| {
        for (game[y]) |char, x| {
            const adj = adjacent(game, x, y, pass_floor);

            if (char == 'L' and adj == 0) {
                out[y][x] = '#';
                changed = true;
            } else if (char == '#' and adj >= pickiness) {
                out[y][x] = 'L';
                changed = true;
            } else {
                out[y][x] = char;
            }
        }
    }

    return changed;
}

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("11/input.txt");
    const inputs = try splitOne(input, "\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var total1: usize = 0;
    var total2: usize = 0;

    var game = try allocator.alloc([]u8, inputs.len);
    for (game) |*c, i| {
        c.* = try allocator.dupe(u8, inputs[i]);
    }

    var game_out = try allocator.alloc([]u8, inputs.len);
    for (game_out) |*c, i| {
        c.* = try allocator.dupe(u8, inputs[i]);
    }

    var game_temp: [][]u8 = undefined;

    Benchmark.read().print("Input");
    Benchmark.reset();

    var changed = true;
    while (changed) {
        changed = step(game, game_out, 4, false);

        game_temp = game;
        game = game_out;
        game_out = game_temp;
    }

    for (game) |line, y| {
        for (game[y]) |char, x| {
            if (char == '#') {
                total1 += 1;
            }
        }
    }

    Benchmark.read().print("Part 1");
    Benchmark.reset();

    for (game) |*c, i| {
        c.* = try allocator.dupe(u8, inputs[i]);
    }
    
    Benchmark.read().print("Input Reset");
    Benchmark.reset();
    
    changed = true;
    while (changed) {
        changed = step(game, game_out, 5, true);

        game_temp = game;
        game = game_out;
        game_out = game_temp;
    }

    for (game) |line, y| {
        for (game[y]) |char, x| {
            if (char == '#') {
                total2 += 1;
            }
        }
    }

    Benchmark.read().print("Part 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
