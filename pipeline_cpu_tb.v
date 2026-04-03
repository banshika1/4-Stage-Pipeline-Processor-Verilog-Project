module tb;

reg clk = 0;
reg rst;

pipeline_cpu uut (.clk(clk), .rst(rst));

always #5 clk = ~clk;

initial begin
    rst = 1;
    #10 rst = 0;

    #100 $finish;
end

endmodule