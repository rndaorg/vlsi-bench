// dff_tb.v
`timescale 1ns / 1ps

module dff_tb;

    reg clk;
    reg rst_n;
    reg d;
    wire q;

    // Instantiate DFF
    dff uut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q)
    );


    // Clock generator (10 ns period = 100 MHz)
    always begin
        #5 clk = ~clk;  // 5 ns half-period
    end

    initial begin
        // Initialize
        clk = 0;
        rst_n = 0;
        d = 0;

        // Release reset
        #15 rst_n = 1;

        // ---- 1. Correct operation ----
        #10 d = 1;          // Change D at t=25 ns
        #20 d = 0;          // Next change at t=45 ns (well before clk@50ns)

        // ---- 2. Setup time violation ----
        // Clock edges at: 10, 20, 30, 40, 50, 60, 70, ...
        // Next clock at t=70 ns → D must be stable by t=69 ns (t_su=1ns)
        #15 d = 1;          // Change D at t=60 ns → OK
        #8.5 d = 0;         // Change D at t=68.5 ns → VIOLATION! (only 1.5 ns before clk)
        #1.0 d = 1;         // Change at t=69.5 ns → even worse (0.5 ns before clk)

        // ---- 3. Hold time violation ----
        // After clk@70ns, D must stay stable until t=70.5 ns
        #0.3 d = 0;         // Change at t=69.8 ns → still before clk → OK
        // Now wait for clk@80ns
        #10.2;              // Advance to t=80.0 ns (clk posedge)
        #0.3 d = 1;         // Change at t=80.3 ns → VIOLATION! (only 0.3 ns after)

        // Finish
        #20 $finish;
    end

    // Optional: dump waveforms
    initial begin
        $dumpfile("dff.vcd");
        $dumpvars(0, dff_tb);
    end

endmodule