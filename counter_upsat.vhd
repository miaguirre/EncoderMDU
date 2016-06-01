----------------------------------------------------------------------------------
-- Company: University of Sevilla	
-- Engineer: Miguel A. Aguirre	
-- 
-- Create Date:    12:31:16 11/06/2014 
-- Design Name: ARINC 429 transmitter
-- Module Name:    counter_dword - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

entity counter_upsat is
	 generic( N : integer := 8);
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC; --master reset
           resets : in  STD_LOGIC; --synchronous reset
			  up: in  STD_LOGIC; --one count more
           value : out STD_LOGIC_VECTOR(N-1 downto 0)
			  ); --pulse counter left and right
end counter_upsat;

architecture Behavioral of counter_upsat is

signal count, ncount : unsigned(N-1 downto 0);
begin
counter: process(resets,count,up)
begin
	if (resets='1') then
		ncount<=(others=>'0');
	elsif (up='1') then
		if(count > 2**N-2)then
			ncount<= count;
		else
			ncount<= count + 1 ;
		end if;
	else
		ncount<= count;
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

