pub const C = @cImport(@cInclude("clay.h"));
const std = @import("std");

/// Used for configuring layout options (affect the final position and size of an element, parent, siblings, and children).
/// * `config` - Layout configuration.
pub fn layout(config: LayoutConfig) ChildConfigOption {
    return .{ .layout = config };
}

/// Configures a clay element to background-fill its bounding box with a color.
/// * `config` - Rectangle specific options.
pub fn rectangle(config: RectangleElementConfig) ChildConfigOption {
    return .{ .rectangle = config };
}

/// Configures a clay element to render an image as its background.
/// * `config` - Image specific options.
pub fn image(config: ImageElementConfig) ChildConfigOption {
    return .{ .image = config };
}

/// Define an element that floats above other content. Useful for tooltips and modals.
/// Don't affect the width and height of their parent.
/// Don't affect the positioning of sibling elements.
/// Can appear above or below other elements depending on z-index.
/// Work like other standard child elements.
/// These are easiest to think of as separate UI hierarchies anchored to a point on their parent.
/// * `config` - Floating element specific configuration.
pub fn floating(config: FloatingElementConfig) ChildConfigOption {
    return .{ .floating = config };
}

/// Allows the user to pass custom data to the renderer.
/// * `config` - Custom data configuration.
pub fn customElement(config: CustomElementConfig) ChildConfigOption {
    return .{ .custom_element = config };
}

/// Configures the element as a scrolling container, enabling masking children that extend beyond its boundaries.
/// In order to process scrolling based on pointer position and mouse wheel or touch interactions, you must call `setPointerState()` and `updateScrollContainer()` before calling `beginLayout()`.
/// * `config` - Scroll specific config.
pub fn scroll(config: ScrollElementConfig) ChildConfigOption {
    return .{ .scroll = config };
}

/// Adds borders to the edges or between the children of elements.
/// * `config` - Border specific options.
pub fn border(config: BorderElementConfig) ChildConfigOption {
    return .{ .border = config };
}

/// Shorthand for configuring all 4 outside borders at once.
/// * `config` - Border config.
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

/// Shorthand for configuring all 4 outside borders at once with the provided corner radius.
/// * `width` - Border width for outside borders.
/// * `color` - Color of outside borders.
/// * `radius` - Corner radius of each border.
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

/// Shorthand for configuring all borders at once.
/// * `config` - Border config.
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

/// Shorthand for configuring all borders at once with the provided corner radius.
/// * `width` - Border width for all borders.
/// * `color` - Color of all borders.
/// * `radius` - Corner radius of each border.
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

/// Shorthand to set a corner radius for all corners.
/// * `radius` - Radius to create a corner radius from.
pub fn cornerRadius(radius: f32) CornerRadius {
    return .{
        .top_left = radius,
        .top_right = radius,
        .bottom_left = radius,
        .bottom_right = radius,
    };
}

/// The element will be sized to fit its children (plus padding and gaps), up to `max`.
/// When elements are compressed to fit into a smaller parent, this element will not shrink below `min`.
/// * `fit` - How to fit the element.
pub fn sizingFit(fit: SizingMinMax) SizingAxis {
    return .{ .fit = fit };
}

/// The element will grow to fill available space in its parent, up to `max`.
/// When elements are compressed to fit into a smaller parent, this element will not shrink below `min`.
/// * `grow` - Grow constraints.
pub fn sizingGrow(grow: SizingMinMax) SizingAxis {
    return .{ .grow = grow };
}

/// The final size will always be exactly the provided fixed value.
/// * `fixed` - Shorthand for `sizingFit(fixed, fixed).
pub fn sizingFixed(fixed: f32) SizingAxis {
    return .{ .fixed = .{ .min = fixed, .max = fixed } };
}

/// Final size will be a percentage of the parent size, minus padding and child gaps.
/// * `percent` - Percentage of the parent to fill between `0` and `1`.
pub fn sizingPercent(percent: f32) SizingAxis {
    return .{ .percent = percent };
}

/// Used to generate and attach an `ElementId` to a layout element during declaration.
/// To regenerate the same ID outside of layout declaration when using utility functions such as `pointerOver()`, use the `getElementId()` function.
/// * `label` - ID label to attach to the child.
pub fn id(label: []const u8) ChildConfigOption {
    return .{ .id = label };
}

/// And offset version of `id()`.
/// Generates an `ElementId` that is combined with an index.
/// Great for generating IDs for elements in loops.
/// * `label` - ID label to attach to the child.
/// * `index` - Index of the element to offset the ID with.
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

/// Text is a measured, auto-wrapped text element.
/// Note that fonts are passed around by an ID through clay to be agnostic to the backend.
/// * `text_data` - Text to render.
/// * `config` - Text-specific options.
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

/// A child element context created by `child()`.
pub const Child = struct {
    /// Finish the current child element.
    pub fn end(self: Child) void {
        _ = self;
        C.Clay__CloseElement();
    }
};

/// Represent a child element configuration option.
/// Item is set by using the helper function above with the same name as the item (call `floating` to set this as a floating container).
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

/// Opens a generic empty container that is configurable and supports nested children.
/// Remember to call `.end()` on the resulting child.
/// * `options` - Configuration options. If more control flow is needed, use `childManualControlFlow()`.
pub fn child(options: []const ChildConfigOption) ?Child {
    C.Clay__OpenElement();
    for (options) |opt| {
        handleChildElement(opt);
    }
    C.Clay__ElementPostConfiguration();
    return .{};
}

/// A child element context created with `childManualControlFlow()`.
pub const ChildManualControlFlow = struct {
    /// Add a configuration option to the child.
    /// Must be called before `.endConfig()`.
    /// * `opt` - Configuration option to add to the child element.
    pub fn config(self: ChildManualControlFlow, opt: ChildConfigOption) void {
        _ = self;
        handleChildElement(opt);
    }

    /// End the child configuration.
    /// No more calls to `.config()` are allowed after this.
    pub fn endConfig(self: ChildManualControlFlow) void {
        _ = self;
        C.Clay__ElementPostConfiguration();
    }

    /// End the child element.
    pub fn end(self: ChildManualControlFlow) void {
        _ = self;
        C.Clay__CloseElement();
    }
};

/// Opens a generic empty container that is configurable via control flow and supports nested children.
/// Remember to call `.endConfig()` and then `.end()` on the resulting child.
/// The `.config()` function may be invoked before `.endConfig()` any number of times to add configuration options.
pub fn childManualControlFlow() ?ChildManualControlFlow {
    C.Clay__OpenElement();
    return .{};
}

/// Clay memory arena to use.
pub const Arena = C.Clay_Arena;

/// Width and height dimensions.
pub const Dimensions = C.Clay_Dimensions;

/// X and Y positioning.
pub const Vector2 = C.Clay_Vector2;

/// RGBA color with values typically from 0 to 255.
pub const Color = C.Clay_Color;

/// A bounding box for an element.
pub const BoundingBox = C.Clay_BoundingBox;

/// Contains a hash ID to the element it refers to as well as a source string used to generate it.
pub const ElementId = struct {
    /// Unique identifier create from `id()` or `idi()`.
    id: u32,
    /// If generated with `idi()`, this is the value passed as `index`.
    offset: u32,
    /// If generated with `idi()`, this is the hash of the base string passed before it is additionally hashed with `offset`.
    base_id: u32,
    /// The string that was passed when `id()` or `idi()` was called.
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

/// Radius for corners of a box.
pub const CornerRadius = struct {
    /// Radius of the top left.
    top_left: f32,
    /// Radius of the top right.
    top_right: f32,
    /// Radius of the bottom left.
    bottom_left: f32,
    /// Radius of the bottom right.
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

/// What an element may contain.
pub const ElementConfigType = packed struct(u8) {
    rectangle: bool,
    border_container: bool,
    floating_container: bool,
    scroll_container: bool,
    image: bool,
    text: bool,
    custom: bool,
};

/// Direction of a layout.
pub const LayoutDirection = enum(u8) {
    /// Items go from left to right.
    left_to_right = C.CLAY_LEFT_TO_RIGHT,
    /// Items go from top to bottom.
    top_to_bottom = C.CLAY_TOP_TO_BOTTOM,
};

/// How child elements are aligned in the X direction.
pub const LayoutAlignmentX = enum(u8) {
    /// Left of the parent.
    left = C.CLAY_ALIGN_X_LEFT,
    /// Right of the parent.
    right = C.CLAY_ALIGN_X_RIGHT,
    /// Center of the parent.
    center = C.CLAY_ALIGN_X_CENTER,
};

/// How child elements are aligned in the Y direction.
pub const LayoutAlignmentY = enum(u8) {
    /// Top of the parent.
    top = C.CLAY_ALIGN_Y_TOP,
    /// Bottom of the parent.
    bottom = C.CLAY_ALIGN_Y_BOTTOM,
    /// Center of the parent.
    center = C.CLAY_ALIGN_Y_CENTER,
};

/// How a layout will be sized along an axis.
pub const SizingType = enum(u8) {
    /// Size to fit children with padding and gaps.
    /// Use `sizingFit()`.
    fit = C.CLAY__SIZING_TYPE_FIT,
    /// Size to grow to the size of the parent.
    /// Use `sizingGrow()`.
    grow = C.CLAY__SIZING_TYPE_GROW,
    /// Size to fill a percentage of the parent.
    /// Use `sizingPercent()`.
    percent = C.CLAY__SIZING_TYPE_PERCENT,
    /// Set to a fixed size.
    /// Use `sizingFixed()`.
    fixed = C.CLAY__SIZING_TYPE_FIXED,
};

/// Alignment of a child element.
pub const ChildAlignment = struct {
    /// Alignment in the x direction.
    x: LayoutAlignmentX = .left,
    /// Alignment in the y direction.
    y: LayoutAlignmentY = .top,
};

/// Minimum and maximum bounds of a size.
pub const SizingMinMax = struct {
    /// Minimum size (will not collapse more than this).
    min: f32 = 0,
    /// Maximum size (will not expand more than this).
    max: f32 = std.math.floatMax(f32),

    fn toC(self: SizingMinMax) C.Clay_SizingMinMax {
        return .{
            .min = self.min,
            .max = self.max,
        };
    }
};

/// Sizing along an axis.
pub const SizingAxis = union(SizingType) {
    /// Size to fit children with padding and gaps.
    /// Use `sizingFit()`.
    fit: SizingMinMax,
    /// Size to grow to the size of the parent.
    /// Use `sizingGrow()`.
    grow: SizingMinMax,
    /// Size to fill a percentage of the parent.
    /// Use `sizingPercent()`.
    percent: f32,
    /// Set to a fixed size.
    /// Use `sizingFixed()`.
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

/// Sizing of a layout.
pub const Sizing = struct {
    /// Horizontal sizing.
    width: SizingAxis = .{ .fit = .{ .min = 0, .max = std.math.floatMax(f32) } },
    /// Vertical sizing.
    height: SizingAxis = .{ .fit = .{ .min = 0, .max = std.math.floatMax(f32) } },
};

/// Padding between elements.
pub const Padding = C.Clay_Padding;

/// Layout configuration for an element.
pub const LayoutConfig = struct {
    /// Controls how the final width and height of element are calculated.
    sizing: Sizing = .{},
    /// Controls the horizontal and vertical white-space "padding" around the outside of child elements.
    padding: Padding = .{ .x = 0, .y = 0 },
    /// Controls the white-space between child elements as they are laid out.
    child_gap: u16 = 0,
    /// Controls the alignment of children relative to the width and height of the parent container.
    child_alignment: ChildAlignment = .{ .x = .left, .y = .top },
    /// Controls the axis/direction in which child elements are laid out.
    layout_direction: LayoutDirection = .left_to_right,
};

// pub fn layoutDefault() *LayoutConfig {
//     return &C.Clay_LayoutConfig;
// }

/// Rectangle specific element configuration.
pub const RectangleElementConfig = struct {
    /// RGBA float values between 0 and 255.
    color: Color = .{ .r = 0, .g = 0, .b = 0, .a = 0 },
    /// Defines the radius in pixels for the arc of rectangle corners (0 is square, rectangle.width / 2 is circular).
    /// Note that `cornerRadius()` is available to set all 4 radii to the same value.
    corner_radius: CornerRadius = cornerRadius(0),
    // TODO: CONFIG EXTENSIONS!!!
};

/// Dictates how text will be wrapped.
pub const TextElementConfigWrapMode = enum(c_int) {
    /// Text will wrap on whitespace characters as container width shrinks, preserving whole words.
    words = C.CLAY_TEXT_WRAP_WORDS,
    /// Will only wrap when encountering newline characters.
    newlines = C.CLAY_TEXT_WRAP_NEWLINES,
    /// Text will never wrap even if its container is compressed beyond the text measured width.
    none = C.CLAY_TEXT_WRAP_NONE,
};

/// Text element specific element configuration.
pub const TextElementConfig = struct {
    /// RGBA float values between 0 and 255.
    text_color: Color = .{ .r = 0, .g = 0, .b = 0, .a = 0 },
    /// ID of the font to use.
    font_id: u16 = 0,
    /// Usually how tall a font is in pixels, but not necessarily.
    font_size: u16 = 0,
    /// Horizontal white space between individual characters.
    letter_spacing: u16 = 0,
    /// When non-zero, the height of each wrapped line of text is the given number of pixels tall.
    /// Will affect the layout of parent and siblings.
    /// A value of `0` will use the measured height of the font.
    line_height: u16 = 0,
    /// Under what conditions text should wrap.
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

/// Image specific element configuration.
pub const ImageElementConfig = struct {
    /// Generic pointer used to pass through image data to the renderer.
    /// Not recommended for type safety, but extensions are not in the zig version atm.
    image_data: *anyopaque,
    /// Used to perform aspect ratio scaling on the image element.
    /// At the moment, image height will scale with width growth and limitations, but width will not scale with height growth and limitations.
    source_dimensions: Dimensions = .{ .width = 0, .height = 0 },
};

/// How to attach a floating element to its parent.
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

/// How to attach a floating element to its parent.
pub const FloatingAttachPoints = struct {
    /// Attach point on the floating element (this).
    element: FloatingAttachPointType = .left_top,
    /// Attach point on the parent element.
    parent: FloatingAttachPointType = .left_top,
};

/// How pointer interaction should pass through to elements below.
pub const PointerCaptureMode = enum(c_int) {
    /// Input is eaten by the floating container.
    capture = C.CLAY_POINTER_CAPTURE_MODE_CAPTURE,
    /// Input is passed through to the content underneath.
    passthrough = C.CLAY_POINTER_CAPTURE_MODE_PASSTHROUGH,
};

/// Floating element specific configuration.
pub const FloatingElementConfig = struct {
    /// Used to apply a position offset to the floating container after all other layout has been calculated.
    offset: Vector2 = .{ .x = 0, .y = 0 },
    /// Used to expand the width and height of the floating container before laying out child elements.
    expand: Dimensions = .{ .width = 0, .height = 0 },
    /// The higher the index, the more on top the floating element will be drawn.
    z_index: u16 = 0,
    /// Is set to the parent declared inside by default, but can be explicitly specified here.
    parent_id: u32 = 0,
    /// The point on the floating container that attaches to the parent.
    attachment: FloatingAttachPoints = .{},
    /// How hover and click evens should be passed to content underneath.
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

/// Custom element specific configuration.
pub const CustomElementConfig = struct {
    /// Generic data to pass data through.
    /// Not type safe, but there are no extensions yet in zig.
    custom_data: ?*anyopaque = null,
};

/// Scroll element specific configuration.
pub const ScrollElementConfig = struct {
    /// Enables or disables horizontal scrolling for the container element.
    horizontal: bool = false,
    /// Enables or disables vertical scrolling for the container element.
    vertical: bool = false,
};

/// Border data.
/// Note that a border configuration does not effect the layout.
/// Border containers with zero padding will be drawn over the top of child elements.
pub const Border = struct {
    /// Border thickness.
    width: u32 = 0,
    /// Border color, RGBA from 0 to 255.
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

/// Border specific configuration.
pub const BorderElementConfig = struct {
    /// Border on the left edge of the element.
    left: Border = .{},
    /// Border on the right edge of the element.
    right: Border = .{},
    /// Border on the top edge of the element.
    top: Border = .{},
    /// Border on the bottom edge of the element.
    bottom: Border = .{},
    /// Border drawn between child elements.
    /// Vertical lines if the layout is top to bottom, horizontal lines if the layout is left to right.
    between_children: Border = .{},
    /// Defines the radius in pixels for the arc of border corners (`0` is square, `rectangle.width / 2` is circular).
    corner_radius: CornerRadius = cornerRadius(0),
};

/// Render command configuration.
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

/// A scroll container's internal data.
pub const ScrollContainerData = struct {
    /// Pointer to internal scroll position of the data.
    /// Can mutate this to manually scroll.
    scroll_position: *Vector2,
    /// Width and height of the scroll container.
    scroll_container_dimensions: Dimensions,
    /// Width and height of the content to scroll (is larger).
    content_dimensions: Dimensions,
    /// Scroll element specific configuration.
    config: ScrollElementConfig,
    /// Container found for the requested element.
    found: bool,
};

/// Type of render command.
pub const RenderCommandType = enum(c_int) {
    /// Should be ignored, never emitted under normal conditions.
    none = C.CLAY_RENDER_COMMAND_TYPE_NONE,
    /// A rectangle should be drawn.
    rectangle = C.CLAY_RENDER_COMMAND_TYPE_RECTANGLE,
    /// A border should be drawn.
    border = C.CLAY_RENDER_COMMAND_TYPE_BORDER,
    /// Text should be drawn.
    text = C.CLAY_RENDER_COMMAND_TYPE_TEXT,
    /// An image should be drawn.
    image = C.CLAY_RENDER_COMMAND_TYPE_IMAGE,
    /// The renderer should cull pixels drawn outside the bounding box.
    scissor_start = C.CLAY_RENDER_COMMAND_TYPE_SCISSOR_START,
    /// End a previously started scissor command.
    scissor_end = C.CLAY_RENDER_COMMAND_TYPE_SCISSOR_END,
    /// Custom render command.
    custom = C.CLAY_RENDER_COMMAND_TYPE_CUSTOM,
};

/// A command to pass to the renderer.
pub const RenderCommand = struct {
    /// A rectangle representing the bounding box of this render command.
    bounding_box: BoundingBox,
    /// Render command specific configuration paired with type.
    config: RenderCommandConfig,
    /// Text data that is only used for text commands.
    text: ?[]const u8,
    /// Element ID that created this render command.
    id: u32,
};

/// Represents the final calculated layout.
/// Has an interator that can be used to get all the render commands stored in it.
pub const RenderCommandArray = struct {
    arr: C.Clay_RenderCommandArray,

    /// Create an iterator to iterate over each command.
    pub fn iter(self: *RenderCommandArray) RenderCommandIterator {
        return .{
            .arr = &self.arr,
        };
    }

    /// Iterator of each command in the command array.
    pub const RenderCommandIterator = struct {
        arr: *C.Clay_RenderCommandArray,
        index: i32 = 0,

        /// Get the next render command in the array.
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

/// Current state of pointer interaction.
pub const PointerDataInteractionState = enum(c_int) {
    /// First frame that the mouse button has been pressed while on an element.
    pressed_this_frame = C.CLAY_POINTER_DATA_PRESSED_THIS_FRAME,
    /// Mouse button is down and over the element.
    pressed = C.CLAY_POINTER_DATA_PRESSED,
    /// Mouse button has been released over an element.
    released_this_frame = C.CLAY_POINTER_DATA_RELEASED_THIS_FRAME,
    /// Mouse is being hovered over an element.
    release = C.CLAY_POINTER_DATA_RELEASED,
};

/// State of the pointer.
pub const PointerData = struct {
    /// Current pointer position relative to UI.
    position: Vector2,
    /// Click state of the pointer.
    state: PointerDataInteractionState,
};

/// Type of error encountered by clay.
pub const ErrorType = enum(c_int) {
    /// User attempted to use `text()` and forgot to call `setMeasureTextFunction()`.
    text_measurement_function_not_provided = C.CLAY_ERROR_TYPE_TEXT_MEASUREMENT_FUNCTION_NOT_PROVIDED,
    /// Clay was initialized with an arena that was too small for the configured max element count.
    /// Try using `minMemorySize()` to get the exact number of bytes needed.
    arena_capacity_exceeded = C.CLAY_ERROR_TYPE_ARENA_CAPACITY_EXCEEDED,
    /// The declared UI hierarchy has too many elements fo the configured max element count.
    /// Use `setMaxElementCount()` to increase the max, then call `minMemorySize()` again.
    elements_capacity_exceeded = C.CLAY_ERROR_TYPE_ELEMENTS_CAPACITY_EXCEEDED,
    /// The declared UI hierarchy has too much text for the configured text measure cache size.
    /// Use `setMaxMeasureTextCacheWordCount()` to increase the max, then call `minMemorySize()` again.
    text_measurement_capacity_exceeded = C.CLAY_ERROR_TYPE_TEXT_MEASUREMENT_CAPACITY_EXCEEDED,
    /// Two elements have been declared with the same ID.
    /// Set a breakpoint in your error handler for a stack back trace to where this occurred.
    duplicate_id = C.CLAY_ERROR_TYPE_DUPLICATE_ID,
    /// A floating element was declared with a `parent_id` property, but no element with that ID was found.
    /// Set a breakpoint in your error handler for a stack back trace to where this occurred.
    floating_container_parent_not_found = C.CLAY_ERROR_TYPE_FLOATING_CONTAINER_PARENT_NOT_FOUND,
    /// Clay has encountered an internal logic or memory error. Report this.
    internal_error = C.CLAY_ERROR_TYPE_INTERNAL_ERROR,
};

/// Context of an error received.
pub fn ErrorData(comptime UserData: type) type {
    return struct {
        /// Type of error encountered.
        error_type: ErrorType,
        /// Description of the error.
        error_text: []const u8,
        /// Extra user data to the error handler.
        user_data: *UserData,
    };
}

/// Callback data for handling an error.
pub fn ErrorHandler(comptime UserData: type) type {
    return struct {
        /// Function to call when an error is encountered.
        handler_function: *const fn (error_text: ErrorData(UserData)) void,
        /// User data to pass to the error handler.
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
/// Called each frame before any of the elements.
pub fn beginLayout() Layout {
    C.Clay_BeginLayout();
    return .{};
}

/// Returns an `ElementId` for the provided ID string, used for querying element info such as mouseover state, scroll container data, etc.
/// * `id_string` - ID string to get the element ID for.
pub fn getElementId(id_string: []const u8) ElementId {
    return ElementId.fromC(C.Clay_GetElementId(.{ .chars = id_string.ptr, .length = @intCast(id_string.len) }));
}

/// Returns an `ElementId` for the provided the ID string with an index mixed into the has for case of say looping.
/// * `id_string` - ID string to get the element ID for.
/// * `index` - Index of the element to mix in with the hash.
pub fn getElementIdWithIndex(id_string: []const u8, index: u32) ElementId {
    return ElementId.fromC(C.Clay_GetElementIdWithIndex(.{ .chars = id_string.ptr, .length = @intCast(id_string.len) }, index));
}

/// Called during layout declaration and returns true if the pointer position previously set with `setPointerState()` is inside the bounding box of the currently open element.
/// Note that this is based on the element's position from the last frame.
pub fn hovered() bool {
    return C.Clay_Hovered();
}

var on_hover_cb: ?*const anyopaque = null;

fn onHoverCb(element_id: C.Clay_ElementId, pointer_data: C.Clay_PointerData, user_data: isize) callconv(.C) void {
    std.debug.print("{d}\n", .{pointer_data.state});
    const func: *const fn (element_id: ElementId, pointer_data: PointerData, user_data: ?*anyopaque) void = @ptrCast(on_hover_cb.?);
    func(ElementId.fromC(element_id), .{ .position = pointer_data.position, .state = @enumFromInt(pointer_data.state) }, @ptrFromInt(@as(usize, @intCast(user_data))));
}

/// Called during layout declaration, this function allows you to attach a function pointer to the currently open element that will be called once per layout if the pointer position previously set with `setPointerState()` is inside the bounding box of the currently open element.
/// See `PointerData` for more information on the `pointer_data` argument.
/// * `on_hover_function` - Function to call on hover of the element.
/// * `user_data` - User data to pass to the hover function.
pub fn onHover(on_hover_function: *const fn (element_id: ElementId, pointer_data: PointerData, user_data: ?*anyopaque) void, user_data: ?*anyopaque) void {
    on_hover_cb = on_hover_function;
    C.Clay_OnHover(onHoverCb, @intCast(@intFromPtr(user_data)));
}

/// Returns true if the pointer position previously set with `setPointerState()` is inside the bounding box of the layout element with the provided `element_id`.
/// Note that this position from the last frame.
/// If frame-accurate pointer overlap detection is required, perhaps in the case of significant change in UI layout between frames, you can simply run your layout code twice that frame.
/// The second call to `pointerOver()` will be frame accurate.
/// * `element_id` - Element to check if the pointer is over.
pub fn pointerOver(element_id: ElementId) bool {
    return C.Clay_PointerOver(element_id.toC());
}

/// Returns `ScrollContainerData` for the scroll container matching the provided ID.
/// This function allows for manipulation of scroll position, allowing you to build things such as scroll bars, buttons that jump to somewhere in the scroll container, etc.
/// * `element_id` - Element to get the scroll container data too.
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

/// Enable or disable debug mode.
/// * `enabled` - If to enable debug mode.
pub fn setDebugModeEnabled(enabled: bool) void {
    C.Clay_SetDebugModeEnabled(enabled);
}

/// If debug mode is enabled.
pub fn isDebugModeEnabled() bool {
    return C.Clay_IsDebugModeEnabled();
}

/// Enable or disable culling.
/// * `enabled` - If to enable culling.
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

/// Get a pointer to the current debug view highlight color.
pub fn debugViewHighlightColor() *Color {
    return &C.Clay__debugViewHighlightColor;
}

/// Get a pointer to the current debug view width.
pub fn debugViewWidth() *u32 {
    return &C.Clay__debugViewWidth;
}
