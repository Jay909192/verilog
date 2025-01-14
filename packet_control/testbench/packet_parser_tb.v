module packet_parser_tb();
reg clk;
reg rst;
reg data_valid;
reg [31:0] packet_data_in;
reg start_of_packet;
reg end_of_packet;
wire packet_valid_flag;
wire [3:0] packet_valid_counter;
wire packet_error_flag;
wire [3:0] packet_error_counter;

packet_parser dut(
.clk (clk),
.rst (rst),
.data_valid (data_valid ),
.packet_data_in (packet_data_in),
.start_of_packet (start_of_packet),
.end_of_packet (end_of_packet),
.packet_valid_flag (packet_valid_flag),
.packet_valid_counter (packet_valid_counter),
.packet_error_flag (packet_error_flag),
.packet_error_counter (packet_error_counter)
);


initial 
begin
   clk = 0;
   forever 
   begin
    #5  clk = ~clk;
   end
end 

initial 
begin
rst = 0;
#15 rst = 1;
end

initial
begin 
   data_valid <= 0 ;
   packet_data_in <= 0;
   start_of_packet <= 0;
   end_of_packet <= 0;
   #15  data_valid  <=  1;
   start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #30 end_of_packet <= 1;
   #10 end_of_packet <= 0;

   start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #20 data_valid  <= 0;
   #20 data_valid  <= 1;
   #10 end_of_packet <= 1;
   #10 end_of_packet <= 0;

   start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #30 end_of_packet <= 1;
   #10 end_of_packet <= 0;

   #10 start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #30 end_of_packet <= 1;
   #10 end_of_packet <= 0;

   #20 start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #30 end_of_packet <= 1;
   #10 end_of_packet <= 0;

   start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #100 end_of_packet <= 1;
   #10 end_of_packet <= 0;


   start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #120 end_of_packet <= 1;
   #10 end_of_packet <= 0;

   start_of_packet <= 1;
   #10 start_of_packet <= 0;
   #30 end_of_packet <= 1;
   #10 end_of_packet <= 0;

   #10 start_of_packet <= 1;
   #50 end_of_packet <= 1;

#200 $finish;

end 

initial 
begin
   $dumpfile("packet_parser.vcd");
   $dumpvars(0,packet_parser_tb);
end 

endmodule 
