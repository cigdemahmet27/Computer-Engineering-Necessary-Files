`timescale 1ns / 1ps


module ArithmeticLogicUnitSystem (
  input wire Clock,
  input wire [2:0] RF_OutASel, RF_OutBSel, RF_FunSel,
  input wire [3:0] RF_RegSel, RF_ScrSel,
  input wire [4:0] ALU_FunSel,
  input wire  ALU_WF,
  input wire [1:0] ARF_OutCSel, ARF_OutDSel,
  input wire [2:0] ARF_FunSel, ARF_RegSel,
  input wire  IR_LH, IR_Write, Mem_WR, Mem_CS,
  input wire [1:0] MuxASel, MuxBSel,
  input wire  MuxCSel,
  output wire [7:0] IROut,
  output wire [3:0] ALU_FlagsOut
);

  reg [15:0] MuxAOut;
  reg [15:0] MuxBOut;
  reg [7:0] MuxCOut;
  wire [15:0] ALUOut;
  wire [15:0] OutA;
  wire [15:0] OutB;
  wire [15:0] OutC;
  wire [15:0] Address;
  wire [7:0] MemOut;


ArithmeticLogicUnit ALU (.A(OutA), .B(OutB), .FunSel(ALU_FunSel), .WF(ALU_WF), .ALUOut(ALUOut), .FlagsOut(ALU_FlagsOut), .Clock(Clock));
AddressRegisterFile ARF (.I(MuxBOut), .OutCSel(ARF_OutCSel), .OutDSel(ARF_OutDSel), .RegSel(ARF_RegSel), .FunSel(ARF_FunSel), .OutC(OutC), .OutD(Address), .Clock(Clock));
RegisterFile RF (.I(MuxAOut), .OutASel(RF_OutASel), .OutBSel(RF_OutBSel), .FunSel(RF_FunSel), .RegSel(RF_RegSel), .ScrSel(RF_ScrSel), .OutA(OutA), .OutB(OutB), .Clock(Clock));
InstructionRegister IR (.I(MemOut), .LH(IR_LH), .Write(IR_Write), .IROut(IROut), .Clock(Clock));
Memory MEM(.Address(Address), .Data(MuxCOut), .WR(Mem_WR), .CS(Mem_CS), .MemOut(MemOut), .Clock(Clock));

always @* begin

  case(MuxASel)
    2'b00: MuxAOut = ALUOut;
    2'b01: MuxAOut = OutC;
    2'b10: MuxAOut = {8'b0, MemOut};
    2'b11: MuxAOut = {8'b0, IROut};
  endcase

  case(MuxBSel)
    2'b00: MuxBOut = ALUOut;
    2'b01: MuxBOut = OutC;
    2'b10: MuxBOut = {8'b0, MemOut};
    2'b11: MuxBOut = {8'b0, IROut};
  endcase

  case(MuxCSel)
    1'b0: MuxCOut = ALUOut[7:0];
    1'b1: MuxCOut = ALUOut[15:8];
  endcase
end



endmodule