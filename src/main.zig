const std = @import("std");
const rl = @import("raylib");
const GameState = @import("game.zig").GameState;

pub fn main() anyerror!void {
    //Game Variables (MODLE)
    //--------------------------------------------------------------------------------------
    var gameState = GameState.init();
    gameState = gameState.addPlayer();
    gameState = gameState.addPlayer();
    gameState.players[1].color = rl.Color.blue;

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

        gameState.players[0].pos = gameState.players[0].pos.add(getInputVectorPlayer1());
        gameState.players[1].pos = gameState.players[1].pos.add(getInputVectorPlayer2());
        gameState.players[0].facing = getMouseAnglePlayer(gameState.players[0].pos);

        // Draw (VIEW)
        //----------------------------------------------------------------------------------
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.white);
        rl.drawFPS(10, 10);
        rl.drawText(
            rl.textFormat("angle: %f", .{gameState.players[0].facing}),
            100,
            100,
            16,
            rl.Color.red,
        );

        const players = gameState.players[0..gameState.player_count];
        for (players) |p| {
            rl.drawCircle(
                gameState.toScreenX(p.id),
                gameState.toScreenY(p.id),
                6,
                p.color,
            );
            const facing_point = p.pos.add(
                rl.Vector2.init(20, 0).rotate(p.facing * -1.0),
            );
            rl.drawLine(
                gameState.toScreenX(p.id),
                gameState.toScreenY(p.id),
                toScreenX(facing_point),
                toScreenY(facing_point),
                p.color,
            );
        }
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

fn getInputVectorPlayer2() rl.Vector2 {
    const scale: f32 = 2.0;
    var dir = rl.Vector2.init(0, 0);

    if (rl.isKeyDown(rl.KeyboardKey.up)) dir = dir.add(rl.Vector2.init(0.0, -1.0));
    if (rl.isKeyDown(rl.KeyboardKey.down)) dir = dir.add(rl.Vector2.init(0.0, 1.0));
    if (rl.isKeyDown(rl.KeyboardKey.left)) dir = dir.add(rl.Vector2.init(-1.0, 0.0));
    if (rl.isKeyDown(rl.KeyboardKey.right)) dir = dir.add(rl.Vector2.init(1.0, 0.0));
    dir = dir.normalize().scale(scale);
    return dir;
}

fn getMouseAnglePlayer(pos: rl.Vector2) f32 {
    return pos.lineAngle(rl.getMousePosition());
}

test "other files" {
    @import("std").testing.refAllDecls(@This());
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}

test "do something!" {
    try std.testing.expect(true);
}

///////////////////////////////////////////////////////////////////////////////
// game.zig
///////////////////////////////////////////////////////////////////////////////

// const GameState = struct {
//     player_count: u4,
//     all_players: [std.math.maxInt(u4)]PlayerState,
//     players: []PlayerState,

//     pub fn init(player_count: u4) GameState {
//         var gs = GameState{
//             .player_count = player_count,
//             .all_players = undefined,
//         };
//         gs.players = gs.all_players[0..player_count];
//         for (gs.players, 0..) |*c, i| {
//             c.* = PlayerState.init(@intCast(i));
//         }
//         return gs;
//     }

//     pub fn toScreenX(self: GameState, player_id: u4) i32 {
//         return @as(i32, @intFromFloat(self.players[player_id].pos.x));
//     }
//     pub fn toScreenY(self: GameState, player_id: u4) i32 {
//         return @as(i32, @intFromFloat(self.players[player_id].pos.y));
//     }
// };

// test "GameState should init" {
//     const gs = GameState.init(1);
//     std.debug.print("testing print", .{});
//     std.testing.expect(gs.player_count == 1);
//     std.testing.expect(gs.players[0].id == 1);
// }

// pub const PlayerState = struct {
//     id: u4,
//     facing: f32,
//     pos: rl.Vector2,

//     pub fn init(id: u4) PlayerState {
//         return PlayerState{ .id = id, .facing = 0.0, .pos = rl.Vector2.init(0, 0) };
//     }
// };

pub fn toScreenX(pos: rl.Vector2) i32 {
    return @as(i32, @intFromFloat(pos.x));
}
pub fn toScreenY(pos: rl.Vector2) i32 {
    return @as(i32, @intFromFloat(pos.y));
}
