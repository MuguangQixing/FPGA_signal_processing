
/*对于无符号数限制输出位宽*/
module overflow_protection#(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] in1,
    input [WIDTH-1:0] in2,
    
    output reg [WIDTH-1:0] out//限制了输出位宽不是WIDTH + 1
);

wire [WIDTH - 1:0] out_temp;
assign {overflow , out_temp} = in1 + in2;

always @(*) begin
    if(~overflow)//如果没有溢出
        out = out_temp;
    else
        out = {WIDTH{1'b1}};
end

endmodule









`timescale 1ps/1ps

module tb_overflow();

reg [3:0] in1;
reg [3:0] in2;

wire [3:0] out;

overflow_protection#(
    .WIDTH(4)
)
overflow_inst(
    .in1(in1),
    .in2(in2),
    
    .out(out)//限制了输出位宽不是WIDTH + 1
);

initial begin
    in1 = 4'b1111;
    in2 = 4'b0010;
    #100
    in1 = 4'b0111;
    in2 = 4'b0010;
    #100
    in1 = 4'b1111;
    in2 = 4'b1111;
    #100
    in1 = 4'b0101;
    in2 = 4'b0011;
    $finish;
end

endmodule