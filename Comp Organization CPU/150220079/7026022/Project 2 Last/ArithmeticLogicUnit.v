`timescale 1ns / 1ps 
module ArithmeticLogicUnit(
    input Clock,
    input WF,
    input [15:0] A,
    input [15:0] B,
    input [4:0] FunSel,
    output reg [15:0] ALUOut,
    output reg [3:0] FlagsOut
    
  );
  
   reg [16:0] AritRes; //Arithmetic Result
  

  localparam [4:0]
    SEL_A_8               = 5'b00000,
    SEL_B_8               = 5'b00001,
    SEL_NOT_A_8           = 5'b00010,
    SEL_NOT_B_8           = 5'b00011,
    SEL_A_PLUS_B_8        = 5'b00100,
    SEL_A_PLUS_B_CARRY_8  = 5'b00101,
    SEL_A_MINUS_B_8       = 5'b00110,
    SEL_A_AND_B_8         = 5'b00111,
    SEL_A_OR_B_8          = 5'b01000,
    SEL_A_XOR_B_8         = 5'b01001,
    SEL_A_NAND_B_8        = 5'b01010,
    SEL_LSL_A_8           = 5'b01011,
    SEL_LSR_A_8           = 5'b01100,
    SEL_ASR_A_8           = 5'b01101,
    SEL_CSL_A_8           = 5'b01110,
    SEL_CSR_A_8           = 5'b01111,
    SEL_A_16              = 5'b10000,
    SEL_B_16              = 5'b10001,
    SEL_NOT_A_16          = 5'b10010,
    SEL_NOT_B_16          = 5'b10011,
    SEL_A_PLUS_B_16       = 5'b10100,
    SEL_A_PLUS_B_CARRY_16 = 5'b10101,
    SEL_A_MINUS_B_16      = 5'b10110,
    SEL_A_AND_B_16        = 5'b10111,
    SEL_A_OR_B_16         = 5'b11000,
    SEL_A_XOR_B_16        = 5'b11001,
    SEL_A_NAND_B_16       = 5'b11010,
    SEL_LSL_A_16          = 5'b11011,
    SEL_LSR_A_16          = 5'b11100,
    SEL_ASR_A_16          = 5'b11101,
    SEL_CSL_A_16          = 5'b11110,
    SEL_CSR_A_16          = 5'b11111;

  always @(*) begin     // logic operatorleri direkt sonuca, aritmetikleri sign extension yapmak icin ara eleman olan AritRes e gonder
                
    case(FunSel)

      SEL_A_8:                begin AritRes <= A[7:0]; end
      SEL_B_8:                begin AritRes <= B[7:0]; end
      SEL_NOT_A_8:            begin ALUOut <= {8'b0,~(A[7:0])}; end
      SEL_NOT_B_8:            begin ALUOut <= {8'b0,~(B[7:0])}; end
      SEL_A_PLUS_B_8:         begin AritRes <= A[7:0] + B[7:0]; end
      SEL_A_PLUS_B_CARRY_8:   begin AritRes <= A[7:0] + B[7:0] + FlagsOut[2]; end
      SEL_A_MINUS_B_8:        begin AritRes <= A[7:0] + {~B[7:0]} + 1'b1; end
      SEL_A_AND_B_8:          begin ALUOut <= {8'b0,A[7:0] & B[7:0]};  end
      SEL_A_OR_B_8:           begin ALUOut <= {8'b0,A[7:0] | B[7:0]};  end
      SEL_A_XOR_B_8:          begin ALUOut <= {8'b0,A[7:0] ^ B[7:0]};  end
      SEL_A_NAND_B_8:         begin ALUOut <= {8'b0,~(A[7:0] & B[7:0])}; end
      SEL_LSL_A_8:            begin ALUOut <= {8'b0,A[6:0],1'b0};  end
      SEL_LSR_A_8:            begin ALUOut <= {8'b0,1'b0,A[7:1]};  end
      SEL_ASR_A_8:            begin AritRes <= {A[7],A[7:1]}; end
      SEL_CSL_A_8:            begin ALUOut <= {8'b0,A[6:0],A[7]}; end
      SEL_CSR_A_8:            begin ALUOut <= {8'b0,A[0],A[7:1]}; end
      SEL_A_16:               begin AritRes <= A[15:0]; end
      SEL_B_16:               begin AritRes <= B[15:0]; end
      SEL_NOT_A_16:           begin ALUOut <= ~A[15:0]; end
      SEL_NOT_B_16:           begin ALUOut <= ~B[15:0]; end
      SEL_A_PLUS_B_16:        begin AritRes <= A[15:0] + B[15:0]; end
      SEL_A_PLUS_B_CARRY_16:  begin AritRes <= A[15:0] + B[15:0] + FlagsOut[2]; end
      SEL_A_MINUS_B_16:       begin AritRes <= A[15:0] + {~B[15:0]} + 1; end
      SEL_A_AND_B_16:         begin ALUOut <= A[15:0] & B[15:0]; end
      SEL_A_OR_B_16:          begin ALUOut <= A[15:0] | B[15:0]; end
      SEL_A_XOR_B_16:         begin ALUOut <= A[15:0] ^ B[15:0];  end
      SEL_A_NAND_B_16:        begin ALUOut <= ~(A[15:0] & B[15:0]); end
      SEL_LSL_A_16:           begin ALUOut <= {A[14:0],1'b0}; end
      SEL_LSR_A_16:           begin ALUOut <= {1'b0,A[15:1]}; end
      SEL_ASR_A_16:           begin AritRes <= {A[15],A[15:1]}; end
      SEL_CSL_A_16:           begin ALUOut <= {A[14:0],FlagsOut[2]};  end
      SEL_CSR_A_16:           begin ALUOut <= {FlagsOut[2],A[15:1]};  end

    endcase

  end
  
  always @(AritRes) begin
    
    if(!FunSel[4]) begin
      ALUOut <= {8'd0, AritRes[7:0]};
    end else begin
      ALUOut <= AritRes[15:0];
    end
    
  end


  always @(posedge Clock) begin  // posedge Clock ve WF 1 oldugunda gerekli flag atamalarini yap
    if(WF == 1) begin
    case(FunSel)

      SEL_A_8:   begin
        FlagsOut[3] <= AritRes[7:0] == 8'b00000000;
        FlagsOut[1] <= AritRes[7];
      end

      SEL_B_8:  begin
        FlagsOut[3] <= AritRes[7:0] == 8'b00000000;
        FlagsOut[1] <= AritRes[7];
      end

      SEL_NOT_A_8: begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_NOT_B_8:  begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[1] <= ALUOut[7];
      end
        // negatiflikte overflowu dikkate almiyoruz yani FlagsOut[1] de
      SEL_A_PLUS_B_8: begin
        FlagsOut[3] <= AritRes[7:0] == 8'b00000000;
        FlagsOut[2] <= AritRes[8];
        FlagsOut[1] <= AritRes[7];
        FlagsOut[0] <= (A[7] == B[7]) && (A[7] != AritRes[7]);
      end

      SEL_A_PLUS_B_CARRY_8: begin
        FlagsOut[3] <= AritRes[7:0] == 8'b00000000;
        FlagsOut[2] <= AritRes[8];
        FlagsOut[1] <= AritRes[7];
        FlagsOut[0] <= (A[7] == B[7]) & (A[7] != AritRes[7]);
      end
        // carry nin not ini almadik - hocaya gore almamamiz gerek
      SEL_A_MINUS_B_8: begin
        FlagsOut[3] <= AritRes[7:0] == 8'b00000000;
        FlagsOut[2] <= !AritRes[8];
        FlagsOut[1] <= AritRes[7];
        FlagsOut[0] <= (A[7] == !B[7]) & (B[7] == AritRes[7]);
      end

      SEL_A_AND_B_8: begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_A_OR_B_8:  begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_A_XOR_B_8: begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_A_NAND_B_8: begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_LSL_A_8: begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[2] <= A[7];
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_LSR_A_8: begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[2] <= A[0];
        FlagsOut[1] <= 1'b0;
      end

      SEL_ASR_A_8:  begin
        FlagsOut[3] <= AritRes[7:0] == 8'b00000000;
        FlagsOut[2] <= A[0];
      end

      SEL_CSL_A_8:  begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[2] <= A[7];
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_CSR_A_8:   begin
        FlagsOut[3] <= ALUOut[7:0] == 8'b00000000;
        FlagsOut[2] <= A[0];
        FlagsOut[1] <= ALUOut[7];
      end

      SEL_A_16:    begin
        FlagsOut[3] <= AritRes[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= AritRes[15];
      end

      SEL_B_16:     begin
        FlagsOut[3] <= AritRes[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= AritRes[15];
      end

      SEL_NOT_A_16:  begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= ALUOut[15];
      end

      SEL_NOT_B_16:  begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= ALUOut[15];
      end


      SEL_A_PLUS_B_16:  begin
        FlagsOut[3] <= AritRes[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= AritRes[16];
        FlagsOut[1] <= AritRes[15];
        FlagsOut[0] <= (A[15] == B[15]) && (A[15] != AritRes[15]);
      end

      SEL_A_PLUS_B_CARRY_16: begin
        FlagsOut[3] <= AritRes[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= AritRes[16];
        FlagsOut[1] <= AritRes[15];
        FlagsOut[0] <= (A[15] == B[15]) && (A[15] != AritRes[15]);
      end

      SEL_A_MINUS_B_16: begin
        FlagsOut[3] <= AritRes[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= !AritRes[16];
        FlagsOut[1] <= AritRes[15];
        FlagsOut[0] <= (A[15] == !B[15]) && (B[15] == AritRes[15]);
      end

      SEL_A_AND_B_16: begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= ALUOut[15];
      end

      SEL_A_OR_B_16:   begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= ALUOut[15];
      end

      SEL_A_XOR_B_16: begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= ALUOut[15];
      end

      SEL_A_NAND_B_16: begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[1] <= ALUOut[15];           
      end

      SEL_LSL_A_16:  begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= A[15];
        FlagsOut[1] <= ALUOut[15];
      end

      SEL_LSR_A_16:  begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= A[0];
        FlagsOut[1] <= 1'b0;
      end

      SEL_ASR_A_16:  begin
        FlagsOut[3] <= AritRes[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= A[0];
      end

      SEL_CSL_A_16:  begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= A[0];
        FlagsOut[1] <= ALUOut[15];
      end

      SEL_CSR_A_16:   begin
        FlagsOut[3] <= ALUOut[15:0] == 16'b0000000000000000;
        FlagsOut[2] <= A[15];
        FlagsOut[1] <= ALUOut[15];
      end

    endcase
    end else begin 
        FlagsOut[3] <= FlagsOut[3];
        FlagsOut[2] <= FlagsOut[2];
        FlagsOut[1] <= FlagsOut[1];
        FlagsOut[0] <= FlagsOut[0];
    end

  end


endmodule
