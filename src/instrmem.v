module instrmem (
    input [31:0] pc_out,
    output reg [31:0] instruction
    );
    reg [31:0] memory [0:63];

    always @(*) begin
    instruction = memory[(pc_out)/4];
    end

    initial begin
        $readmemh("program.mem", memory);
    end
endmodule
