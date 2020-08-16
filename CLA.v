`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.10.2019 22:09:44
// Design Name: 
// Module Name: CLA
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cla4adder(a,b,cin,sum);
input[3:0] a;
input[3:0] b;
input cin;
output[3:0] sum;

wire[3:0] g,p;
wire[4:0] c;

assign g=a&b;
assign p=a^b;

assign c[0]=cin;
assign c[1]=cin&p[0] | g[0];
assign c[2]=g[1] | (g[0]&p[1])|(p[1]&p[0]&cin);
assign c[3]=g[2] | ( g[1]&p[2]) | (g[0]&p[1]&p[2]) | (cin&p[0]&p[1]&p[2]);
assign c[4]= g[3] | (g[2]&p[3]) | g[1]&p[2]&p[3] | g[0]&p[1]&p[2]&p[3] | (cin&p[0]&p[1]&p[2]&p[3]);
assign sum=a^b^c;

endmodule



module cla8bit(a, b, cin, sum);
input [7:0] a,b;
//output  cout;
output [7:0] sum;
input cin;
wire c1;
wire gg1, gg2,gg3,gg4;
wire gp1,gp2,gp3,gp4;
wire gen1,gen2;
wire prop1,prop2;
genprop4bit g1(a[3:0],b[3:0],gen1,prop1);
genprop4bit g2(a[7:4],b[7:4],gen2,prop2);
assign c1=  gen1 | prop1&cin;
//assign cout=gen2 | gen1&prop2 | prop2&prop1&cin;
cla4adder c0(a[3:0], b[3:0], cin, sum[3:0]);
cla4adder c2(a[7:4], b[7:4], c1, sum[7:4]);
endmodule

module cla32bit( a,b,cin,sum,cout);
    input [31:0] a,b;
    input cin;
    output [31:0] sum;
    output cout;
    wire c8,c16,c24,c32;
    wire gen8,gen16,gen24,gen32;
    wire prop8, prop16,prop24,prop32;
    genprop8bit g1(a[7:0],b[7:0],gen8,prop8);
    genprop8bit g2(a[15:8],b[15:8],gen16,prop16);
    genprop8bit g3(a[23:16],b[23:16],gen24,prop24);
    genprop8bit g4(a[31:24],b[31:24],gen32,prop32);
    assign c8=gen8 | (cin&prop8);
    assign c16=gen16 | (gen8&prop16)  | (cin&prop8&prop16);
    assign c24=gen24 | gen16&prop24 | gen8&prop16&prop24 | cin&prop8&prop16&prop24;
    assign c32=gen32 | (gen24&prop32) | (gen16&prop24&prop32) | (gen8&prop16&prop24&prop32) | (cin&prop8&prop16&prop24&prop32);
    assign cout=c32;
    wire c1,c2,c3;
    cla8bit c65(a[7:0], b[7:0],   cin,  sum[7:0]);
    cla8bit c35(a[15:8], b[15:8],  c8,   sum[15:8]);
    cla8bit c36(a[23:16], b[23:16], c16,  sum[23:16]);
    cla8bit c78(a[31:24], b[31:24], c24, sum[31:24]);
    
endmodule




module genprop4bit( a,b,gen, prop);
input[3:0] a,b;
output gen,prop;
wire [3:0] g, p;
assign p=a^b;
assign g=a&b;
assign prop=p[0]&p[1]&p[2]&p[3];
assign  gen=g[3]|(g[2]&p[3])|(g[1]&p[2]&p[3])|(g[0]&p[1]&p[2]&p[3]);

endmodule




module genprop8bit( a,b,gen, prop);
    input [7:0] a,b;
    output gen,prop;
    wire gen1,gen2,prop1,prop2;
    genprop4bit g1(a[3:0],b[3:0],gen1, prop1);
    genprop4bit g2(a[7:4],b[7:4],gen2,prop2);
    assign gen=gen2 | gen1&prop2;
    assign prop=prop1&prop2;
endmodule