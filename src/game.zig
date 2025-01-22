const std = @import("std");
const rl = @import("raylib");

pub const GameState = struct {
    initial_player_count: u4,
    players: []PlayerState,
    all_players: [std.math.maxInt(u4)]PlayerState,

    pub fn init(player_count: u4) GameState {
        var gs = GameState{
            .initial_player_count = player_count,
            .all_players = undefined,
            .players = undefined,
        };

        std.debug.print("initial player count {}\n", .{player_count});

        for (gs.all_players[0..player_count], 0..) |*c, i| {
            c.* = PlayerState.init(@intCast(i));
            // std.debug.print("JAJAJ {}\n", .{c.id});
        }
        gs.players = gs.all_players[0..player_count];
        // gs.players = gs.all_players[0..player_count];
        // for (gs.players, 0..) |*c, i| {
        //     c.* = PlayerState.init(@intCast(i));
        //     std.debug.print("JAJAJ {}\n", .{c.id});
        // }
        return gs;
    }

    // pub fn setPlayers(self: *Self) *GameState {
    //     self.players = self.all_players[0..self.initial_player_count];
    //     return self;
    // }

    pub fn toScreenX(self: GameState, player_id: u4) i32 {
        return @as(i32, @intFromFloat(self.players[player_id].pos.x));
    }
    pub fn toScreenY(self: GameState, player_id: u4) i32 {
        return @as(i32, @intFromFloat(self.players[player_id].pos.y));
    }
};

test "GameState should init with one player" {
    const gs = GameState.init(1);
    // std.debug.print("\n players count: {any}\n", .{gs.initial_player_count});
    // for (gs.all_players) |p| std.debug.print("{}\n", .{p});
    // std.debug.print("\n and just players: {any}\n", .{gs.players.len});
    // for (gs.players) |p| std.debug.print("{}\n", .{p});

    // std.debug.print("\n and player id 1 {any}\n", .{gs.players[0]});

    try std.testing.expectEqual(1, gs.initial_player_count);
    try std.testing.expectEqual(0, gs.players[0].id);
}

test "GameState init with 5 players" {
    const gs = GameState.init(5);

    for (gs.players, 0..) |p, i| {
        try std.testing.expectEqual(i, p.id);
    }
}

test "GameState init with max players" {
    const gs = GameState.init(std.math.maxInt(u4));
    // gs.players = gs.all_players[0..gs.initial_player_count];
    // std.debug.print("JAJA", .{});
    std.debug.print("\nmax players: {}\n\n", .{gs.players.len});
    for (gs.players, 0..) |p, i| {
        std.debug.print("p id: {} i : {}\n", .{ p.id, i });
        // try std.testing.expectEqual(i, p.id);
    }
}

pub const PlayerState = struct {
    id: u4,
    facing: f32,
    pos: rl.Vector2,

    pub fn init(id: u4) PlayerState {
        return PlayerState{ .id = id, .facing = 0.0, .pos = rl.Vector2.init(0, 0) };
    }
};
