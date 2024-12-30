const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Clay source header.
    const clay_path = b.dependency("clay_src", .{}).path(".");

    // Add module.
    const clay = b.addModule("clay", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add clay source.
    clay.addIncludePath(clay_path);
    clay.addCSourceFile(.{ .file = b.path("clay.c") });
    clay.link_libc = true;
}
