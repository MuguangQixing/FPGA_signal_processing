module lfsr(
    input clk,
    input rstn,
    output reg [7:0] out1,
    output reg [15:0] out2
);
//实现：x^8 + x^5 + x^2 + x + 1
    always @(posedge clk) begin
        if (~rstn) begin
            out1 <= 8'b0001_0001; // 初始状态
        end else begin
            out1 <= {out1[6:0], out1[7] ^ out1[4] ^ out1[1] ^ out1[0]}; // 移位与反馈
        end
    end
//实现：x^16 + x^8 + x^7 + x^6 + x^3 + 1
    always @(posedge clk) begin
        if (~rstn) begin
            out2 <= 16'b0100_1011_0101_0001; // 初始状态
        end else begin
            out2 <= {out2[15:0], out2[15] ^ out2[7] ^ out2[6] ^ out2[5] ^ out2[2]}; // 移位与反馈
        end
    end
endmodule

`timescale 1ps/1ps

module tb_lfsr();
reg clk;
reg rstn;
wire [7:0] out1;
wire [15:0] out2;
always #10 begin
    clk <= ~clk;
end

initial begin
    clk <= 0;
    rstn <= 0;
    #100 rstn <= 1;
end

lfsr uut(
    .clk(clk),
    .rstn(rstn),
    .out1(out1),
    .out2(out2)
);

endmodule
