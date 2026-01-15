module tb_top;

reg clk;
reg rst_n;
reg valid;
reg ready;
always #5 clk=~clk;
wire [7:0] queue_level;
wire       congestion;
wire       backpressure;

initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, tb_top);
end

initial begin
	clk=0;
	rst_n=0;
	
	#50;
	rst_n=1;
	#5000;
	$finish;
end
initial begin
    valid = 0;
    #100;
    forever begin
        valid = 1;
        #20;
        valid = 0;
        #30;
    end
end
initial begin
    ready = 0;
    #200;
    forever begin
        ready = 1;
        #10;
        ready = 0;
        #90;
    end
end

always @(posedge clk) begin
    if (rst_n) begin
        if (congestion && !backpressure) begin
            $display("ASSERTION FAILED at time %0t: congestion without backpressure", $time);
            $stop;
        end
    end
end

endmodule

