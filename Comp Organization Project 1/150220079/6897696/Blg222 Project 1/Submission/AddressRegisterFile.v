`timescale 1ns / 1ps

module AddressRegisterFile (
  input wire Clock,
  input wire [15:0] I,
  input wire [1:0] OutCSel, OutDSel, 
  input wire [2:0] RegSel, FunSel,
  output reg [15:0] OutC, OutD
);

  reg E1, E2, E3;
  wire [15:0] Q1, Q2, Q3;

Register PC (.I(I), .E(E1), .FunSel(FunSel), .Clock(Clock), .Q(Q1));
Register AR (.I(I), .E(E2), .FunSel(FunSel), .Clock(Clock), .Q(Q2));
Register SP (.I(I), .E(E3), .FunSel(FunSel), .Clock(Clock), .Q(Q3));


always @* begin

  case(RegSel)
    3'b000: begin
      E1 <= 1'b1;
      E2 <= 1'b1;
      E3 <= 1'b1;
    end
    3'b001: begin
      E1 <= 1'b1;
      E2 <= 1'b1;
    end
    3'b010: begin
      E1 <= 1'b1;
      E3 <= 1'b1;
    end
    3'b011: E1 <= 1'b1;
    3'b100: begin
      E2 <= 1'b1;
      E3 <= 1'b1;
    end
    3'b101: E2 <= 1'b1;
    3'b110: E3 <= 1'b1;
    default: begin
        E1 <= 1'b0;
        E2 <= 1'b0;
        E3 <= 1'b0;
        end
  endcase
end

always @* begin
  case(OutCSel)
    2'b00: OutC = Q1;
    2'b01: OutC = Q1;
    2'b10: OutC = Q2;
    2'b11: OutC = Q3;
  endcase

  case(OutDSel)
    2'b00: OutD = Q1;
    2'b01: OutD = Q1;
    2'b10: OutD = Q2;
    2'b11: OutD = Q3;
  endcase
end
endmodule