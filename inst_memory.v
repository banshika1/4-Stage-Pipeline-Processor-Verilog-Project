module instr_mem (
    input [3:0] addr,
    output [15:0] instr
);

reg [15:0] memory [15:0];

initial begin
    memory[0] = 16'b0001_0001_0010_0011; // ADD R1 = R2 + R3
    memory[1] = 16'b0010_0010_0001_0011; // SUB R2 = R1 - R3
    memory[2] = 16'b0011_0011_0000_0101; // LOAD R3 = MEM[5]
end

assign instr = memory[addr];

endmodule