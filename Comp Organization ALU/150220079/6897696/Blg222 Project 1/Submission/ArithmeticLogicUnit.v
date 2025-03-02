`timescale 1ns / 1ps

module ArithmeticLogicUnit(
    input wire Clock,
    input wire [15:0] A, B,
    input wire [4:0] FunSel,
    input wire WF,
    output reg [15:0] ALUOut,
    output reg [3:0] FlagsOut
);
    wire Cin;
    reg Z, C, N, O;

    assign Cin = FlagsOut[2];
    
always @* begin
  case(FunSel)
    5'b00000: begin // A

      ALUOut[7:0] = A[7:0]; 

    end
    5'b00001: begin // B

      ALUOut[7:0] = B[7:0]; 

    end
    5'b00010: begin // ~A

      ALUOut[7:0] = ~(A[7:0]); 

    end
    5'b00011: begin // ~B

      ALUOut[7:0] = ~(B[7:0]); 

    end
    5'b00100: begin // A + B

      {C, ALUOut[7:0]} = A[7:0] + B[7:0]; 

    end
    5'b00101: begin // A + B + Cin
       
      {C, ALUOut[7:0]} = A[7:0] + B[7:0] + Cin; 

    end
    5'b00110: begin // A - B

      {C, ALUOut[7:0]} = A[7:0] - B[7:0]; 
       
    end
    5'b00111: begin // A & B

      ALUOut[7:0] = A[7:0] & B[7:0];

    end
    5'b01000: begin // A | B

      ALUOut[7:0] = A[7:0] | B[7:0];
      
    end
    5'b01001: begin // A ^ B

      ALUOut[7:0] = A[7:0] ^ B[7:0];
      
    end
    5'b01010: begin // ~(A & B)

      ALUOut[7:0] = ~(A[7:0] & B[7:0]);
       
    end
    5'b01011: begin // LSL A

      {C, ALUOut[7:0]} = A[7:0] << 1;
      
   
    end
    5'b01100: begin // LSR A

      {ALUOut[7:0], C} = A[7:0] >> 1 ;
      
    end
    5'b01101: begin // ASR A

      ALUOut[7:0] = {A[7], A[7:1]};
      
    end
    5'b01110: begin // CSL A

      C = A[7];
      ALUOut[7:0] = {A[6:0], A[7]};
      
    end
    5'b01111: begin // CSR A

      C = A[0];
      ALUOut[7:0] = {A[0], A[7:1]};
       
    end

    // 16 Bits Operations

    5'b10000: begin // A

      ALUOut = A; 

    end
    5'b10001: begin // B

      ALUOut = B; 

    end
    5'b10010: begin // ~A

      ALUOut = ~A; 

    end
    5'b10011: begin // ~B

      ALUOut = ~B; 

    end
    5'b10100: begin // A + B

      {C, ALUOut} = A + B; 

    end
    5'b10101: begin // A + B + Cin
       
      {C, ALUOut} = A + B + Cin; 

    end
    5'b10110: begin // A - B

      {C, ALUOut} = A - B; 
       
    end
    5'b10111: begin // A & B

      ALUOut = A & B;

    end
    5'b11000: begin // A | B

      ALUOut = A | B;
      
    end
    5'b11001: begin // A ^ B

      ALUOut = A ^ B;
      
    end
    5'b11010: begin // ~(A & B)

      ALUOut = ~(A & B);
       
    end
    5'b11011: begin // LSL A

      {C, ALUOut} = A << 1;
   
    end
    5'b11100: begin // LSR A

      {ALUOut ,C} = A >> 1;
      
    end
    5'b11101: begin // ASR A

      ALUOut = {A[15], A[15:1]};
      
    end
    5'b11110: begin // CSL A

      ALUOut = {A[14:0], A[15]};
      C = A[15];
      
    end
    5'b11111: begin // CSR A

      ALUOut = {A[0], A[15:1]};
      C = A[0];
       
    end
  endcase
end

always @(posedge Clock) begin

    

  if(FunSel[4] == 1'b0) begin 
    if(ALUOut[7:0] == 8'b0) Z = 1'b1;
    else Z = 1'b0;
    if(ALUOut[7] == 1'b1 && FunSel != 5'b01101) N = 1'b1;
    else N = 1'b0;

    case (FunSel)
      5'b00100: if(A[7] == B[7] && ALUOut[7] != A[7]) O = 1'b1;
                else O = 1'b0;
      5'b00101: if(A[7] == 1'b0 && B[7] == 1'b0 && Cin == 1'b1 && ALUOut[7] == 1'b1) O = 1'b1;
                else if(A[7] == 1'b1 && B[7] == 1'b1 && Cin == 1'b0 && ALUOut[7] == 1'b0) O = 1'b1;
                else O = 1'b0;
      5'b00110: if(A[7] != B[7] && ALUOut[7] != A[7]) O = 1'b1;
                else O = 1'b0;
      default: O = 1'b0;
    endcase
  end

  if(FunSel[4] == 1'b1) begin
    if(ALUOut == 16'b0) Z = 1'b1;
    else Z = 1'b0;
    if(ALUOut[15] == 1'b1 && FunSel != 5'b11101) N = 1'b1;
    else N = 1'b0;

     case (FunSel)
      5'b10100: if(A[15] == B[15] && ALUOut[15] != A[15]) O = 1'b1;
                else O = 1'b0;
      5'b10101: if(A[15] == 1'b0 && B[15] == 1'b0 && Cin == 1'b1 && ALUOut[15] == 1'b1) O = 1'b1;
                else if(A[15] == 1'b1 && B[15] == 1'b1 && Cin == 1'b0 && ALUOut[15] == 1'b0) O = 1'b1;
                else O = 1'b0;
      5'b10110: if(A[15] != B[15] && ALUOut[15] != A[15]) O = 1'b1;
                else O = 1'b0;
      default: O = 1'b0;
    endcase
  end
  if(WF) FlagsOut = {Z, C, N, O};
end

endmodule

