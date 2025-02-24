`timescale 1ns / 1ps


module ControlUnit(

    input [7:0] Tx,
    input [3:0] ALU_FlagsOut,
    input [15:0] IROut,
    output [2:0] RF_OutASel, RF_OutBSel, RF_FunSel,
    output [3:0] RF_RegSel, RF_ScrSel,
    output [4:0] ALU_FunSel,
    output ALU_WF,
    output [1:0] ARF_OutCSel, ARF_OutDSel,
    output [2:0] ARF_FunSel, ARF_RegSel,
    output [1:0] MuxASel, MuxBSel,
    output MuxCSel,
    output Mem_CS, Mem_WR,
    output IR_LH, IR_Write,
    output Reset

    );
    
    reg [7:0] T;
    reg [63:0] D;
    reg [2:0] SREG1, SREG2;
    reg [3:0] DSTREG;
    reg [3:0] RREG;
    reg [1:0] RSEL;
    reg S;

    always @ (Tx) begin
        T = 8'd0;
        T = Tx;
    end
    
    

    always @ (posedge T[2]) begin
        #0.1;
        D = 64'd0;
        D[IROut[15:10]] = 1;
        S = IROut[9];       
        RSEL = IROut[9:8];
        
        case (IROut[5:3])

            3'd0: SREG1 = IROut[4:3];
            3'd1: SREG1 = IROut[4:3]; 
            3'd2: SREG1 = 2'b11;
            3'd3: SREG1 = 2'b10;
            3'd4: SREG1 = IROut[4:3];
            3'd5: SREG1 = IROut[4:3];
            3'd6: SREG1 = IROut[4:3];
            3'd7: SREG1 = IROut[4:3];

        endcase

        case (IROut[2:0])

            3'd0: SREG2 = IROut[1:0];
            3'd1: SREG2 = IROut[1:0]; 
            3'd2: SREG2 = 2'b11;
            3'd3: SREG2 = 2'b10;
            3'd4: SREG2 = IROut[1:0];
            3'd5: SREG2 = IROut[1:0];
            3'd6: SREG2 = IROut[1:0];
            3'd7: SREG2 = IROut[1:0];

        endcase

        case (IROut[8:6])

            3'd0: DSTREG = 4'b0011;
            3'd1: DSTREG = 4'b0011;
            3'd2: DSTREG = 4'b0110;
            3'd3: DSTREG = 4'b0101;
            3'd4: DSTREG = 4'b0111;
            3'd5: DSTREG = 4'b1011;
            3'd6: DSTREG = 4'b1101;
            3'd7: DSTREG = 4'b1110;

        endcase

        case (IROut[9:8])

            2'd0: RREG = 4'b0111;
            2'd1: RREG = 4'b1011;
            2'd2: RREG = 4'b1101;
            2'd3: RREG = 4'b1110;

        endcase

        S = IROut[9];       
        RSEL = IROut[9:8];  
    end


    assign IR_Write = T[0] | T[1];
    assign IR_LH = T[1];
    
    assign RF_OutASel = 
    ( T[3] & ((D[5] | D[6] | D[24]) & IROut[5] | D[7] | D[8] | D[9] | D[10] | D[11] | D[12] | D[13] | D[14] | D[15] | D[16] | D[21] | D[22] | D[23] | D[25] | D[26] | D[27] | D[28] | D[29])) ? SREG1 :
    (T[4] & (D[4] | D[19]) | T[3] & (D[19]) | T[6] & (D[30] | D[33]) | T[7] & D[33] | T[5] & D[4]) ? RSEL :
    (T[5] & ((D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) | D[30] | D[33]) | T[4] & (D[30])) ? 3'b100 : 3'bx;

    assign RF_OutBSel = 
    (T[3] & (D[12] | D[13] | D[15] | D[16] | D[21] | D[22] | D[23] | D[25] | D[26] | D[27] | D[28] | D[29])) ? SREG2 : 
    (T[5] & (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3] | D[33])) ? 3'b101 : 3'bx;

    assign RF_RegSel = 
    (T[3] & ((D[5] | D[6] | D[17] | D[20] | D[24]) & IROut[8] | D[7] | D[8] | D[9] | D[10] | D[11] | D[12] | D[13] | D[14] | D[15] | D[16] | D[21] | D[22] | D[23] | D[25] | D[26] | D[27] | D[28] | D[29]) | T[4] & IROut[8] & (D[5] | D[6])) ? DSTREG : 
    (T[3] & (D[3] | D[32]) | T[4] & (D[3] | D[18]) | T[3] & D[18]) ? RREG : 4'b1111;

    assign RF_ScrSel = 
    (T[3] & ((D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) | D[30] | D[33])) ? 4'b0111 : (T[4] & (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3] | D[33])) ? 4'b1011 : 4'b1111;
     
    assign RF_FunSel = 
    (T[3] & ( D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3] | D[5] & IROut[8] | D[6] & IROut[8] | D[7] | D[8] | D[9] | D[10] | D[11] | D[12] | D[13] | D[14] | D[15] | D[16] | D[21] | D[22] | D[23] | D[24] & IROut[8] | D[25] | D[26] | D[27] | D[28] | D[29] | D[30] | D[33])) ? 3'b010 : 
    (T[3] & D[3] | T[4] & D[3] | T[3] & D[17] & IROut[8] | T[4] & D[18]) ? 3'b110 : 
    (T[3] & (D[18] | D[20] & IROut[8]) ) ? 3'b101 : 
    (T[3] & (D[32]) | T[4] & D[33]) ? 3'b100 : 
    (D[5] & T[4] & IROut[8]) ? 3'b001 : 
    (D[6] & T[4] & IROut[8]) ? 3'b000 : 
    (T[4] & (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3])) ? 3'b111 : 3'bx; 

    assign ARF_OutCSel = 
    (T[3] & ~(IROut[5]) & (D[5] | D[6] | D[24])) ? SREG1 : 
    (T[3] & ((D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) | D[30])) ? 2'b00 : 
    (D[33] & T[3]) ? 2'b10 : 2'bx;

    assign ARF_OutDSel = 
    (T[3] & (D[3] | D[31]) | T[4] & (D[3] | D[30] | D[4]) | T[5] & (D[30] | D[31] | D[4])) ? 2'b11 : 
    (T[3] & (D[18] | D[19]) | T[4] & ((D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) | D[18] | D[19]) | D[33] & (T[6] | T[7])) ? 2'b10 : 
    (T[0] | T[1]) ? 2'b00 : 2'bx;

    assign ARF_RegSel = 
    (~(IROut[8]) & T[3] & (D[5] | D[6] | D[17] | D[20] | D[24]) | ~(IROut[8]) & T[4] & (D[5] | D[6])) ? DSTREG : 
    (T[0] | T[1] | (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) & T[5] | D[30] & T[6] | D[31] & (T[3] | T[5])) ? 3'b011 : 
    (T[2] & (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3] | D[18] | D[19] | D[32]) | T[3] & (D[18] | D[19]) | (T[6] | T[5]) & D[33]) ? 3'b101 : 
    (T[3] & (D[3] | D[4]) | T[4] & (D[4] | D[30] | D[31])) ? 3'b110 : 3'b111; 


    assign ARF_FunSel = 
    (T[3] & (~IROut[8] & (D[5] | D[6] | D[24]) | D[31]) | T[5] & (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3] | D[33]) | T[6] & D[30]) ? 3'b010 : 
    (T[0] | T[1] | T[3] & (D[3] | D[18] | D[19]) | T[4] &(D[5] & ~IROut[8] | D[30] | D[31]) | T[6] & D[33]) ? 3'b001 : 
    (D[4] & (T[3] | T[4]) | D[6] & T[4] & ~IROut[8]) ? 3'b000 : 
    (D[20] & T[3] &  ~IROut[8]) ? 3'b101 : 
    (D[17] & T[3] & ~IROut[8] | D[31] & T[5]) ? 3'b110 : 
    (T[2] & (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3] | D[18] | D[19] | D[32]) | T[3] & (D[19])) ? 3'b100 : 3'bx;  

    assign Mem_CS = 
    ~(T[0] | T[1] | D[3] & (T[3] | T[4]) | D[4] & (T[4] | T[5]) | D[18] & (T[3] | T[4]) | D[19] & (T[3] | T[4]) | D[30] & (T[4] | T[5]) | D[31] & (T[3] | T[5]) | D[33] & (T[6] | T[7]));

    assign Mem_WR = 
    ~(T[0] | T[1] | D[3] & (T[3] | T[4] ) | D[18] & (T[3] | T[4] ) | D[31] & (T[3] | T[5]));


    assign ALU_FunSel = 
    (T[3] | T[4]) & (D[4] | D[19]) | T[3] & IROut[5] & (D[5] & D[6] & D[24]) | D[30] & (T[4] | T[5] | T[6]) | D[33] & (T[6] | T[7]) ? 5'b10000 : 
    (D[14]) ? 5'b10010 : 
    ((D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) | D[21] | D[25] | D[33] & T[5]) ? 5'b10100 : 
    D[22] ? 5'b10101 : 
    D[23] | D[26] ? 5'b10110 : 
    D[12] | D[27] ? 5'b10111 : 
    (D[13] | D[28]) ? 5'b11000 :  
    (D[15] | D[29]) ? 5'b11001 : 
    (D[16]) ? 5'b11010 : 
    (D[7]) ? 5'b11011 : 
    (D[8]) ? 5'b11100 : 
    (D[9]) ? 5'b11101 : 
    (D[10]) ? 5'b11110 : 
    (D[11]) ? 5'b11111 : 5'b10000;

    assign ALU_WF = 
    (D[24] | D[25] | D[26] | D[27] | D[28] | D[29]) ? S : 1'b0;

    assign MuxASel = 
    (T[3] & (D[5] & (IROut[8] & IROut[5]) | D[6] & (IROut[8] & IROut[5]) | D[7] | D[8] | D[9] | D[10] | D[11] | D[12] | D[13] | D[16] | D[15] | D[14] | D[24] & (IROut[8] & IROut[5]) | D[21] | D[22] | D[23] | D[25] | D[26] | D[27] | D[28] | D[29])) ? 2'b00 : 
    (T[3] & (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3] | D[5] & (IROut[8] & ~(IROut[5])) | D[6] & (IROut[8] & ~(IROut[5])) | D[24] & (IROut[8] & ~(IROut[5])) | D[30] | D[33])) ? 2'b01 : 
    (D[3] & (T[3] | T[4]) | D[18] & (T[3] | T[4])) ? 2'b10 : 
    (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) & T[4] | T[3] & D[32] | T[4] & D[33] | D[17] & T[3] | D[20] & T[3] ? 2'b11 : 2'bx;

    assign MuxBSel = 
    (T[3] & (D[5] & (~(IROut[8]) & IROut[5]) | D[6] & (~(IROut[8]) & IROut[5]) | D[24] & (~(IROut[8]) & IROut[5])) | D[30] & T[6] | D[33] & T[5] | (D[0] | D[1] & ~ALU_FlagsOut[3] | D[2] & ALU_FlagsOut[3]) & T[5]) ? 2'b00 : 
    (T[3] & (D[5] & (IROut[8] & ~(IROut[5])) | D[6] & (IROut[8] & ~(IROut[5])) | D[24] & (IROut[8] & ~(IROut[5])))) ? 2'b01 : 
    (D[31] & (T[3] | T[5])) ? 2'b10 : 2'b11;

    assign MuxCSel = 
    (D[4] & T[4] | D[19] & T[4] | D[30] & T[5] | T[7] & D[33]) ? 1'b1 : 1'b0;

    assign Reset = 
    (T[3] & (D[7] | D[8] | D[9] | D[10] | D[11] | D[12] | D[13] | D[14] | D[15] | D[16] | D[17] | D[20] | D[21] | D[22] | D[23] | D[24] | D[25] | D[26] | D[27] | D[28] | D[29] | D[32]) | T[4] & (D[3]  | D[5] | D[6] | D[18] | D[19]) | T[5] & (D[0] | D[1] | D[2] | D[31] | D[4]) | T[6] & (D[30]) | T[7] & D[33]) ? 1'b1 : 1'b0; 

endmodule




module CPUSystem (
  input wire Clock, Reset,
  output reg [7:0] T
);
    reg [2:0] SC;
    wire Reset2;
always @ (posedge Clock) begin
        if (Reset2)
            SC <= 3'd0;
        else
            SC <= SC + 1;
    end
    
always @ (posedge Reset) begin
    SC <= 3'b0;
    
end

always @ (negedge Reset) begin
    _ALUSystem.RF.S1.Q <= 16'd0;
    _ALUSystem.RF.S2.Q <= 16'd0;
    _ALUSystem.RF.S3.Q <= 16'd0;
    _ALUSystem.RF.S4.Q <= 16'd0;
    _ALUSystem.ARF.SP.Q <= 16'd255;
    
    
    
    if(_ALUSystem.ARF.PC.Q === 16'dx) 
        _ALUSystem.ARF.PC.Q <= 16'b0;
    else 
        _ALUSystem.ARF.PC.Q <= _ALUSystem.ARF.PC.Q;

    if(_ALUSystem.RF.R1.Q === 16'dx) 
        _ALUSystem.RF.R1.Q <= 16'h0;
    else 
        _ALUSystem.RF.R1.Q <= _ALUSystem.RF.R1.Q;

    if(_ALUSystem.RF.R2.Q === 16'dx) 
        _ALUSystem.RF.R2.Q <= 16'd0;
    else 
        _ALUSystem.RF.R2.Q <= _ALUSystem.RF.R2.Q;

    if(_ALUSystem.RF.R3.Q === 16'dx) 
        _ALUSystem.RF.R3.Q <= 16'b0;
    else 
        _ALUSystem.RF.R3.Q <= _ALUSystem.RF.R3.Q;

    if(_ALUSystem.RF.R4.Q === 16'dx) 
        _ALUSystem.RF.R4.Q <= 16'b0;
    else 
        _ALUSystem.RF.R4.Q <= _ALUSystem.RF.R4.Q;
            
end

always @ (SC) begin
    T[7:0] <= 7'b0;
    T[SC] <= 1;
end
    
    wire [3:0] ALU_FlagsOut;
    wire [15:0] IROut;
    wire [2:0] RF_OutASel, RF_OutBSel, RF_FunSel;
    wire [3:0] RF_RegSel, RF_ScrSel;
    wire [4:0] ALU_FunSel;
    wire ALU_WF;
    wire [1:0] ARF_OutCSel, ARF_OutDSel;
    wire [2:0] ARF_FunSel, ARF_RegSel;
    wire [1:0] MuxASel, MuxBSel;
    wire MuxCSel;
    wire Mem_CS, Mem_WR;
    wire IR_LH, IR_Write;
    

    ArithmeticLogicUnitSystem _ALUSystem(
        .RF_OutASel(RF_OutASel), 
        .RF_OutBSel(RF_OutBSel), 
        .RF_FunSel(RF_FunSel),
        .RF_RegSel(RF_RegSel),
        .RF_ScrSel(RF_ScrSel),
        .ALU_FunSel(ALU_FunSel),
        .ALU_WF(ALU_WF),
        .ARF_OutCSel(ARF_OutCSel), 
        .ARF_OutDSel(ARF_OutDSel), 
        .ARF_FunSel(ARF_FunSel),
        .ARF_RegSel(ARF_RegSel),
        .IR_LH(IR_LH),
        .IR_Write(IR_Write),
        .Mem_WR(Mem_WR),
        .Mem_CS(Mem_CS),
        .MuxASel(MuxASel),
        .MuxBSel(MuxBSel),
        .MuxCSel(MuxCSel),
        .Clock(Clock),
        .IROut(IROut),
        .ALU_FlagsOut(ALU_FlagsOut)
        );

    ControlUnit CU(
        .Tx(T),
        .RF_OutASel(RF_OutASel), 
        .RF_OutBSel(RF_OutBSel), 
        .RF_FunSel(RF_FunSel),
        .RF_RegSel(RF_RegSel),
        .RF_ScrSel(RF_ScrSel),
        .ALU_FunSel(ALU_FunSel),
        .ALU_WF(ALU_WF),
        .ARF_OutCSel(ARF_OutCSel), 
        .ARF_OutDSel(ARF_OutDSel), 
        .ARF_FunSel(ARF_FunSel),
        .ARF_RegSel(ARF_RegSel),
        .IR_LH(IR_LH),
        .IR_Write(IR_Write),
        .Mem_WR(Mem_WR),
        .Mem_CS(Mem_CS),
        .MuxASel(MuxASel),
        .MuxBSel(MuxBSel),
        .MuxCSel(MuxCSel),
        .IROut(IROut),
        .ALU_FlagsOut(ALU_FlagsOut),
        .Reset(Reset2)
        );
   
endmodule


