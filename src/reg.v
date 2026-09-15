module regfile (
    input clk,
    input reg_write,
    input reset,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);
    integer i;
    reg [31:0] registers [0:31];
    always @(posedge clk) begin
        if (reset) begin
            // What happens when you reboot?
            for (i = 0; i < 32; i++) begin
                registers[i] <= 32'b0;
            end
        end
        else begin
            // What happens on every normal beat?
            if (rd != 5'b0 && reg_write) 
            registers [rd] <= write_data;
        end
    end
    always @(*) begin
        read_data1 = registers[rs1];
        read_data2 = registers[rs2];
    end
endmodule


