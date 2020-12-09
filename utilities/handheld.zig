const std = @import("std");
usingnamespace @import("main.zig");

pub const Interpreter = struct {
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

            inline for (meta.fields(Operation)) |field| {
                if (mem.eql(u8, field.name, split[0])) {
                    return Instruction{
                        .opcode = @field(Operation, field.name),
                        .arg1 = try parseIntSigned(split[1], 10),
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

    pub fn init(chunks: []const []const u8) !Interpreter {
        const lines = try allocator.alloc(u8, chunks.len);
        for (lines) |*c| {
            c.* = 0;
        }

        const instructions = try allocator.alloc(Instruction, chunks.len);
        const initial = try allocator.alloc(Instruction, chunks.len);

        for (initial) |*c, i| {
            c.* = try Instruction.parse(chunks[i]);
        }

        for (instructions) |*c, i| {
            c.* = initial[i];
        }

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

        self.success = false;
        self.rip = 0;
        self.accumulator = 0;
    }

    pub fn step(self: *Interpreter) !void {
        if (self.success) return;

        if (self.lines[self.rip] > 0) return error.LoopDetected; // encountered a line twice

        self.lines[self.rip] += 1;

        const inst = self.instructions[self.rip];

        switch (inst.opcode) {
            .acc => {
                self.accumulator += inst.arg1;
                self.rip += 1;
            },
            .jmp => {
                const rip = @intCast(isize, self.rip) + inst.arg1;
                if (rip < 0 or rip > self.lines.len) return error.InvalidJump;

                self.rip = @intCast(usize, rip);
            },
            .nop => {
                self.rip += 1;
            },
        }

        if (self.rip == self.lines.len) { // reached the last line
            self.success = true;
        }
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

    pub fn run(self: *Interpreter) !bool {
        while (!self.success) {
            try self.step();
        }

        return self.success;
    }
};
