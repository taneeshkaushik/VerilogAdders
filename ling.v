module bit32lingadder(a,b,cin,sum,cout);
input [31:0] a,b;
output [31:0] sum;
output cout;
input cin;
wire gen8,gen16, gen24, gen32,prop8,prop16,prop24,prop32;
bit8genprop b5(a[7:0],b[7:0],gen8,prop8);
bit8genprop b6(a[15:8],b[15:8],gen16,prop16);
bit8genprop b7(a[23:16],b[23:16],gen24,prop24);
bit8genprop b8(a[31:24],b[31:24],gen32,prop32);

wire c8,c16,c24,c32;

assign #4 c8= gen8| prop8&cin;
assign #6 c16=gen16 | (gen8&prop16)  | (cin&prop8&prop16);
assign #8 c24=gen24 | gen16&prop24 | gen8&prop16&prop24 | cin&prop8&prop16&prop24;
assign #10 c32=gen32 | (gen24&prop32) | (gen16&prop24&prop32) | (gen8&prop16&prop24&prop32) | (cin&prop8&prop16&prop24&prop32);
assign cout=c32;

    bit8lingadder b1(a[7:0], b[7:0],   cin,  sum[7:0]);
    bit8lingadder b2(a[15:8], b[15:8],  c8,   sum[15:8]);
    bit8lingadder b3(a[23:16], b[23:16], c16,  sum[23:16]);
    bit8lingadder b4(a[31:24], b[31:24], c24, sum[31:24]);


    
endmodule




module bit8lingadder( a,b,cin,sum);
input [7:0] a,b;
input cin;
wire extra1,extra2;
output [7:0] sum;

wire c1;
wire gen1,gen2,prop1,prop2;
genprop4bit g1 (a[3:0],b[3:0],gen1,prop1);
genprop4bit g2 (a[7:4],b[7:4],gen2,prop2);
assign c1= gen1 | (prop1 & cin);
ling4bit l1 (a[3:0],b[3:0],cin,extra1,sum[3:0]);
ling4bit l2 (a[7:4],b[7:4],c1,extra2,sum[7:4]);
endmodule


module bit8genprop( a,b,gen,prop);

    input[7:0] a,b;
    
    output gen,prop;
    wire gen1,gen2,prop1,prop2;
    genprop4bit h1 (a[3:0],b[3:0],gen1,prop1);
   genprop4bit h2 (a[7:4],b[7:4],gen2,prop2);
   assign gen=gen2 | (gen1& prop2);
   assign prop=prop1&prop2;
endmodule


module ling4bit(a, b, cin,cout,sum);
input[3:0] a,b;
output[3:0] sum;
output cout;
input cin;
wire [3:0] p;
wire [3:0] g;
wire [4:1] h;
assign g[3:0]=a[3:0] & b[3:0]; 
assign p[3:0]=a[3:0] | b[3:0]; 
assign h[1]=g[0] | (cin&p[0]);
assign h[2]=(g[1] | g[0] | (p[0]&cin));
assign h[3]=g[2] | g[1] | (g[0]&p[1]) | (p[0]&p[1]&cin);
assign h[4]=g[3] | g[2] | (g[1]&p[2]) | (g[0]&p[1]&p[2]) | (p[0]&p[1]&p[2]&cin);
assign cout=h[4] & p[3];
assign sum[0]=(p[0] ^ h[1]) | (cin & p[0] & g[0]); 
assign sum[3:1]=(p[3:1] ^ h[4:2]) | (h[3:1] & p[2:0] & g[3:1]);
endmodule


module genprop4bit( a,b,gen, prop);
input[3:0] a,b;
wire genling;
output gen,prop;
wire [3:0] g, p;
assign #2 p=a|b;
assign #2 g=a&b;
assign #4 prop= p[0]&p[1]&p[2]&p[3];
assign #7 genling= g[3]|(g[2])|(g[1]&p[2])|(g[0]&p[1]&p[2]);
assign gen= genling&p[3];
endmodule
