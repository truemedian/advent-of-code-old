const std = @import("std");

const Pkg = std.build.Pkg;
const Builder = std.build.Builder;

const utils = Pkg {
    .name = "utils",
    .path = "utilities/main.zig",
};

pub fn build(b: *Builder) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    var i: usize = 1;
    while (i <= 25) : (i += 1) {
        const name = try std.fmt.allocPrint(std.heap.page_allocator, "day-{d:0>2}", .{ i });
        const path = try std.fmt.allocPrint(std.heap.page_allocator, "{d:0>2}/main.zig", .{ i });

        const exe = b.addExecutable(name, path);
        exe.setTarget(target);
        exe.setBuildMode(mode);
        exe.install();

        exe.addPackage(utils);

        const run_cmd = exe.run();
        run_cmd.step.dependOn(&exe.install_step.?.step);
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        const run_step = b.step(name, "Run Day");
        run_step.dependOn(&run_cmd.step);
    }
}