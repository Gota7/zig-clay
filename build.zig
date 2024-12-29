const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Clay source header.
    const clay_path = b.dependency("clay_src", .{}).path(".");
    std.debug.print("{s}\n", .{clay_path.getPath(b)});

    const clay = b.addModule("clay", .{ .root_source_file = b.path("src/root.zig") });
    clay.addIncludePath(clay_path);
    clay.addCSourceFile(.{ .file = b.path("clay.c") });
    clay.link_libc = true;
    const renderer_options = b.addOptions();
    const renderer_raylib = b.option(bool, "renderer_raylib", "Enable raylib renderer") orelse false;
    if (renderer_raylib) {
        const raylib = b.dependency("raylib-zig", .{
            .target = target,
            .optimize = optimize,
        });
        clay.addImport("raylib", raylib.module("raylib"));
        const raylib_artifact = raylib.artifact("raylib");
        clay.linkLibrary(raylib_artifact);
    }
    renderer_options.addOption(bool, "raylib", renderer_raylib);
    clay.addOptions("renderer_options", renderer_options);
}
