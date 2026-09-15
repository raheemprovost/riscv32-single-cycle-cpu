`timescale 1ns / 1ps  // Defines the time units (1 nanosecond steps)

module tb_main();

    // 1. Create wires to connect to the CPU
    reg clk;
    reg reset;

    // 2. Instantiate your CPU (The "Device Under Test")
    main dut (
        .cpu_clk(clk),
        .cpu_reset(reset)
    );

    // 3. Generate the Clock Signal (Heartbeat)
    // This flips the clock every 5ns, creating a 10ns period (100MHz)
    always #5 clk = ~clk;

    initial begin
        // --- PREPARE GTKWAVE ---
        $dumpfile("cpu_test.vcd"); // The file GTKWave will open
        $dumpvars(0, tb_main);     // Record every wire inside the testbench and CPU

        // --- INITIALIZE SIGNALS ---
        clk = 0;
        reset = 1;      // Start with Reset ON

        // --- RESET SEQUENCE ---
        #15;            // Wait 15ns
        reset = 0;      // Turn Reset OFF - CPU starts "thinking" now

        // --- RUN SIMULATION ---
        #500;           // Let the CPU run for 500ns
        
        $display("Simulation Finished!");
        $finish;        // Stop the simulation
    end

endmodule