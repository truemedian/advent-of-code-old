const std = @import("std");
usingnamespace @import("utils");

const Interpreter = struct {
    pub const Instruction = struct {
        pub const Operation = enum {
            acc,
            jmp,
            nop,
        };

        opcode: Operation,
        arg1: i64,

        pub fn parse(line: []const u8) !Instruction {
            const split = try splitOne(line, " ");
            const arg1 = try parseIntSigned(split[1], 10);

            inline for (std.meta.fields(Operation)) |field| {
                if (mem.eql(u8, field.name, split[0])) {
                    return Instruction{
                        .opcode = @field(Operation, field.name),
                        .arg1 = arg1,
                    };
                }
            }

            unreachable;
        }
    };

    initial_state: []Instruction,

    lines: []u8,
    instructions: []Instruction,
    success: bool = false,

    rip: usize = 0,
    accumulator: i64 = 0,

    pub fn preinit(chunks: []const []const u8) ![]Instruction {
        const instructions = try allocator.alloc(Instruction, chunks.len);
        for (instructions) |*c, i| {
            c.* = try Instruction.parse(chunks[i]);
        }

        return instructions;
    }

    pub fn init(instructions: []Instruction) !Interpreter {
        const lines = try allocator.alloc(u8, instructions.len);
        for (lines) |*c| {
            c.* = 0;
        }

        const initial = try allocator.dupe(Instruction, instructions);

        return Interpreter{
            .initial_state = initial,
            .lines = lines,
            .instructions = instructions,
        };
    }

    pub fn reload(self: *Interpreter) void {
        for (self.lines) |*c| {
            c.* = 0;
        }

        for (self.instructions) |*c, i| {
            c.* = self.initial_state[i];
        }
    }

    pub fn step(self: *Interpreter) bool {
        if (self.lines[self.rip] > 0) return true;
        if (self.rip + 1 == self.lines.len) {
            self.success = true;
            return true;
        }

        self.lines[self.rip] += 1;

        const inst = self.instructions[self.rip];

        switch (inst.opcode) {
            .acc => {
                self.accumulator += inst.arg1;
                self.rip += 1;
            },
            .jmp => {
                self.rip = @intCast(usize, @intCast(isize, self.rip) + inst.arg1);
            },
            .nop => {
                self.rip += 1;
            },
        }

        return false;
    }

    pub fn swapJmpNop(self: *Interpreter, index: usize) bool {
        const inst = self.instructions[index];

        switch (inst.opcode) {
            .nop => {
                self.instructions[index] = .{
                    .opcode = .jmp,
                    .arg1 = inst.arg1,
                };
            },
            .jmp => {
                self.instructions[index] = .{
                    .opcode = .nop,
                    .arg1 = inst.arg1,
                };
            },
            else => return false,
        }

        return true;
    }

    pub fn run(self: *Interpreter) bool {
        while (true) {
            if (self.step()) break;
        }

        return self.success;
    }
};

pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("08/input.txt");
    const inputs = try splitOne(input, "\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    const instructions = try Interpreter.preinit(inputs);

    Benchmark.read().print("Initialization");
    Benchmark.reset();

    var total1: i64 = 0;
    var total2: i64 = 0;

    var vm = try Interpreter.init(instructions);
    _ = vm.run();

    total1 = vm.accumulator;

    Benchmark.read().print("Part 1");
    Benchmark.reset();

    for (instructions) |_, i| {
        vm.reload();

        if (vm.swapJmpNop(i)) {
            const finished = vm.run();

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
