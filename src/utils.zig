const rl = @import("raylib");

pub fn worldToScreen(p: rl.Vector2) struct { x: i32, y: i32 } {
    return .{
        .x = @as(i32, @intFromFloat(p.x)),
        .y = @as(i32, @intFromFloat(p.y)),
    };
}
