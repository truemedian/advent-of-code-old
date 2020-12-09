const std = @import("std");
usingnamespace @import("utils");

const Interpreter = Handheld.Interpreter;

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("08/input.txt");
    const inputs = try splitOne(input, "\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    Benchmark.read().print("Initialization");
    Benchmark.reset();

    var total1: i64 = 0;
    var total2: i64 = 0;

    var vm = try Interpreter.init(inputs);
    _ = vm.run() catch {};

    total1 = vm.accumulator;

    Benchmark.read().print("Part 1");
    Benchmark.reset();

    for (inputs) |_, i| {
        vm.reload();

        if (vm.swapJmpNop(i)) {
            const finished = vm.run() catch |err| switch (err) {
                error.LoopDetected => false,
                else => return err,
            };

            if (finished) {
                total2 = vm.accumulator;
                break;
            }
        }
    }

    Benchmark.read().print("Part 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{total1});
    std.debug.print("P2: {}\n", .{total2});
}
