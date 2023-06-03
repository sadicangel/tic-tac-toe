const std = @import("std");
const Game = @import("game.zig").Game;

pub fn main() !void {
    const stdout = std.io.getStdOut();
    const writer = stdout.writer();
    var game = Game.init('X');
    var winner: u8 = undefined;
    var i: u32 = 0;
    while (i < 10) {
        try game.print(writer);
        winner = game.getWinner();
        if (winner != ' ') {
            break;
        }
        const next = try game.findEmpty();
        game.playAt(next);
        i += 1;
        try writer.print("\n", .{});
    }
    try writer.print("The winner is player '{c}'.\n", .{winner});
}
