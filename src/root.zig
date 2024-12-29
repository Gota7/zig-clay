pub const C = @cImport(@cInclude("clay.h"));
const renderer_options = @import("renderer_options");
const std = @import("std");

pub const RendererRaylib = if (renderer_options.raylib) @import("renderer_raylib.zig") else void;

pub fn layout(config: LayoutConfig) ChildConfigOption {
    return .{ .layout = config };
}

pub fn rectangle(config: RectangleElementConfig) ChildConfigOption {
    return .{ .rectangle = config };
}

pub fn image(config: ImageElementConfig) ChildConfigOption {
    return .{ .image = config };
}

pub fn floating(config: FloatingElementConfig) ChildConfigOption {
    return .{ .floating = config };
}

pub fn customElement(config: CustomElementConfig) ChildConfigOption {
    return .{ .custom_element = config };
}

pub fn scroll(config: ScrollElementConfig) ChildConfigOption {
    return .{ .scroll = config };
}

pub fn border(config: BorderElementConfig) ChildConfigOption {
    return .{ .border = config };
}

pub fn borderOutside(config: Border) ChildConfigOption {
    return .{
        .border = .{
            .left = config,
            .right = config,
            .top = config,
            .bottom = config,
        },
    };
}

pub fn borderOutsideRadius(width: u32, color: Color, radius: f32) ChildConfigOption {
    return .{
        .border = .{
            .left = .{ .width = width, .color = color },
            .right = .{ .width = width, .color = color },
            .top = .{ .width = width, .color = color },
            .bottom = .{ .width = width, .color = color },
            .corder_radius = cornerRadius(radius),
        },
    };
}

pub fn borderAll(config: Border) ChildConfigOption {
    return .{
        .border = .{
            .left = config,
            .right = config,
            .top = config,
            .bottom = config,
            .between_children = config,
        },
    };
}

pub fn borderAllBetweenChildren(width: u32, color: Color, radius: f32) ChildConfigOption {
    return .{
        .border = .{
            .left = .{ .width = width, .color = color },
            .right = .{ .width = width, .color = color },
            .top = .{ .width = width, .color = color },
            .bottom = .{ .width = width, .color = color },
            .between_children = .{ .width = width, .color = color },
            .corder_radius = cornerRadius(radius),
        },
    };
}

pub fn cornerRadius(radius: f32) CornerRadius {
    return .{
        .top_left = radius,
        .top_right = radius,
        .bottom_left = radius,
        .bottom_right = radius,
    };
}

pub fn sizingFit(fit: SizingMinMax) SizingAxis {
    return .{ .fit = fit };
}

pub fn sizingGrow(grow: SizingMinMax) SizingAxis {
    return .{ .grow = grow };
}

pub fn sizingFixed(fixed: SizingMinMax) SizingAxis {
    return .{ .fixed = fixed };
}

pub fn sizingPercent(percent: f32) SizingAxis {
    return .{ .percent = percent };
}

pub fn id(label: []const u8) ChildConfigOption {
    return .{ .id = label };
}

pub fn idi(label: []const u8, index: u32) ChildConfigOption {
    return .{ .idi = .{ label, index } };
}

// TODO!!!

// pub fn idLocal(label: []const u8) ChildConfigOption {
//     return .{ .id_local = label };
// }

// pub fn idiLocal(label: []const u8, index: usize) ChildConfigOption {
//     return .{ .idi_local = .{ label, index } };
// }

pub fn text(text_data: []const u8, config: TextElementConfig) void {
    C.Clay__OpenTextElement(
        .{ .chars = text_data.ptr, .length = @intCast(text_data.len) },
        C.Clay__StoreTextElementConfig(.{
            .fontId = config.font_id,
            .fontSize = config.font_size,
            .letterSpacing = config.letter_spacing,
            .lineHeight = config.line_height,
            .textColor = config.text_color,
            .wrapMode = @intCast(@intFromEnum(config.wrap_mode)),
        }),
    );
}

pub const Child = struct {
    pub fn end(self: Child) void {
        _ = self;
        C.Clay__CloseElement();
    }
};

pub const ChildConfigOption = union(enum) {
    layout: LayoutConfig,
    rectangle: RectangleElementConfig,
    image: ImageElementConfig,
    floating: FloatingElementConfig,
    custom_element: CustomElementConfig,
    scroll: ScrollElementConfig,
    border: BorderElementConfig,
    id: []const u8,
    idi: struct { []const u8, u32 },
};

fn handleChildElement(opt: ChildConfigOption) void {
    switch (opt) {
        .layout => |config| {
            C.Clay__AttachLayoutConfig(
                C.Clay__StoreLayoutConfig(.{
                    .childAlignment = .{ .x = @intFromEnum(config.child_alignment.x), .y = @intFromEnum(config.child_alignment.y) },
                    .childGap = config.child_gap,
                    .layoutDirection = @intFromEnum(config.layout_direction),
                    .padding = .{ .x = config.padding.x, .y = config.padding.y },
                    .sizing = .{
                        .width = config.sizing.width.toC(),
                        .height = config.sizing.height.toC(),
                    },
                }),
            );
        },
        .rectangle => |config| {
            C.Clay__AttachElementConfig(
                .{ .rectangleElementConfig = C.Clay__StoreRectangleElementConfig(
                    .{
                        .color = config.color,
                        .cornerRadius = config.corner_radius.toC(),
                    },
                ) },
                C.CLAY__ELEMENT_CONFIG_TYPE_RECTANGLE,
            );
        },
        .image => |config| {
            C.Clay__AttachElementConfig(
                .{ .imageElementConfig = C.Clay__StoreImageElementConfig(
                    .{
                        .imageData = config.image_data,
                        .sourceDimensions = config.source_dimensions,
                    },
                ) },
                C.CLAY__ELEMENT_CONFIG_TYPE_IMAGE,
            );
        },
        .floating => |config| {
            C.Clay__AttachElementConfig(
                .{ .floatingElementConfig = C.Clay__StoreFloatingElementConfig(
                    config.toC(),
                ) },
                C.CLAY__ELEMENT_CONFIG_TYPE_FLOATING_CONTAINER,
            );
        },
        .custom_element => |config| {
            C.Clay__AttachElementConfig(
                .{ .customElementConfig = C.Clay__StoreCustomElementConfig(
                    .{
                        .customData = config.custom_data,
                    },
                ) },
                C.CLAY__ELEMENT_CONFIG_TYPE_FLOATING_CONTAINER,
            );
        },
        .scroll => |config| {
            C.Clay__AttachElementConfig(
                .{
                    .scrollElementConfig = C.Clay__StoreScrollElementConfig(.{
                        .horizontal = config.horizontal,
                        .vertical = config.vertical,
                    }),
                },
                C.CLAY__ELEMENT_CONFIG_TYPE_SCROLL_CONTAINER,
            );
        },
        .border => |config| {
            C.Clay__AttachElementConfig(
                .{
                    .borderElementConfig = C.Clay__StoreBorderElementConfig(.{
                        .betweenChildren = config.between_children.toC(),
                        .bottom = config.bottom.toC(),
                        .cornerRadius = config.corner_radius.toC(),
                        .left = config.left.toC(),
                        .right = config.right.toC(),
                        .top = config.top.toC(),
                    }),
                },
                C.CLAY__ELEMENT_CONFIG_TYPE_SCROLL_CONTAINER,
            );
        },
        .id => |label| {
            C.Clay__AttachId(
                C.Clay__HashString(
                    .{ .chars = label.ptr, .length = @intCast(label.len) },
                    0,
                    0,
                ),
            );
        },
        .idi => |label| {
            C.Clay__AttachId(
                C.Clay__HashString(
                    .{ .chars = label[0].ptr, .length = @intCast(label[0].len) },
                    label[1],
                    0,
                ),
            );
        },
    }
}

pub fn child(options: []const ChildConfigOption) ?Child {
    C.Clay__OpenElement();
    for (options) |opt| {
        handleChildElement(opt);
    }
    C.Clay__ElementPostConfiguration();
    return .{};
}

pub const ChildManualControlFlow = struct {
    pub fn config(self: ChildManualControlFlow, opt: ChildConfigOption) void {
        _ = self;
        handleChildElement(opt);
    }
    pub fn endConfig(self: ChildManualControlFlow) void {
        _ = self;
        C.Clay__ElementPostConfiguration();
    }
    pub fn end(self: ChildManualControlFlow) void {
        _ = self;
        C.Clay__CloseElement();
    }
};

pub fn childManualControlFlow() ?ChildManualControlFlow {
    C.Clay__OpenElement();
    return .{};
}

pub const Arena = C.Clay_Arena;

pub const Dimensions = C.Clay_Dimensions;
pub const Vector2 = C.Clay_Vector2;
pub const Color = C.Clay_Color;
pub const BoundingBox = C.Clay_BoundingBox;
pub const ElementId = struct {
    id: u32,
    offset: u32,
    base_id: u32,
    string_id: ?[]const u8,

    fn fromC(element_id: C.Clay_ElementId) ElementId {
        return .{
            .id = element_id.id,
            .offset = element_id.offset,
            .base_id = element_id.baseId,
            .string_id = if (element_id.stringId.chars != null) element_id.stringId.chars[0..@intCast(element_id.stringId.length)] else null,
        };
    }

    fn toC(self: ElementId) C.Clay_ElementId {
        return .{
            .id = self.id,
            .offset = self.offset,
            .baseId = self.base_id,
            .stringId = if (self.string_id) |str| .{ .chars = str.ptr, .length = @intCast(str.len) } else .{ .chars = null, .length = 0 },
        };
    }
};
pub const CornerRadius = struct {
    top_left: f32,
    top_right: f32,
    bottom_left: f32,
    bottom_right: f32,

    fn fromC(rad: C.Clay_CornerRadius) CornerRadius {
        return .{
            .top_left = rad.topLeft,
            .top_right = rad.topRight,
            .bottom_left = rad.bottomLeft,
            .bottom_right = rad.bottomRight,
        };
    }

    fn toC(self: CornerRadius) C.Clay_CornerRadius {
        return .{
            .topLeft = self.top_left,
            .topRight = self.top_right,
            .bottomLeft = self.bottom_left,
            .bottomRight = self.bottom_right,
        };
    }
};
pub const ElementConfigType = packed struct(u8) {
    rectangle: bool,
    border_container: bool,
    floating_container: bool,
    scroll_container: bool,
    image: bool,
    text: bool,
    custom: bool,
};
pub const LayoutDirection = enum(u8) {
    left_to_right = C.CLAY_LEFT_TO_RIGHT,
    top_to_bottom = C.CLAY_TOP_TO_BOTTOM,
};
pub const LayoutAlignmentX = enum(u8) {
    left = C.CLAY_ALIGN_X_LEFT,
    right = C.CLAY_ALIGN_X_RIGHT,
    center = C.CLAY_ALIGN_X_CENTER,
};
pub const LayoutAlignmentY = enum(u8) {
    top = C.CLAY_ALIGN_Y_TOP,
    bottom = C.CLAY_ALIGN_Y_BOTTOM,
    center = C.CLAY_ALIGN_Y_CENTER,
};
pub const SizingType = enum(u8) {
    fit = C.CLAY__SIZING_TYPE_FIT,
    grow = C.CLAY__SIZING_TYPE_GROW,
    percent = C.CLAY__SIZING_TYPE_PERCENT,
    fixed = C.CLAY__SIZING_TYPE_FIXED,
};
pub const ChildAlignment = struct {
    x: LayoutAlignmentX = .left,
    y: LayoutAlignmentY = .top,
};
pub const SizingMinMax = struct {
    min: f32 = 0,
    max: f32 = std.math.floatMax(f32),

    fn toC(self: SizingMinMax) C.Clay_SizingMinMax {
        return .{
            .min = self.min,
            .max = self.max,
        };
    }
};

pub const SizingAxis = union(SizingType) {
    fit: SizingMinMax,
    grow: SizingMinMax,
    percent: f32,
    fixed: SizingMinMax,

    fn toC(self: SizingAxis) C.Clay_SizingAxis {
        return switch (self) {
            .fit => |fit| .{ .type = C.CLAY__SIZING_TYPE_FIT, .size = .{ .minMax = fit.toC() } },
            .grow => |grow| .{ .type = C.CLAY__SIZING_TYPE_GROW, .size = .{ .minMax = grow.toC() } },
            .percent => |percent| .{ .type = C.CLAY__SIZING_TYPE_PERCENT, .size = .{ .percent = percent } },
            .fixed => |fixed| .{ .type = C.CLAY__SIZING_TYPE_FIXED, .size = .{ .minMax = fixed.toC() } },
        };
    }
};

pub const Sizing = struct {
    width: SizingAxis = .{ .fit = .{ .min = 0, .max = std.math.floatMax(f32) } },
    height: SizingAxis = .{ .fit = .{ .min = 0, .max = std.math.floatMax(f32) } },
};

pub const Padding = C.Clay_Padding;

pub const LayoutConfig = struct {
    sizing: Sizing = .{},
    padding: Padding = .{ .x = 0, .y = 0 },
    child_gap: u16 = 0,
    child_alignment: ChildAlignment = .{ .x = .left, .y = .top },
    layout_direction: LayoutDirection = .left_to_right,
};

// pub fn layoutDefault() *LayoutConfig {
//     return &C.Clay_LayoutConfig;
// }

pub const RectangleElementConfig = struct {
    color: Color = .{ .r = 0, .g = 0, .b = 0, .a = 0 },
    corner_radius: CornerRadius = cornerRadius(0),
    // TODO: CONFIG EXTENSIONS!!!
};

pub const TextElementConfigWrapMode = enum(c_int) {
    words = C.CLAY_TEXT_WRAP_WORDS,
    newlines = C.CLAY_TEXT_WRAP_NEWLINES,
    none = C.CLAY_TEXT_WRAP_NONE,
};

pub const TextElementConfig = struct {
    text_color: Color = .{ .r = 0, .g = 0, .b = 0, .a = 0 },
    font_id: u16 = 0,
    font_size: u16 = 0,
    letter_spacing: u16 = 0,
    line_height: u16 = 0,
    wrap_mode: TextElementConfigWrapMode = .words,

    fn fromC(config: C.Clay_TextElementConfig) TextElementConfig {
        return .{
            .text_color = config.textColor,
            .font_id = config.fontId,
            .font_size = config.fontSize,
            .letter_spacing = config.letterSpacing,
            .line_height = config.lineHeight,
            .wrap_mode = @enumFromInt(config.wrapMode),
        };
    }
};

pub const ImageElementConfig = struct {
    image_data: *anyopaque,
    source_dimensions: Dimensions = .{ .width = 0, .height = 0 },
};

pub const FloatingAttachPointType = enum(u8) {
    left_top = C.CLAY_ATTACH_POINT_LEFT_TOP,
    left_center = C.CLAY_ATTACH_POINT_LEFT_CENTER,
    left_bottom = C.CLAY_ATTACH_POINT_LEFT_BOTTOM,
    center_top = C.CLAY_ATTACH_POINT_CENTER_TOP,
    center_center = C.CLAY_ATTACH_POINT_CENTER_CENTER,
    center_bottom = C.CLAY_ATTACH_POINT_CENTER_BOTTOM,
    right_top = C.CLAY_ATTACH_POINT_RIGHT_TOP,
    right_center = C.CLAY_ATTACH_POINT_RIGHT_CENTER,
    right_bottom = C.CLAY_ATTACH_POINT_RIGHT_BOTTOM,
};

pub const FloatingAttachPoints = struct {
    element: FloatingAttachPointType = .left_top,
    parent: FloatingAttachPointType = .left_top,
};

pub const PointerCaptureMode = enum(c_int) {
    capture = C.CLAY_POINTER_CAPTURE_MODE_CAPTURE,
    passthrough = C.CLAY_POINTER_CAPTURE_MODE_PASSTHROUGH,
};

pub const FloatingElementConfig = struct {
    offset: Vector2 = .{ .x = 0, .y = 0 },
    expand: Dimensions = .{ .width = 0, .height = 0 },
    z_index: u16 = 0,
    parent_id: u32 = 0,
    attachment: FloatingAttachPoints = .{},
    pointer_capture_mode: PointerCaptureMode = .capture,

    fn toC(self: FloatingElementConfig) C.Clay_FloatingElementConfig {
        return C.Clay_FloatingElementConfig{
            .offset = self.offset,
            .expand = self.expand,
            .zIndex = self.z_index,
            .parentId = self.parent_id,
            .attachment = .{ .element = @intFromEnum(self.attachment.element), .parent = @intFromEnum(self.attachment.parent) },
            .pointerCaptureMode = @intCast(@intFromEnum(self.pointer_capture_mode)),
        };
    }
};

pub const CustomElementConfig = struct {
    custom_data: ?*anyopaque = null,
};

pub const ScrollElementConfig = struct {
    horizontal: bool = false,
    vertical: bool = false,
};

pub const Border = struct {
    width: u32 = 0,
    color: Color = .{ .r = 0, .g = 0, .b = 0, .a = 0 },

    fn fromC(other: C.Clay_Border) Border {
        return .{
            .width = other.width,
            .color = other.color,
        };
    }

    fn toC(self: Border) C.Clay_Border {
        return .{
            .width = self.width,
            .color = self.color,
        };
    }
};

pub const BorderElementConfig = struct {
    left: Border = .{},
    right: Border = .{},
    top: Border = .{},
    bottom: Border = .{},
    between_children: Border = .{},
    corner_radius: CornerRadius = cornerRadius(0),
};

pub const RenderCommandConfig = union(RenderCommandType) {
    none: void,
    rectangle: RectangleElementConfig,
    border: BorderElementConfig,
    text: TextElementConfig,
    image: ImageElementConfig,
    scissor_start: void,
    scissor_end: void,
    custom: CustomElementConfig,

    fn fromC(com: C.Clay_RenderCommand) RenderCommandConfig {
        return switch (com.commandType) {
            C.CLAY_RENDER_COMMAND_TYPE_NONE => .{ .none = {} },
            C.CLAY_RENDER_COMMAND_TYPE_RECTANGLE => .{ .rectangle = .{
                .color = com.config.rectangleElementConfig.*.color,
                .corner_radius = CornerRadius.fromC(com.config.rectangleElementConfig.*.cornerRadius),
            } },
            C.CLAY_RENDER_COMMAND_TYPE_BORDER => .{
                .border = BorderElementConfig{
                    .between_children = Border.fromC(com.config.borderElementConfig.*.betweenChildren),
                    .left = Border.fromC(com.config.borderElementConfig.*.betweenChildren),
                    .right = Border.fromC(com.config.borderElementConfig.*.betweenChildren),
                    .top = Border.fromC(com.config.borderElementConfig.*.betweenChildren),
                    .bottom = Border.fromC(com.config.borderElementConfig.*.betweenChildren),
                    .corner_radius = CornerRadius.fromC(com.config.borderElementConfig.*.cornerRadius),
                },
            },
            C.CLAY_RENDER_COMMAND_TYPE_TEXT => .{
                .text = TextElementConfig.fromC(com.config.textElementConfig.*),
            },
            C.CLAY_RENDER_COMMAND_TYPE_IMAGE => .{ .image = .{
                .image_data = com.config.imageElementConfig.*.imageData.?,
                .source_dimensions = com.config.imageElementConfig.*.sourceDimensions,
            } },
            C.CLAY_RENDER_COMMAND_TYPE_SCISSOR_START => .{ .scissor_start = {} },
            C.CLAY_RENDER_COMMAND_TYPE_SCISSOR_END => .{ .scissor_end = {} },
            C.CLAY_RENDER_COMMAND_TYPE_CUSTOM => .{ .custom = .{
                .custom_data = com.config.customElementConfig.*.customData,
            } },
            else => .{ .none = {} },
        };
    }
};

pub const ScrollContainerData = struct {
    scroll_position: *Vector2,
    scroll_container_dimensions: Dimensions,
    content_dimensions: Dimensions,
    config: ScrollElementConfig,
    found: bool,
};

pub const RenderCommandType = enum(c_int) {
    none = C.CLAY_RENDER_COMMAND_TYPE_NONE,
    rectangle = C.CLAY_RENDER_COMMAND_TYPE_RECTANGLE,
    border = C.CLAY_RENDER_COMMAND_TYPE_BORDER,
    text = C.CLAY_RENDER_COMMAND_TYPE_TEXT,
    image = C.CLAY_RENDER_COMMAND_TYPE_IMAGE,
    scissor_start = C.CLAY_RENDER_COMMAND_TYPE_SCISSOR_START,
    scissor_end = C.CLAY_RENDER_COMMAND_TYPE_SCISSOR_END,
    custom = C.CLAY_RENDER_COMMAND_TYPE_CUSTOM,
};

pub const RenderCommand = struct {
    bounding_box: BoundingBox,
    config: RenderCommandConfig,
    text: ?[]const u8,
    id: u32,
};

pub const RenderCommandArray = struct {
    arr: C.Clay_RenderCommandArray,

    pub fn iter(self: *RenderCommandArray) RenderCommandIterator {
        return .{
            .arr = &self.arr,
        };
    }

    pub const RenderCommandIterator = struct {
        arr: *C.Clay_RenderCommandArray,
        index: i32 = 0,
        pub fn next(self: *RenderCommandIterator) ?RenderCommand {
            if (self.index < @as(usize, @intCast(self.arr.length))) {
                const com = C.Clay_RenderCommandArray_Get(self.arr, self.index).*;
                const ret: RenderCommand = .{
                    .bounding_box = com.boundingBox,
                    .config = RenderCommandConfig.fromC(com),
                    .id = com.id,
                    .text = if (com.text.chars) |chars| chars[0..@intCast(com.text.length)] else null,
                };
                self.index += 1;
                return ret;
            }
            return null;
        }
    };
};

pub const PointerDataInteractionState = enum(c_int) {
    pressed_this_frame = C.CLAY_POINTER_DATA_PRESSED_THIS_FRAME,
    pressed = C.CLAY_POINTER_DATA_PRESSED,
    released_this_frame = C.CLAY_POINTER_DATA_RELEASED_THIS_FRAME,
    release = C.CLAY_POINTER_DATA_RELEASED,
};

pub const PointerData = struct {
    position: Vector2,
    state: PointerDataInteractionState,
};

pub const ErrorType = enum(c_int) {
    text_measurement_function_not_provided = C.CLAY_ERROR_TYPE_TEXT_MEASUREMENT_FUNCTION_NOT_PROVIDED,
    arena_capacity_exceeded = C.CLAY_ERROR_TYPE_ARENA_CAPACITY_EXCEEDED,
    elements_capacity_exceeded = C.CLAY_ERROR_TYPE_ELEMENTS_CAPACITY_EXCEEDED,
    text_measurement_capacity_exceeded = C.CLAY_ERROR_TYPE_TEXT_MEASUREMENT_CAPACITY_EXCEEDED,
    duplicate_id = C.CLAY_ERROR_TYPE_DUPLICATE_ID,
    floating_container_parent_not_found = C.CLAY_ERROR_TYPE_FLOATING_CONTAINER_PARENT_NOT_FOUND,
    internal_error = C.CLAY_ERROR_TYPE_INTERNAL_ERROR,
};

pub fn ErrorData(comptime UserData: type) type {
    return struct {
        error_type: ErrorType,
        error_text: []const u8,
        user_data: *UserData,
    };
}

pub fn ErrorHandler(comptime UserData: type) type {
    return struct {
        handler_function: *const fn (error_text: ErrorData(UserData)) void,
        user_data: *UserData,
    };
}

const HandlerCtx = struct {
    func: ?*const anyopaque,
    data: ?*anyopaque,
};

const HandlerCtxConst = struct {
    func: ?*const anyopaque,
    data: ?*const anyopaque,
};

var error_handler_ctx: HandlerCtx = .{
    .func = null,
    .data = null,
};

fn errorHandlerFn(error_text: C.Clay_ErrorData) callconv(.C) void {
    const ctx: *HandlerCtx = @ptrFromInt(error_text.userData);
    const func: *const fn (error_text: ErrorData(anyopaque)) void = @ptrCast(ctx.func.?);
    func(.{
        .error_text = error_text.errorText.chars[0..@intCast(error_text.errorText.length)],
        .error_type = @enumFromInt(error_text.errorType),
        .user_data = ctx.data.?,
    });
}

/// Returns the minimum amount of memory in bytes that clay needs to accomodate the current max element count.
pub fn minMemorySize() u32 {
    return C.Clay_MinMemorySize();
}

/// Creates an `Arena` struct with the given memory slice which can be passed to `initialize()`.
/// * `buffer` - Block of memory to use as an arena.
pub fn createArenaWithCapacityAndMemory(buffer: []u8) Arena {
    return C.Clay_CreateArenaWithCapacityAndMemory(@intCast(buffer.len), buffer.ptr);
}

/// Sets the internal pointer position and state (i.e. current mouse / touch position) and recalculates overlap info,
/// which is used for mouseover / click calculation (via `pointerOver()` and updating scroll containers with `updateScrollContainers()`).
/// * `position` - Mouse position relative to the root UI.
/// * `pointer_down` - Current state this frame (true as long as the left mouse button is held down).
pub fn setPointerState(position: Vector2, pointer_down: bool) void {
    C.Clay_SetPointerState(position, pointer_down);
}

/// Initializes the internal memory mapping, sets the internal dimensions for the layout, and binds an error handler for clay to use when something goes wrong.
/// * `arena` - Arena to use created with `createArenaWithCapacityAndMemory()`.
/// * `layout_dimensions` - Size of the root layout.
/// * `ErrorHandlerUserData` - Type of user data to be used for the error handler.
/// * `error_handler` - Called whenever clay encounters an error.
pub fn initialize(arena: Arena, layout_dimensions: Dimensions, comptime ErrorHandlerUserData: type, error_handler: ErrorHandler(ErrorHandlerUserData)) void {
    error_handler_ctx.func = error_handler.handler_function;
    error_handler_ctx.data = error_handler.user_data;
    C.Clay_Initialize(arena, layout_dimensions, .{
        .errorHandlerFunction = errorHandlerFn,
        .userData = @intFromPtr(&error_handler_ctx),
    });
}

/// This function handles scrolling of containers.
/// * `enable_drag_scrolling` - If to allow touch/drag scrolling utilizing the pointer position (will only work if `setPointerState()` was also called).
/// * `scroll_delta` - Mouse wheel or trackpad scrolling this frame.
/// * `delta_time` - Time in seconds since the last frame to normalize and smooth scrolling across different refresh rates.
pub fn updateScrollContainers(enable_drag_scrolling: bool, scroll_delta: Vector2, delta_time: f32) void {
    C.Clay_UpdateScrollContainers(enable_drag_scrolling, scroll_delta, delta_time);
}

/// Sets the internal layout dimensions.
/// Cheap enough to be called every frame with your screen dimensions to automatically respond to window resizing, etc.
///
/// * `dimensions` - New size of the root layout.
pub fn setLayoutDimensions(dimensions: Dimensions) void {
    C.Clay_SetLayoutDimensions(dimensions);
}

/// Layout structure created from `beginLayout()`.
/// Has an `end()` function to call to get the render commands.
const Layout = struct {
    /// Ends declaration of elements and calculates the results of the current layout.
    /// Renders a `RenderCommandArray` containing the results of the layout calculation.
    pub fn end(self: Layout) RenderCommandArray {
        _ = self;
        return .{
            .arr = C.Clay_EndLayout(),
        };
    }
};

/// Prepares clay to calculate a new layout.
/// Called each frrame before any of the elements.
pub fn beginLayout() Layout {
    C.Clay_BeginLayout();
    return .{};
}

pub fn getElementId(id_string: []const u8) ElementId {
    return ElementId.fromC(C.Clay_GetElementId(.{ .chars = id_string.ptr, .length = @intCast(id_string.len) }));
}

pub fn getElementIdWithIndex(id_string: []const u8, index: u32) ElementId {
    return ElementId.fromC(C.Clay_GetElementIdWithIndex(.{ .chars = id_string.ptr, .length = @intCast(id_string.len) }, index));
}

pub fn hovered() bool {
    return C.Clay_Hovered();
}

var on_hover_cb: ?*const anyopaque = null;

fn onHoverCb(element_id: C.Clay_ElementId, pointer_data: C.Clay_PointerData, user_data: isize) callconv(.C) void {
    const func: *const fn (element_id: ElementId, pointer_data: PointerData, user_data: ?*anyopaque) void = @ptrCast(on_hover_cb.?);
    func(ElementId.fromC(element_id), .{ .position = pointer_data.position, .state = @enumFromInt(pointer_data.state) }, @ptrFromInt(@as(usize, @intCast(user_data))));
}

pub fn onHover(on_hover_function: *const fn (element_id: ElementId, pointer_data: PointerData, user_data: ?*anyopaque) void, user_data: ?*anyopaque) void {
    on_hover_cb = on_hover_function;
    C.Clay_OnHover(onHoverCb, @intCast(@intFromPtr(user_data)));
}

pub fn pointerOver(element_id: ElementId) bool {
    return C.Clay_PointerOver(element_id.toC());
}

pub fn getScrollContainerData(element_id: ElementId) ScrollContainerData {
    const ret = C.Clay_GetScrollContainerData(element_id.toC());
    return .{
        .config = .{ .horizontal = ret.config.horizontal, .vertical = ret.config.vertical },
        .content_dimensions = ret.contentDimensions,
        .found = ret.found,
        .scroll_container_dimensions = ret.scrollContainerDimensions,
        .scroll_position = ret.scrollPosition,
    };
}

var measure_text_function_cb: ?*const fn (text: []const u8, config: TextElementConfig) Dimensions = null;

fn setMeasureTextFunction_cb(text_data: [*c]C.Clay_String, config: [*c]C.Clay_TextElementConfig) callconv(.C) Dimensions {
    if (measure_text_function_cb) |cb| {
        return cb(text_data.*.chars[0..@intCast(text_data.*.length)], TextElementConfig.fromC(config.*));
    }
    return .{ .width = 0, .height = 0 };
}

/// Takes a function pointer that can be used to measure the width and height of a string.
/// Used by clay layout to determine `text` element sizing and wrapping.
///
/// The string is not guaranteed to be null terminated.
///
/// It is essential that this function is as fast as possible.
/// * `measure_text_function` - Function pointer to measure given text utilizing its text characters and config.
pub fn setMeasureTextFunction(measure_text_function: *const fn (text: []const u8, config: TextElementConfig) Dimensions) void {
    measure_text_function_cb = measure_text_function;
    C.Clay_SetMeasureTextFunction(setMeasureTextFunction_cb);
}

var set_query_scroll_offset_function_cb: ?*const fn (element_id: u32) Vector2 = null;

fn setQueryScrollOffsetFunction_cb(element_id: u32) callconv(.C) Vector2 {
    if (set_query_scroll_offset_function_cb) |cb| {
        return cb(element_id);
    }
    return .{ .x = 0, .y = 0 };
}

pub fn setQueryScrollOffsetFunction(query_scroll_offset_function: *const fn (element_id: u32) Vector2) void {
    set_query_scroll_offset_function_cb = query_scroll_offset_function;
    C.Clay_SetQueryScrollOffsetFunction(setQueryScrollOffsetFunction_cb);
}

pub fn setDebugModeEnabled(enabled: bool) void {
    C.Clay_SetDebugModeEnabled(enabled);
}

pub fn setCullingEnabled(enabled: bool) void {
    C.Clay_SetCullingEnabled(enabled);
}

/// Updates the internal maximum element count, allowing clay to allocate larger UI hierarchies.
///
/// Clay will need to be re-initialized. Re-check the value of `minMemorySize()`.
/// * `max_element_count` - New maximum number of elements.
pub fn setMaxElementCount(max_element_count: u32) void {
    C.Clay_SetMaxElementCount(max_element_count);
}

/// Updates the internal text measurement cache size, allowing clay to allocate more text.
///
/// Clay will need to be re-initialized. Re-check the value of `minMemorySize()`.
/// * `max_measurement_text_cache_word_count` - How many separate words can be stored in the text measurement cache.
pub fn setMaxMeasureTextCacheWordCount(max_measure_text_cache_word_count: u32) void {
    C.Clay_SetMaxMeasureTextCacheWordCount(max_measure_text_cache_word_count);
}

pub fn debugViewHighlightColor() *Color {
    return &C.Clay__debugViewHighlightColor;
}

pub fn debugViewWidth() *u32 {
    return &C.Clay__debugViewWidth;
}
