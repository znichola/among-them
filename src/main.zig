const std = @import("std");
const rl = @import("raylib");

// pub const OrbitalEntity = struct {};

pub const GameState = struct {
    pos: rl.Vector2,

    pub fn toScreenX(self: GameState) i32 {
        return @as(i32, @intFromFloat(self.pos.x));
    }
    pub fn toScreenY(self: GameState) i32 {
        return @as(i32, @intFromFloat(self.pos.y));
    }
};

pub fn main() anyerror!void {
    //Game Variables (MODLE)
    //--------------------------------------------------------------------------------------
    var gameState = GameState{ .pos = rl.Vector2.init(100, 100) };

    //-end MODLE----------------------------------------------------------------------------

    // Initialization
    //--------------------------------------------------------------------------------------
    const screenWidth = 800;
    const screenHeight = 450;

    rl.initWindow(screenWidth, screenHeight, "raylib-zig [core] example - basic window");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60); // Set our game to run at 60 frames-per-second
    //--------------------------------------------------------------------------------------

    // Main game loop
    while (!rl.windowShouldClose()) { // Detect window close button or ESC key
        // (Update)
        //----------------------------------------------------------------------------------
        var tmpPos = rl.Vector2.init(0, 0);
        if (rl.isKeyDown(rl.KeyboardKey.w)) tmpPos = tmpPos.add(rl.Vector2.init(0.0, -1.0));
        if (rl.isKeyDown(rl.KeyboardKey.s)) tmpPos = tmpPos.add(rl.Vector2.init(0.0, 1.0));
        if (rl.isKeyDown(rl.KeyboardKey.a)) tmpPos = tmpPos.add(rl.Vector2.init(-1.0, 0.0));
        if (rl.isKeyDown(rl.KeyboardKey.d)) tmpPos = tmpPos.add(rl.Vector2.init(1.0, 0.0));
        tmpPos = tmpPos.normalize().scale(2.0);
        gameState.pos = gameState.pos.add(tmpPos);

        // if (rl.isKeyPressed(rl.KeyboardKey.key_up)) options.dt.dtUp();
        // if (rl.isKeyPressed(rl.KeyboardKey.key_down)) options.dt.dtDown();/

        // Draw (VIEW)
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);
        rl.drawFPS(10, 10);

        rl.drawCircle(gameState.toScreenX(), gameState.toScreenY(), 4, rl.Color.red);
        //----------------------------------------------------------------------------------
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
