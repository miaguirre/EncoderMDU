----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:53:42 11/14/2014 
-- Design Name: 
-- Module Name:    tb_arinc429_tx - Behavioral 
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
--use ieee.std_logic_misc.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_arinc429_tx is
end tb_arinc429_tx;

architecture Behavioral of tb_arinc429_tx is
component arinc429_tx
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC;
           start_tx : in  STD_LOGIC;
           message0 : in  STD_LOGIC_VECTOR (31 downto 0);
           message1 : in  STD_LOGIC_VECTOR (31 downto 0);
           message2 : in  STD_LOGIC_VECTOR (31 downto 0);
           line_p : out  STD_LOGIC;
           line_n : out  STD_LOGIC);
end component;

signal clk: STD_LOGIC:='1';
signal resetz, start_tx, line_p, line_n: STD_LOGIC;
signal message: STD_LOGIC_VECTOR (31 downto 0);
begin

uut: arinc429_tx
    Port Map( clk=>clk,
           resetz =>resetz,
           start_tx =>start_tx,
           message0 =>message, 
           message1 =>message, 
           message2 =>message, 
           line_p =>line_p,
           line_n =>line_n);

message <="11001100111100001010101001010101";
resetz <= '0', '1' after 95 ns;
start_tx <= '0', '1' after 100 ns, '0' after 135 ns, '1' after 24000 ns, '0' after 24045 ns, '1' after 27000 ns, '0' after 27045 ns;
-- clock generation
clkgen : process
begin
		loop
				wait for 10 ns;
				clk<=not clk;
		end loop;
end process clkgen;


end Behavioral;

