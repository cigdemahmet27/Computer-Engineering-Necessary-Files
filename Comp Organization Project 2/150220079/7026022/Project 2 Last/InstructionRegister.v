`timescale 1ns / 1ps

module InstructionRegister(
    input wire Clock,
    input wire LH, Write,
    input wire [7:0] I,
    output reg [15:0] IROut
);

always @(posedge Clock) begin
    if (!Write)
        IROut <= IROut;
    else begin
        case(LH)
            1'b0: IROut[7:0] <= I;
            1'b1: IROut[15:8] <= I;
        endcase
    end
end            
endmodule