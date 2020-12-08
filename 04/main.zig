const std = @import("std");
usingnamespace @import("utils");

const Passport = struct {
    byr: ?[]const u8 = null,
    iyr: ?[]const u8 = null,
    eyr: ?[]const u8 = null,
    hgt: ?[]const u8 = null,
    hcl: ?[]const u8 = null,
    ecl: ?[]const u8 = null,
    pid: ?[]const u8 = null,
};

const colors = "amb blu brn gry grn hzl oth";
pub fn main() !void {
    try Benchmark.init();

    const input = try getFileSlice("04/input.txt");
    var inputs = mem.split(input, "\n\n");

    Benchmark.read().print("File");
    Benchmark.reset();

    var valid1: usize = 0;
    var valid2: usize = 0;
    inputblk: while (inputs.next()) |pp| {
        var fields = mem.tokenize(pp, " \n");

        var pass = Passport{};

        while (fields.next()) |v| {
            var parts = mem.split(v, ":");

            const name = parts.next().?;
            inline for (std.meta.fields(Passport)) |field| {
                if (mem.eql(u8, field.name, name)) {
                    @field(pass, field.name) = parts.next().?;
                }
            }
        }

        inline for (std.meta.fields(Passport)) |field| {
            if (@field(pass, field.name) == null) {
                continue :inputblk;
            }
        }

        valid1 += 1;

        const byr = std.fmt.parseInt(u32, pass.byr.?, 10) catch continue;
        const iyr = std.fmt.parseInt(u32, pass.iyr.?, 10) catch continue;
        const eyr = std.fmt.parseInt(u32, pass.eyr.?, 10) catch continue;

        const hgt = std.fmt.parseInt(u32, pass.hgt.?[0 .. pass.hgt.?.len - 2], 10) catch continue;
        _ = std.fmt.parseInt(u32, pass.hcl.?[1..], 16) catch continue;
        _ = std.fmt.parseInt(u32, pass.pid.?, 10) catch continue;

        const hgt_suffix = pass.hgt.?[pass.hgt.?.len - 2 ..];
        const hcl_prefix = pass.hcl.?[0];

        const check_birth = byr >= 1920 and byr <= 2002;
        const check_issue = iyr >= 2010 and iyr <= 2020;
        const check_expire = eyr >= 2020 and eyr <= 2030;
        const check_height = (std.mem.eql(u8, hgt_suffix, "cm") and hgt >= 150 and hgt <= 193) or
            (std.mem.eql(u8, hgt_suffix, "in") and hgt >= 59 and hgt <= 76);
        const check_haircolor = hcl_prefix == '#';
        const check_eyecolor = std.mem.indexOf(u8, colors, pass.ecl.?) != null;
        const check_id = pass.pid.?.len == 9;

        if (check_birth and check_issue and check_expire and check_height and check_haircolor and check_eyecolor and check_id)
            valid2 += 1;
    }

    Benchmark.read().print("Part 1 & 2");
    Benchmark.reset();

    std.debug.print("P1: {}\n", .{valid1});
    std.debug.print("P2: {}\n", .{valid2});
}
