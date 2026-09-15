module imgen (
    input [31:0] instruction,
    output reg [31:0] imm_out
);

    integer i;
    always @(*) begin
        if (instruction[6:0] == 7'b0000011 || instruction[6:0] == 7'b0010011) begin
        imm_out = {{20{instruction[31]}}, instruction[31:20]};
        end
        else if (instruction[6:0] == 7'b0100011) begin
        imm_out = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
        end
        else if (instruction[6:0] == 7'b1100011) begin
        imm_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
        end
        else begin
            imm_out[31:0] = 32'b0;
        end
    end 
endmodule