const std = @import("std");
const rl = @import("raylib");
const GameState = @import("game.zig").GameState;

pub fn main() anyerror!void {
    //Game Variables (MODLE)
    //--------------------------------------------------------------------------------------
    var gameState = GameState.init(0);

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

        const p1InputVec = getInputVectorPlayer1();
        gameState.pos = gameState.pos.add(p1InputVec);

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

fn getInputVectorPlayer1() rl.Vector2 {
    const scale: f32 = 2.0;
    var dir = rl.Vector2.init(0, 0);

    if (rl.isKeyDown(rl.KeyboardKey.w)) dir = dir.add(rl.Vector2.init(0.0, -1.0));
    if (rl.isKeyDown(rl.KeyboardKey.s)) dir = dir.add(rl.Vector2.init(0.0, 1.0));
    if (rl.isKeyDown(rl.KeyboardKey.a)) dir = dir.add(rl.Vector2.init(-1.0, 0.0));
    if (rl.isKeyDown(rl.KeyboardKey.d)) dir = dir.add(rl.Vector2.init(1.0, 0.0));
    dir = dir.normalize().scale(scale);
    return dir;
}

// test {
//     @import("std").testing.refAllDecls(@This());
// }

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "do something!" {
    try std.testing.expect(true);
}

// Test for game.zig

test "GameState should init" {
    const gs = GameState.init(1);
    std.debug.print("testing print", .{});
    std.testing.expect(gs.player_count == 1);
    std.testing.expect(gs.players[0].id == 1);
}
