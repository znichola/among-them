const std = @import("std");
const rl = @import("raylib");

pub const GameState = struct {
    player_count: u4,
    all_players: [std.math.maxInt(u4)]PlayerState,
    players: []PlayerState,

    pub fn init(player_count: u4) GameState {
        var gs = GameState{
            .player_count = player_count,
            .all_players = undefined,
        };
        gs.players = gs.all_players[0..player_count];
        for (gs.players, 0..) |*c, i| {
            c.* = PlayerState.init(@intCast(i));
        }
        return gs;
    }

    pub fn toScreenX(self: GameState, player_id: u4) i32 {
        return @as(i32, @intFromFloat(self.players[player_id].pos.x));
    }
    pub fn toScreenY(self: GameState, player_id: u4) i32 {
        return @as(i32, @intFromFloat(self.players[player_id].pos.y));
    }
};

test "GameState should init" {
    const gs = GameState.init(1);
    std.debug.print("testing print", .{});
    std.testing.expect(gs.player_count == 1);
    std.testing.expect(gs.players[0].id == 1);
}

pub const PlayerState = struct {
    id: u4,
    facing: f32,
    pos: rl.Vector2,

    pub fn init(id: u4) PlayerState {
        return PlayerState{ .id = id, .facing = 0.0, .pos = rl.Vector2.init(0, 0) };
    }
};
