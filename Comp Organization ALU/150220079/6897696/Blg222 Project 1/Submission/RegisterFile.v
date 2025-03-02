`timescale 1ns / 1ps

module RegisterFile (
    input wire Clock,
    input wire [15:0] I,
    input wire [2:0] OutASel, OutBSel, FunSel,
    input wire [3:0] RegSel, ScrSel,
    output reg [15:0] OutA, OutB
);
    wire [15:0] Q [7:0];
    reg  E1, E2, E3, E4, E5, E6 ,E7, E8; 

Register R1 (.I(I), .E(E1), .FunSel(FunSel), .Clock(Clock), .Q(Q[0]));
Register R2 (.I(I), .E(E2), .FunSel(FunSel), .Clock(Clock), .Q(Q[1]));
Register R3 (.I(I), .E(E3), .FunSel(FunSel), .Clock(Clock), .Q(Q[2]));
Register R4 (.I(I), .E(E4), .FunSel(FunSel), .Clock(Clock), .Q(Q[3]));
Register S1 (.I(I), .E(E5), .FunSel(FunSel), .Clock(Clock), .Q(Q[4]));
Register S2 (.I(I), .E(E6), .FunSel(FunSel), .Clock(Clock), .Q(Q[5]));
Register S3 (.I(I), .E(E7), .FunSel(FunSel), .Clock(Clock), .Q(Q[6]));
Register S4 (.I(I), .E(E8), .FunSel(FunSel), .Clock(Clock), .Q(Q[7]));
  
always @* begin

    if(RegSel[3] == 0)
        E1 <= 1'b1;
    else 
        E1 <= 1'b0;

    if(RegSel[2] == 0) 
        E2 <= 1'b1;
    else 
        E2 <= 1'b0;

    if(RegSel[1] == 0) 
        E3 <= 1'b1;
    else 
        E3 <= 1'b0;

    if(RegSel[0] == 0)
        E4 <= 1'b1;
    else 
        E4 <= 1'b0;

    if(ScrSel[3] == 0)
        E5 <= 1'b1;
    else 
        E5 <= 1'b0;

    if(ScrSel[2] == 0) 
        E6 <= 1'b1;
    else 
        E6 <= 1'b0;
    
    if(ScrSel[1] == 0)
        E7 <= 1'b1;
    else 
        E7 <= 1'b0;
        
    if(ScrSel[0] == 0)
        E8 <= 1'b1;
    else 
        E8 <= 1'b0;

end
always @* begin
    case(OutASel)
        3'b000: OutA = Q[0];
        3'b001: OutA = Q[1];
        3'b010: OutA = Q[2];
        3'b011: OutA = Q[3];
        3'b100: OutA = Q[4];
        3'b101: OutA = Q[5];
        3'b110: OutA = Q[6];
        3'b111: OutA = Q[7];
    endcase
    
    case(OutBSel)
        3'b000: OutB = Q[0];
        3'b001: OutB = Q[1];
        3'b010: OutB = Q[2];
        3'b011: OutB = Q[3];
        3'b100: OutB = Q[4];
        3'b101: OutB = Q[5];
        3'b110: OutB = Q[6];
        3'b111: OutB = Q[7];
    endcase
end
endmodule