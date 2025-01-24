const std = @import("std");
const rl = @import("raylib");

pub const GameState = struct {
    players: [std.math.maxInt(u4)]PlayerState,
    player_count: u4,
    max_players: u4,
    const Self = @This();

    pub fn init() Self {
        return Self{
            .players = undefined,
            .player_count = 0,
            .max_players = comptime std.math.maxInt(u4),
        };
    }

    pub fn addPlayer(self: Self) Self {
        var copy = self;
        if (self.player_count < self.max_players) {
            copy.player_count += 1;
            copy.players[self.player_count] = PlayerState.init(copy.player_count);
        }
        return copy;
    }

    pub fn map(self: Self, f: *const fn (p: PlayerState) PlayerState) Self {
        var copy = self;
        for (0..copy.player_count) |i| {
            copy.players[i] = f(copy.players[i]);
        }
        return copy;
    }

    pub fn toScreenX(self: Self, player_id: u4) i32 {
        return @as(i32, @intFromFloat(self.players[player_id].pos.x));
    }
    pub fn toScreenY(self: Self, player_id: u4) i32 {
        return @as(i32, @intFromFloat(self.players[player_id].pos.y));
    }
};

test "initialise and add players" {
    const gs = GameState.init();
    const gs2 = gs.addPlayer();
    const gs3 = gs2.addPlayer();

    try std.testing.expectEqual(2, gs3.player_count);
}

test "GameState init with 5 players" {
    const gs = GameState.init().addPlayer().addPlayer().addPlayer().addPlayer().addPlayer();

    var i: u4 = 0;
    while (i < gs.player_count) {
        try std.testing.expectEqual(i + 1, gs.players[i].id);
        i += 1;
    }
}

test "GameState init with max players" {
    var gs = GameState.init();
    for (0..gs.max_players) |_| {
        gs = gs.addPlayer();
    }
    // std.debug.print("\nmax players: {}\n\n", .{gs.players.len});
    try std.testing.expectEqual(gs.max_players, gs.player_count);
    for (0..gs.player_count) |i| {
        // std.debug.print("p id: {} i : {}\n", .{ gs.players[i], i });
        try std.testing.expectEqual(i + 1, gs.players[i].id);
    }
}

test "Adding too many players" {
    var gs = GameState.init();
    for (0..20) |_| {
        gs = gs.addPlayer();
    }
    try std.testing.expectEqual(gs.max_players, gs.player_count);
}

test "testing map" {
    const gs = GameState.init().addPlayer().addPlayer().map(struct {
        fn func(p: PlayerState) PlayerState {
            // std.debug.print("printing from map {}\n", .{p.id});
            return p;
        }
    }.func);
    _ = gs;
}

pub const PlayerState = struct {
    id: u4,
    facing: f32,
    pos: rl.Vector2,

    pub fn init(id: u4) PlayerState {
        return PlayerState{
            .id = id,
            .facing = 0.0,
            .pos = rl.Vector2.init(0, 0),
        };
    }
};

// gs.players = gs.all_players[0..player_count];
// for (gs.players, 0..) |*c, i| {
//     c.* = PlayerState.init(@intCast(i));
//     std.debug.print("JAJAJ {}\n", .{c.id});
// }
