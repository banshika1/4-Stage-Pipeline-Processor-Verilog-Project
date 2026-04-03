`timescale 1ns / 1ps

module pipeline_cpu (
    input clk,
    input rst
);

// PC
reg [3:0] pc;

// IF stage
wire [15:0] instr;
instr_mem imem (.addr(pc), .instr(instr));

// IF/ID pipeline reg
reg [15:0] IF_ID_instr;

// ID stage
wire [3:0] opcode = IF_ID_instr[15:12];
wire [3:0] rd = IF_ID_instr[11:8];
wire [3:0] rs1 = IF_ID_instr[7:4];
wire [3:0] rs2 = IF_ID_instr[3:0];

wire [7:0] rd1, rd2;

reg_file rf (
    .clk(clk),
    .we(WB_we),
    .rs1(rs1),
    .rs2(rs2),
    .rd(WB_rd),
    .wd(WB_data),
    .rd1(rd1),
    .rd2(rd2)
);

// ID/EX pipeline reg
reg [7:0] ID_EX_a, ID_EX_b;
reg [3:0] ID_EX_op, ID_EX_rd;

// EX stage
wire [7:0] alu_out;

alu alu1 (
    .a(ID_EX_a),
    .b(ID_EX_b),
    .op(ID_EX_op),
    .result(alu_out)
);

// EX/WB pipeline reg

reg [7:0] EX_WB_result;
reg [3:0] EX_WB_rd;
reg WB_we;

wire [7:0] WB_data;
wire [3:0] WB_rd;
assign WB_data = EX_WB_result;
assign WB_rd   = EX_WB_rd;


// Pipeline flow
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 0;

        // RESET ALL PIPELINE REGISTERS 🔥
        IF_ID_instr <= 0;

        ID_EX_a <= 0;
        ID_EX_b <= 0;
        ID_EX_op <= 0;
        ID_EX_rd <= 0;

        EX_WB_result <= 0;
        EX_WB_rd <= 0;

        WB_we <= 0;
    end 
    else begin
        // IF
        pc <= pc + 1;

        // IF/ID
        IF_ID_instr <= instr;

        // ID/EX
        ID_EX_a <= rd1;
        ID_EX_b <= rd2;
        ID_EX_op <= opcode;
        ID_EX_rd <= rd;

        // EX/WB
        EX_WB_result <= alu_out;
        EX_WB_rd <= ID_EX_rd;
        WB_we <= 1;
    end
end

endmodule
