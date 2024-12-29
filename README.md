# zig-clay

Tweaked bindings for the [clay](https://github.com/nicbarker/clay) C UI library.

## Features

* Zig 0.13.0 compatibility.
* Naming conventions follow zig standards.
* Callbacks are more zig-like.
* Config structures have default initializations.
* Code is very similar to how it looks in C.

## Usage

The main difference between this and the C API is the lack of macros.
To get around this, a different approach was taken to emulate the feel of the C API:

```zig
const layout = clay.beginLayout();
if (clay.child(&[_]clay.ChildConfigOption{
    clay.id("OuterContainer"),
    clay.rectangle(.{ .color = .{ .r = 43, .g = 41, .b = 51, .a = 255 } }),
    clay.layout(.{
        .layout_direction = .top_to_bottom,
        .sizing = .{
            .width = clay.sizingGrow(.{}),
            .height = clay.sizingGrow(.{}),
        },
        .padding = .{ .x = 16, .y = 16 },
        .child_gap = 16,
    }),

    // More config here.
})) |outer_container| {
    defer outer_container.end();
    clay.text("Hello World!", .{
        .font_id = 0,
        .font_size = 24,
        .text_color = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
    });

    // More child elements here.
}

// ...

const commands = layout.end();
```

C version for comparison:
```c
Clay_BeginLayout();
CLAY(
    CLAY_ID("OuterContainer"),
    CLAY_RECTANGLE({ .color = { 43, 41, 51, 255 } }),
    CLAY_LAYOUT({
        .layoutDirection = CLAY_TOP_TO_BOTTOM,
        .sizing = { .width = CLAY_SIZING_GROW(), .height = CLAY_SIZING_GROW() },
        .padding = { 16, 16 },
        .childGap = 16
    })

    // More config here.
) {
    CLAY_TEXT("Hello World!", CLAY_TEXT_CONFIG({
        .fontId = 0,
        .fontSize = 24,
        .textColor = { 255, 255, 255, 255 }
    }));

    // More child elements here.
}

// ...

Clay_RenderCommandArray renderCommands = Clay_EndLayout();
```

While not as frequent, sometimes control flow is required during element configuration.
In this scenario, manual configuration should be done:

```zig
if (clay.childManualControlFlow()) |sidebar_button| {
    defer sidebar_button.end();

    sidebar_button.config(clay.layout(sidebar_button_layout));
    clay.onHover(handle_sidebar_interaction, @ptrFromInt(i));
    if (clay.hovered())
        sidebar_button.config(clay.rectangle(.{
            .color = .{ .r = 120, .g = 120, .b = 120, .a = 255 },
            .corner_radius = clay.cornerRadius(8),
        }));

    // More config here.

    sidebar_button.endConfig();

    // Children.
    clay.text(document.title, .{
        .font_id = font_id_body_16,
        .font_size = 20,
        .text_color = color_white,
    });

    // More child elements here.
}
```

In this scenario, care should be taken that the order is:

1. Call `childManualControlFlow()`
2. Config (calls to `.config()`)
3. Call `.endConfig()`
4. Child elements
5. Call `.end()`

## Getting Started

The `example` folder has an example of a working project.
Other than the syntatical differences seen above, usage of the zig API should be fairly 1-to-1 with the C library.
