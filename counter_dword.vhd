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
-- Description: Simple couter, with a saturation signal the is asserted if value is 4 and the saturation is 
--   reached in 2**N-1
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

entity counter_dword is
--! system clock 100 Mhz
--! N size of counter, Cycle_tbit and Cycle_halfbit are the clock cycles to deteermine the bit size.
	 generic( N : integer := 5);
    Port ( clk : in  STD_LOGIC; --! clock signal
           resetz : in  STD_LOGIC; --! master asynchonous reset, active los
           resets : in  STD_LOGIC; --! synchronous reset, active high
			  enable: in  STD_LOGIC; --! enable the counter
			  saturation4 : out STD_LOGIC; --! pulse in value 4
           saturationN : out STD_LOGIC); --! pulse when the time is 2**N-1, half bit
end counter_dword;

architecture Behavioral of counter_dword is

signal count, ncount : unsigned(N-1 downto 0);
signal dword, four : unsigned(N-1 downto 0);
begin
counter: process(resets,count,enable)
begin
	if (resets='1') then
		ncount<=(others=>'0');
	elsif (enable='1') then
		ncount<= count + 1 ;	
	else
		ncount<= count;
	end if;
end process counter;


dword <=(others=>'1');
four<=to_unsigned(4, N); --! four parametrized to N bits
selector1: saturationN<='1' when (count=dword)  else '0';
selector2: saturation4<='1' when (count=four)  else '0';

synch: process(clk,resetz)
begin
	if(resetz='0') then
		count <= (others=>'0');
	elsif RISING_EDGE(clk)then
		count<=ncount;
	end if;
end process synch;
end Behavioral;

