module alu (
    input [31:0] A,
    input [31:0] B,
    input [3:0] op,
    output reg [31:0] C,
    output zeroflag
);
    always @(*) begin
        if (op == 4'b0000) 
            C = A & B;  // and
        else if (op == 4'b0001) 
            C = A | B; // or
        else if (op == 4'b0010) 
            C = A + B;    // add
        else if (op == 4'b0110) 
            C = A - B ;    // subtract
        else if (op == 4'b0111) 
            C = A < B; // set less than 
        else if (op == 4'b0100) 
            C = A ^ B; // xor
        else if (op == 4'b1000) 
            C = A >> B; // shift right logical
        else if (op == 4'b1001) 
            C = A << B; // shift left logical
        else 
            C = 32'b0;
    end
    assign zeroflag = (C == 1'b0);
endmodule