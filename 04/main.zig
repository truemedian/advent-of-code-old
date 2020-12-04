const std = @import("std");
usingnamespace @import("utils");

const colors = "amb blu brn gry grn hzl oth";
pub fn main() !void {
    const input = try getFileSlice("04/input.txt");
    const inputs = try splitOne(input, "\n\n");

    var valid1: usize = 0;
    var valid2: usize = 0;
    for (inputs) |pp| {
        const fields = try splitAny(pp, " \n");

        var map = std.StringHashMap([]const u8).init(allocator);

        for (fields) |v| {
            const parts = try splitOne(v, ":");

            try map.put(parts[0], parts[1]);
        }

        if (map.contains("byr") and map.contains("iyr") and map.contains("eyr") and map.contains("hgt") and map.contains("hcl") and map.contains("ecl") and map.contains("pid")) {
            valid1 += 1;

            const byr = std.fmt.parseInt(usize, map.get("byr").?, 10) catch continue;
            const iyr = std.fmt.parseInt(usize, map.get("iyr").?, 10) catch continue;
            const eyr = std.fmt.parseInt(usize, map.get("eyr").?, 10) catch continue;
            const hgt = map.get("hgt").?;
            const hcl = map.get("hcl").?;
            const ecl = map.get("ecl").?;
            const pid = map.get("pid").?;

            const hgt_num = std.fmt.parseInt(usize, hgt[0 .. hgt.len - 2], 10) catch continue;
            const hcl_num = std.fmt.parseInt(usize, hcl[1..], 16) catch continue;
            const pid_num = std.fmt.parseInt(usize, pid, 10) catch continue;

            const hgt_suffix = hgt[hgt.len - 2 ..];
            const hcl_prefix = hcl[0];

            const check_birth = byr >= 1920 and byr <= 2002;
            const check_issue = iyr >= 2010 and iyr <= 2020;
            const check_expire = eyr >= 2020 and eyr <= 2030;
            const check_height = (std.mem.eql(u8, hgt_suffix, "cm") and hgt_num >= 150 and hgt_num <= 193) or
                (std.mem.eql(u8, hgt_suffix, "in") and hgt_num >= 59 and hgt_num <= 76);
            const check_haircolor = hcl_prefix == '#';
            const check_eyecolor = std.mem.indexOf(u8, colors, ecl) != null;
            const check_id = pid.len == 9;

            if (check_birth and check_issue and check_expire and check_height and check_haircolor and check_eyecolor and check_id)
                valid2 += 1;
        }
    }

    std.debug.print("{}\n", .{valid1});
    std.debug.print("{}\n", .{valid2});
}
