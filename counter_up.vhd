----------------------------------------------------------------------------------
-- Company: University of Sevilla	
-- Engineer: Miguel A. Aguirre	
-- 
-- Create Date:    12:31:16 11/06/2014 
-- Design Name: ARINC 429 transmitter
-- Module Name:    counter_dword - Behavioral 
-- Project Name: 
-- Target Devices:  Microsemi IGLOO2 FPGA 12K LE M2GL010T-1FGG484 
-- Tool versions: 
-- Description: Simple counter 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.std_logic_arith.all;
--use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_up is
--system clock 100 Mhz
--N size of counter, Cycle_tbit and Cycle_halfbit are the clock cycles to deteermine the bit size.
	 generic( N : integer := 8);
    Port ( clk : in  STD_LOGIC; --!System clock
           resetz : in  STD_LOGIC; --! master asynchronous reset,active low
           resets : in  STD_LOGIC; --! synchronous reset
			  up: in  STD_LOGIC; --!one count more
           value : out STD_LOGIC_VECTOR(N-1 downto 0)); --! absolute pulse counter 
end counter_up;

architecture Behavioral of counter_up is

signal count, ncount : unsigned(N-1 downto 0); --!absolute number
begin
counter: process(resets,count,up)
begin
	if (resets='1') then --! sinchronous reset
		ncount<=(others=>'0');
	elsif (up='1') then --! increment counter
		if (count >= 2**N-1) then  --! Saturation of the counter
			ncount <= count;
		else
			ncount<= count + 1 ; --! increment counter
		end if;
	else
		ncount<= count; --! remain while one count is processed
	end if;
end process counter;

value<=std_logic_vector(count);

synch: process(clk,resetz)
begin
	if(resetz='0') then
		count <= (others=>'0');
	elsif RISING_EDGE(clk)then
		count<=ncount;
	end if;
end process synch;
end Behavioral;

