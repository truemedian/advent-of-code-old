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

    comptime var i = 1;
    inline while (i <= 25) : (i += 1) {
        // The OS frees memory for us when the build runner finishes
        const name = try std.fmt.allocPrint(b.allocator, "d{d:0>2}", .{ i });
        const path = try std.fmt.allocPrint(b.allocator, "{d:0>2}/main.zig", .{ i });
        const desc = try std.fmt.allocPrint(b.allocator, "Build & Run Day {d}", .{ i });

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

        const run_step = b.step(name, desc);
        run_step.dependOn(&run_cmd.step);
    }
}