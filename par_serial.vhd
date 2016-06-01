----------------------------------------------------------------------------------
-- Company: University of Sevilla	
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date:    10:37:11 11/14/2014 
-- Design Name: 	ARIC 429 Transmitter
-- Module Name:    par_serial - Behavioral 
-- Project Name: 
-- Target Devices: Any
-- Tool versions: 
-- Description: Convert from parallel to serial bit order. Load parallell word and enable serial output, sychonous resset initialize the state of the block
-- 
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: Shift register. Message is converted from parallel to serial. Less significant bit is serilized.
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

entity par_serial is

	generic( N : integer := 32);
    Port ( clk : in  STD_LOGIC; --! system clock
           resetz : in  STD_LOGIC; --! system asynchonous reset, active low
           resets : in  STD_LOGIC; --! synchronous reset
           ena_serial : in  STD_LOGIC; --! enable the shifting of the word
           loadpar : in  STD_LOGIC; --! load the parallel input 
           parallel_word : in  STD_LOGIC_VECTOR(N-1 downto 0); --! parallel input of size N
           serial_bit : out  STD_LOGIC); --! LSB of the word
end par_serial;

architecture Behavioral of par_serial is

signal reg, preg : STD_LOGIC_VECTOR(N-1 downto 0);

begin
shift_reg: process(resets,reg,loadpar,ena_serial,parallel_word)
begin
	if (resets='1') then
		preg<=(others=>'0');
	elsif (loadpar='1') then 
		preg <= parallel_word;
	elsif (ena_serial='1') then
		preg (N-2 downto 0) <= reg (N-1 downto 1);
		preg (N-1) <= reg (0);
	else
		preg<= reg;
	end if;
end process shift_reg;

synch: process(clk,resetz)
begin
	if(resetz='0') then
		reg <= (others=>'0');
	elsif RISING_EDGE(clk) then
		reg<=preg;
	end if;
end process synch;

serial_bit<=reg(0);

end Behavioral;

