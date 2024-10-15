
/*对于有符号数限制输出位宽*/
module overflow_protection#(
    parameter WIDTH = 8
)(
    input [WIDTH-1:0] in1,//这里in1[WIDTH-1]是符号位
    input [WIDTH-1:0] in2,//这里in2[WIDTH-1]是符号位
    
    output reg [WIDTH-1:0] out//限制了输出位宽不是WIDTH + 1
);

wire [WIDTH : 0 ] in1_temp,in2_temp;//temp[WIDTH]符号位，temp[WIDTH-1:0]溢出位
wire [WIDTH - 2 : 0 ] out_temp;

assign in1_temp = {in1[WIDTH-1],in1};
assign in2_temp = {in2[WIDTH-1],in2};

assign {sign , overflow , out_temp} = in1_temp + in2_temp;//符号位+溢出位+结果

always @(*) begin
    if(~sign)begin//符号位为0说明out_temp >= 0
        if(overflow)//溢出
            out = {1'b0, {WIDTH-1{1'b1}}};
        else
            out = {overflow , out_temp};
    end
    else begin//out_temp 是负数
        if(~overflow)//溢出
            out = {1'b1,{WIDTH-1{1'b0}}};
        else
            out = {sign, out_temp};

    end
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
    #100
    in1 = 4'b0100;
    in2 = 4'b0010;
    #100
    in1 = 4'b0011;
    in2 = 4'b0001;
    #100
    in1 = 4'b1001;
    in2 = 4'b1001;
    $finish;
end

endmodule