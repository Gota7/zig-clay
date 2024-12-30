const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Setup clay dependency.
    const clay_dep = b.dependency("clay", .{
        .target = target,
        .optimize = optimize,
    });
    const clay = clay_dep.module("clay");

    const exe = b.addExecutable(.{
        .name = "video-demo-raylib",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Clay dep.
    exe.root_module.addImport("clay", clay);

    // Raylib dep.
    const raylib = b.dependency("raylib-zig", .{
        .target = target,
        .optimize = optimize,
    });
    exe.root_module.addImport("raylib", raylib.module("raylib"));
    const raylib_artifact = raylib.artifact("raylib");
    exe.linkLibrary(raylib_artifact);

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
