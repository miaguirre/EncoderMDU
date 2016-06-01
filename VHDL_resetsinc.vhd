----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:44:45 05/20/2016 
-- Design Name: 
-- Module Name:    VHDL_resetsinc - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VHDL_resetsinc is
	Port (clk: in STD_LOGIC;
			io_resetz: in STD_LOGIC;
			int_resetz: out STD_LOGIC);
end VHDL_resetsinc;

architecture Behavioral of VHDL_resetsinc is

signal sincI, sincII : STD_LOGIC;
signal nxt_sincI, nxt_sincII : STD_LOGIC;
begin
	nxt_sincI <= '1';
	nxt_sincII <= sincI;
	int_resetz <= sincII;
sync : process(clk, io_resetz)
begin
	if (io_resetz='0') then
		sincI <='0';
		sincII <='0';
	elsif RISING_EDGE(clk)then
		sincI <= nxt_sincI;
		sincII <= nxt_sincII;
	end if;
end process sync;
end Behavioral;

