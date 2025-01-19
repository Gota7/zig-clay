const RendererRaylib = @import("backends/raylib.zig");

const clay = @import("clay");
const raylib = @import("raylib");
const std = @import("std");

const font_id_body_16: u16 = 0;
const color_white = clay.Color{ .r = 255, .g = 255, .b = 255, .a = 255 };

fn render_header_button(text: []const u8) void {
    if (clay.child(&.{
        clay.layout(.{
            .padding = .{ .x = 16, .y = 8 },
        }),
        clay.rectangle(.{
            .color = .{ .r = 140, .g = 140, .b = 140, .a = 255 },
            .corner_radius = clay.cornerRadius(5),
        }),
    })) |child| {
        defer child.end();
        clay.text(text, .{
            .font_id = font_id_body_16,
            .font_size = 16,
            .text_color = color_white,
        });
    }
}

fn render_dropdown_menu_item(text: []const u8) void {
    if (clay.child(&.{
        clay.layout(.{
            .padding = .{ .x = 16, .y = 16 },
        }),
    })) |child| {
        defer child.end();
        clay.text(text, .{
            .font_id = font_id_body_16,
            .font_size = 16,
            .text_color = color_white,
        });
    }
}

const Document = struct {
    title: []const u8,
    contents: []const u8,
};

const documents = [_]Document{
    Document{ .title = "Squirrels", .contents = "The Secret Life of Squirrels: Nature's Clever Acrobats\nSquirrels are often overlooked creatures, dismissed as mere park inhabitants or backyard nuisances. Yet, beneath their fluffy tails and twitching noses lies an intricate world of cunning, agility, and survival tactics that are nothing short of fascinating. As one of the most common mammals in North America, squirrels have adapted to a wide range of environments from bustling urban centers to tranquil forests and have developed a variety of unique behaviors that continue to intrigue scientists and nature enthusiasts alike.\n\nMaster Tree Climbers\nAt the heart of a squirrel's skill set is its impressive ability to navigate trees with ease. Whether they're darting from branch to branch or leaping across wide gaps, squirrels possess an innate talent for acrobatics. Their powerful hind legs, which are longer than their front legs, give them remarkable jumping power. With a tail that acts as a counterbalance, squirrels can leap distances of up to ten times the length of their body, making them some of the best aerial acrobats in the animal kingdom.\nBut it's not just their agility that makes them exceptional climbers. Squirrels' sharp, curved claws allow them to grip tree bark with precision, while the soft pads on their feet provide traction on slippery surfaces. Their ability to run at high speeds and scale vertical trunks with ease is a testament to the evolutionary adaptations that have made them so successful in their arboreal habitats.\n\nFood Hoarders Extraordinaire\nSquirrels are often seen frantically gathering nuts, seeds, and even fungi in preparation for winter. While this behavior may seem like instinctual hoarding, it is actually a survival strategy that has been honed over millions of years. Known as \"scatter hoarding,\" squirrels store their food in a variety of hidden locations, often burying it deep in the soil or stashing it in hollowed-out tree trunks.\nInterestingly, squirrels have an incredible memory for the locations of their caches. Research has shown that they can remember thousands of hiding spots, often returning to them months later when food is scarce. However, they don't always recover every stash some forgotten caches eventually sprout into new trees, contributing to forest regeneration. This unintentional role as forest gardeners highlights the ecological importance of squirrels in their ecosystems.\n\nThe Great Squirrel Debate: Urban vs. Wild\nWhile squirrels are most commonly associated with rural or wooded areas, their adaptability has allowed them to thrive in urban environments as well. In cities, squirrels have become adept at finding food sources in places like parks, streets, and even garbage cans. However, their urban counterparts face unique challenges, including traffic, predators, and the lack of natural shelters. Despite these obstacles, squirrels in urban areas are often observed using human infrastructure such as buildings, bridges, and power lines as highways for their acrobatic escapades.\nThere is, however, a growing concern regarding the impact of urban life on squirrel populations. Pollution, deforestation, and the loss of natural habitats are making it more difficult for squirrels to find adequate food and shelter. As a result, conservationists are focusing on creating squirrel-friendly spaces within cities, with the goal of ensuring these resourceful creatures continue to thrive in both rural and urban landscapes.\n\nA Symbol of Resilience\nIn many cultures, squirrels are symbols of resourcefulness, adaptability, and preparation. Their ability to thrive in a variety of environments while navigating challenges with agility and grace serves as a reminder of the resilience inherent in nature. Whether you encounter them in a quiet forest, a city park, or your own backyard, squirrels are creatures that never fail to amaze with their endless energy and ingenuity.\nIn the end, squirrels may be small, but they are mighty in their ability to survive and thrive in a world that is constantly changing. So next time you spot one hopping across a branch or darting across your lawn, take a moment to appreciate the remarkable acrobat at work a true marvel of the natural world.\n" },
    Document{ .title = "Lorem Ipsum", .contents = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum." },
    Document{ .title = "Vacuum Instructions", .contents = "Chapter 3: Getting Started - Unpacking and Setup\n\nCongratulations on your new SuperClean Pro 5000 vacuum cleaner! In this section, we will guide you through the simple steps to get your vacuum up and running. Before you begin, please ensure that you have all the components listed in the \"Package Contents\" section on page 2.\n\n1. Unboxing Your Vacuum\nCarefully remove the vacuum cleaner from the box. Avoid using sharp objects that could damage the product. Once removed, place the unit on a flat, stable surface to proceed with the setup. Inside the box, you should find:\n\n    The main vacuum unit\n    A telescoping extension wand\n    A set of specialized cleaning tools (crevice tool, upholstery brush, etc.)\n    A reusable dust bag (if applicable)\n    A power cord with a 3-prong plug\n    A set of quick-start instructions\n\n2. Assembling Your Vacuum\nBegin by attaching the extension wand to the main body of the vacuum cleaner. Line up the connectors and twist the wand into place until you hear a click. Next, select the desired cleaning tool and firmly attach it to the wand's end, ensuring it is securely locked in.\n\nFor models that require a dust bag, slide the bag into the compartment at the back of the vacuum, making sure it is properly aligned with the internal mechanism. If your vacuum uses a bagless system, ensure the dust container is correctly seated and locked in place before use.\n\n3. Powering On\nTo start the vacuum, plug the power cord into a grounded electrical outlet. Once plugged in, locate the power switch, usually positioned on the side of the handle or body of the unit, depending on your model. Press the switch to the \"On\" position, and you should hear the motor begin to hum. If the vacuum does not power on, check that the power cord is securely plugged in, and ensure there are no blockages in the power switch.\n\nNote: Before first use, ensure that the vacuum filter (if your model has one) is properly installed. If unsure, refer to \"Section 5: Maintenance\" for filter installation instructions." },
    Document{ .title = "Article 4", .contents = "Article 4" },
    Document{ .title = "Article 5", .contents = "Article 5" },
};

var selected_document_index: usize = 0;

fn handle_sidebar_interaction(element_id: clay.ElementId, pointer_data: clay.PointerData, user_data: ?*anyopaque) void {
    _ = element_id;
    const doc_ind: usize = @intFromPtr(user_data);
    if (pointer_data.state == .pressed_this_frame and doc_ind < documents.len) {
        selected_document_index = doc_ind;
    }
}

fn err(error_text: clay.ErrorData(void)) void {
    std.debug.print("Clay: \"{s}\", {s}\n", .{ error_text.error_text, @tagName(error_text.error_type) });
}

pub fn main() !void {
    RendererRaylib.initialize(
        1024,
        768,
        "Introducing Clay Demo",
        .{ .window_resizable = true, .window_highdpi = true, .msaa_4x_hint = true, .vsync_hint = true },
    );
    defer raylib.closeWindow();

    // Setup arena.
    const required_mem = clay.minMemorySize();
    const arena_data = try std.heap.c_allocator.alloc(u8, @intCast(required_mem));
    defer std.heap.c_allocator.free(arena_data);
    const arena = clay.createArenaWithCapacityAndMemory(arena_data);

    // Initialize clay.
    var empty = {};
    clay.initialize(arena, .{
        .width = @floatFromInt(raylib.getRenderWidth()),
        .height = @floatFromInt(raylib.getRenderHeight()),
    }, void, .{
        .handler_function = err,
        .user_data = &empty,
    });
    clay.setMeasureTextFunction(RendererRaylib.measureText);
    RendererRaylib.fonts = std.ArrayList(RendererRaylib.Font).init(std.heap.c_allocator);
    defer RendererRaylib.fonts.?.deinit();
    try RendererRaylib.fonts.?.append(.{
        .font = raylib.loadFontEx("resources/Roboto-Regular.ttf", 48, null),
        .id = font_id_body_16,
    });
    raylib.setTextureFilter(RendererRaylib.fonts.?.items[font_id_body_16].font.texture, .bilinear);
    defer raylib.unloadFont(RendererRaylib.fonts.?.items[font_id_body_16].font);
    clay.C.Clay_SetDebugModeEnabled(true);

    // Make text arena.
    var text_arena = std.heap.ArenaAllocator.init(std.heap.c_allocator);
    defer text_arena.deinit();

    // Main loop.
    while (!raylib.windowShouldClose()) {

        // External events.
        const width: f32 = @as(f32, @floatFromInt(raylib.getRenderWidth())) / raylib.getWindowScaleDPI().x;
        const height: f32 = @as(f32, @floatFromInt(raylib.getRenderHeight())) / raylib.getWindowScaleDPI().y;
        clay.setLayoutDimensions(.{ .width = width, .height = height,});

        const mouse_pos = raylib.getMousePosition();
        const scroll_delta = raylib.getMouseWheelMoveV();
        clay.setPointerState(.{ .x = mouse_pos.x, .y = mouse_pos.y }, raylib.isMouseButtonDown(.left));
        clay.updateScrollContainers(true, .{ .x = scroll_delta.x, .y = scroll_delta.y }, raylib.getFrameTime());

        const layout_expand = clay.Sizing{
            .width = clay.sizingGrow(.{}),
            .height = clay.sizingGrow(.{}),
        };

        const content_background_config = clay.RectangleElementConfig{
            .color = .{ .r = 90, .g = 90, .b = 90, .a = 255 },
            .corner_radius = clay.cornerRadius(8),
        };

        // Build UI here.
        const layout = clay.beginLayout();
        if (clay.child(&.{
            clay.id("OuterContainer"),
            clay.rectangle(.{ .color = .{ .r = 43, .g = 41, .b = 51, .a = 255 } }),
            clay.layout(.{
                .layout_direction = .top_to_bottom,
                .sizing = layout_expand,
                .padding = .{ .x = 16, .y = 16 },
                .child_gap = 16,
            }),
        })) |outer_container| {
            defer outer_container.end();

            // Child elements go inside braces.
            if (clay.child(&.{
                clay.id("HeaderBar"),
                clay.rectangle(content_background_config),
                clay.layout(.{
                    .sizing = .{
                        .width = clay.sizingGrow(.{}),
                        .height = clay.sizingFixed(60),
                    },
                    .padding = .{ .x = 16 },
                    .child_gap = 16,
                    .child_alignment = .{ .y = .center },
                }),
            })) |header_bar| {
                defer header_bar.end();

                // Header buttons go here.
                if (clay.child(&.{
                    clay.id("FileButton"),
                    clay.layout(.{
                        .padding = .{ .x = 16, .y = 8 },
                    }),
                    clay.rectangle(.{
                        .color = .{ .r = 140, .g = 140, .b = 140, .a = 255 },
                        .corner_radius = clay.cornerRadius(5),
                    }),
                })) |file_button| {
                    defer file_button.end();
                    clay.text("File", .{
                        .font_id = font_id_body_16,
                        .font_size = 16,
                        .text_color = color_white,
                    });

                    const file_menu_visible = clay.pointerOver(clay.getElementId("FileButton")) or clay.pointerOver(clay.getElementId("FileMenu"));

                    if (file_menu_visible) {
                        if (clay.child(&.{
                            clay.id("FileMenu"),
                            clay.floating(.{
                                .attachment = .{ .parent = .left_bottom },
                            }),
                            clay.layout(.{
                                .padding = .{ .x = 0, .y = 8 },
                            }),
                        })) |file_menu| {
                            defer file_menu.end();
                            if (clay.child(&.{ clay.layout(.{
                                .layout_direction = .top_to_bottom,
                                .sizing = .{ .width = clay.sizingFixed(200) },
                            }), clay.rectangle(.{
                                .color = .{ .r = 40, .g = 40, .b = 40, .a = 255 },
                                .corner_radius = clay.cornerRadius(8),
                            }) })) |dropdown_area| {
                                defer dropdown_area.end();
                                render_dropdown_menu_item("New");
                                render_dropdown_menu_item("Open");
                                render_dropdown_menu_item("Close");
                            }
                        }
                    }
                }
                render_header_button("Edit");
                if (clay.child(&.{clay.layout(.{
                    .sizing = .{ .width = clay.sizingGrow(.{}) },
                })})) |spacer| {
                    defer spacer.end();
                }
                render_header_button("Upload");
                render_header_button("Media");
                render_header_button("Support");
            }

            if (clay.child(&.{
                clay.id("LowerContent"),
                clay.layout(.{
                    .sizing = layout_expand,
                    .child_gap = 16,
                }),
            })) |lower_content| {
                defer lower_content.end();
                if (clay.child(&.{
                    clay.id("Sidebar"),
                    clay.rectangle(content_background_config),
                    clay.layout(.{
                        .layout_direction = .top_to_bottom,
                        .padding = .{ .x = 16, .y = 16 },
                        .child_gap = 8,
                        .sizing = .{
                            .width = clay.sizingFixed(250),
                            .height = clay.sizingGrow(.{}),
                        },
                    }),
                })) |sidebar| {
                    defer sidebar.end();
                    for (documents, 0..) |document, i| {
                        const sidebar_button_layout = clay.LayoutConfig{
                            .sizing = .{ .width = clay.sizingGrow(.{}) },
                            .padding = .{ .x = 16, .y = 16 },
                        };

                        if (i == selected_document_index) {
                            if (clay.child(&.{
                                clay.layout(sidebar_button_layout),
                                clay.rectangle(.{
                                    .color = .{ .r = 120, .g = 120, .b = 120, .a = 255 },
                                    .corner_radius = clay.cornerRadius(8),
                                }),
                            })) |sidebar_button| {
                                defer sidebar_button.end();
                                clay.text(document.title, .{
                                    .font_id = font_id_body_16,
                                    .font_size = 20,
                                    .text_color = color_white,
                                });
                            }
                        } else {
                            if (clay.childManualControlFlow()) |sidebar_button| {
                                defer sidebar_button.end();

                                // Do config here.
                                sidebar_button.config(clay.layout(sidebar_button_layout));
                                clay.onHover(handle_sidebar_interaction, @ptrFromInt(i));
                                if (clay.hovered())
                                    sidebar_button.config(clay.rectangle(.{
                                        .color = .{ .r = 120, .g = 120, .b = 120, .a = 255 },
                                        .corner_radius = clay.cornerRadius(8),
                                    }));
                                sidebar_button.endConfig();

                                // Children.
                                clay.text(document.title, .{
                                    .font_id = font_id_body_16,
                                    .font_size = 20,
                                    .text_color = color_white,
                                });
                            }
                        }
                    }
                }
                if (clay.child(&.{
                    clay.id("MainContent"),
                    clay.rectangle(content_background_config),
                    clay.scroll(.{ .vertical = true }),
                    clay.layout(.{
                        .layout_direction = .top_to_bottom,
                        .child_gap = 16,
                        .padding = .{ .x = 16, .y = 16 },
                        .sizing = layout_expand,
                    }),
                })) |main_content| {
                    defer main_content.end();
                    const selected_document = documents[selected_document_index];
                    clay.text(selected_document.title, .{
                        .font_id = font_id_body_16,
                        .font_size = 24,
                        .text_color = color_white,
                    });
                    clay.text(selected_document.contents, .{
                        .font_id = font_id_body_16,
                        .font_size = 23,
                        .text_color = color_white,
                    });
                }
            }
        }

        // Finish drawing.
        raylib.beginDrawing();
        raylib.clearBackground(raylib.Color.black);
        var commands = layout.end();
        RendererRaylib.render(&commands, &text_arena);
        raylib.endDrawing();
    }
}
