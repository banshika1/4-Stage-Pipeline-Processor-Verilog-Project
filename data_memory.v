module data_mem (
    input clk,
    input we,
    input [3:0] addr,
    input [7:0] wd,
    output reg [7:0] rd
);

reg [7:0] memory [15:0];

always @(posedge clk) begin
    if (we)
        memory[addr] <= wd;
    rd <= memory[addr];
end

endmodule