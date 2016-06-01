----------------------------------------------------------------------------------
-- Company: Universidad de Sevilla
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date:    13:30:39 05/14/2016 
-- Design Name: edge_detection
-- Module Name:    edge_detector - Behavioral 
-- Project Name: 
-- Target Devices: Any
-- Tool versions: 
-- Description: Detect rising or falling edge to measure the activity of the digital input
--
-- Dependencies: 
--
-- Revision: 1.0
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity edge_detector is
    Port ( clk : in  STD_LOGIC; --!clock signal
           resetz : in  STD_LOGIC; --!reset signal, active low
           Inp_line : in  STD_LOGIC; --!Input signal, detect the edge, rising or faling edgr.
           Pulse_edge : out  STD_LOGIC); --!Pulse after edge detection
end edge_detector;

architecture Behavioral of edge_detector is
signal line1, line2 : STD_LOGIC;
begin

edge_detection: Pulse_edge <= line1 xor line2; --!Edge detection

sync: process(resetz,clk) --!Synchroneous process
begin
	if(resetz='0')then
		line1 <='0';
		line2 <='0';
	elsif RISING_EDGE(clk) then
		line1<=Inp_line;
		line2<=line1;
	end if;
end process sync;

end Behavioral;

