const std = @import("std");

pub const Game = struct {
    currentPlayer: u8,
    grid: [9]u8,

    pub fn init(currentPlayer: u8) Game {
        return Game{ .currentPlayer = currentPlayer, .grid = [_]u8{' '} ** 9 };
    }

    pub fn print(self: Game, writer: std.fs.File.Writer) !void {
        try writer.print("1: {c} | {c} | {c}\n2: {c} | {c} | {c}\n3: {c} | {c} | {c}\nPlayer {c} turn.\n", .{ self.grid[0], self.grid[1], self.grid[2], self.grid[3], self.grid[4], self.grid[5], self.grid[6], self.grid[7], self.grid[8], self.currentPlayer });
    }

    pub fn findEmpty(self: Game) !usize {
        // How to use fixed size buffer?
        var list = std.ArrayList(usize).init(std.heap.page_allocator);
        defer list.deinit();
        const space: u8 = ' ';
        _ = space;
        var i: usize = 0;
        while (i < self.grid.len) {
            if (self.grid[i] == ' ')
                try list.append(i);
            i += 1;
        }
        const now = @intCast(u64, std.time.timestamp());
        var gen = std.rand.DefaultPrng.init(now);
        gen.random().shuffle(usize, list.items);
        return list.items[0];
    }

    pub fn playAt(self: *Game, position: usize) void {
        self.grid[position] = self.currentPlayer;
        self.currentPlayer = if (self.currentPlayer == 'X') 'O' else 'X';
    }

    pub fn getWinner(self: Game) u8 {
        if (self.grid[0] != ' ') {
            // X X X
            // . . .
            // . . .
            if (self.grid[0] == self.grid[1] and self.grid[0] == self.grid[2])
                return self.grid[0];
            // X . .
            // X . .
            // X . .
            if (self.grid[0] == self.grid[3] and self.grid[0] == self.grid[6])
                return self.grid[0];
            // X . .
            // . X .
            // . . X
            if (self.grid[0] == self.grid[4] and self.grid[0] == self.grid[8])
                return self.grid[0];
        }
        if (self.grid[1] != ' ') {
            // . X .
            // . X .
            // . X .
            if (self.grid[1] == self.grid[4] and self.grid[1] == self.grid[7])
                return self.grid[1];
        }
        if (self.grid[2] != ' ') {
            // . . X
            // . . X
            // . . X
            if (self.grid[2] == self.grid[5] and self.grid[2] == self.grid[8])
                return self.grid[2];
            // . . X
            // . X .
            // X . .
            if (self.grid[2] == self.grid[4] and self.grid[2] == self.grid[6])
                return self.grid[2];
        }
        if (self.grid[3] != ' ') {
            // . . .
            // X X X
            // . . .
            if (self.grid[3] == self.grid[4] and self.grid[3] == self.grid[5])
                return self.grid[3];
        }
        if (self.grid[6] != ' ') {
            // . . .
            // . . .
            // X X X
            if (self.grid[6] == self.grid[7] and self.grid[6] == self.grid[8])
                return self.grid[6];
        }

        return ' ';
    }
};
