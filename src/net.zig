const std = @import("std");

// Quickstart function
// https://stackoverflow.com/questions/78125709/how-to-set-up-a-zig-tcp-server-socket

pub fn foobar() !void {
    std.debug.print("hell from the net\n", .{});

    std.debug.print("starting home brew zig server\n", .{});

    var gpa_alloc = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa_alloc.deinit() == .ok);
    const gpa = gpa_alloc.allocator();

    const addr = std.net.Address.initIp4(.{ 127, 0, 0, 1 }, 1337);
    var server = try addr.listen(.{});

    std.log.info("Server listening on port {}", .{addr.getPort()});

    var client = try server.accept();
    defer server.deinit();

    std.log.info("Sever accepted a connection?", .{});

    const client_reader = client.stream.reader();
    //    const clinet_writer = client.stream.writer();

    while (true) {
        std.log.info("Top of loop", .{});

        const msg = client_reader.readUntilDelimiterAlloc(
            gpa,
            '\n',
            65536,
        ) catch |err| {
            std.log.err("Read : {}", .{err});
            break;
        };
        std.log.info("HERE", .{});

        defer gpa.free(msg);
        std.log.info("Recieved message: \"{}\"", .{std.zig.fmtEscapes(msg)});

        // clinet_writer.writeAll(
        //     "HTTP/1.1 200 OK\r\ncontent-length: 7\r\nconnection: keepalive\r\n\r\nHELLO\r\n",
        // ) catch |e| {
        //     std.log.err("Reply : {}", .{e});
        //     break;
        // };
    }
    std.posix.exit(0);
}
