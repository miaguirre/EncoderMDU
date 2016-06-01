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

entity counter_sat is
--system clock 100 Mhz
--N size of counter, Sat is the vakue of Saturation. when this value is reached then a pulse is then
	 generic( N : natural := 7 ;
				Sat : natural :=126);
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC; --master reset
           resets : in  STD_LOGIC; --synchronous reset
			  enable: in  STD_LOGIC; --one count more
			  Saturation : out STD_LOGIC); --pulse when time of half bit
end counter_sat;

architecture Behavioral of counter_sat is

signal count, ncount : unsigned(N-1 downto 0);

begin
Saturation <='1' when ((count = Sat) and (enable='1')) else '0';

counter: process(resets,count,enable)
begin
	if (resets='1') then
		ncount <= (others=>'0');
	else
		if (enable='1') then
			if	(count > Sat )then
				ncount  <= (others=>'0');
			else
				ncount<= count + 1 ;	
			end if;
		else
			ncount<= count;
		end if;
	end if;
end process counter;

synch: process(clk,resetz)
begin
	if(resetz='0') then
		count <= (others=>'0');
	elsif RISING_EDGE(clk)then
		count<=ncount;
	end if;
end process synch;
end Behavioral;

