module alu (
    input [7:0] a, b,
    input [3:0] op,
    output reg [7:0] result
);

always @(*) begin
    case(op)
        4'b0001: result = a + b; // ADD
        4'b0010: result = a - b; // SUB
        default: result = 8'b0;
    endcase
end

endmodule