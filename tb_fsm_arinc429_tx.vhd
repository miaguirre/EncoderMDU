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

entity tb_fsm_arinc429_tx is
end tb_fsm_arinc429_tx;

architecture Behavioral of tb_fsm_arinc429_tx is
component fsm_arinc429_tx is
    Port ( clk : in  STD_LOGIC; --system  clock
           resetz : in  STD_LOGIC; --system reset
           start_trx : in  STD_LOGIC; --begins the whole transmission
           tbit : in  STD_LOGIC; --time for complete bit
           thalfbit : in  STD_LOGIC; --time for half bit
           countdword : in  STD_LOGIC; --dword completed
           countfourbits : in  STD_LOGIC; --four bits completed
			  wdtimer : in STD_LOGIC; --freerunning watch dog timer
			  resets : out  STD_LOGIC; --keeps the transmitter frozen
           ena_basecounter : out  STD_LOGIC; --enables base bit counter
           ena_bitcounter : out  STD_LOGIC; --enables  dword counter
--			  load_dword : out  STD_LOGIC; --load the message from register
			  shift_dword : out  STD_LOGIC;  --shifts the dword to the LSB
           active_bit : out  STD_LOGIC);
end component;

signal clk: STD_LOGIC:='1';
signal resetz, start_tx, tbit,thalfbit,countdword,countfourbits,wdtimer : std_logic;
signal resets,ena_basecounter, ena_bitcounter,load_dword,shift_dword, active_bit: std_logic;

begin

uut: fsm_arinc429_tx
    Port Map( clk=>clk,
           resetz =>resetz,
           start_trx =>start_tx,
           tbit => tbit,
           thalfbit => thalfbit,
           countdword =>countdword,
           countfourbits=> countfourbits,
			  wdtimer =>wdtimer,
			  resets =>resets,
           ena_basecounter => ena_basecounter,
           ena_bitcounter => ena_bitcounter,
--			  load_dword => load_dword,
			  shift_dword => shift_dword,
           active_bit => active_bit);


resetz <= '0', '1' after 39 ns;
start_tx <= '0', '1' after 40 ns, '0' after 65 ns, '1' after 24000 ns, '0' after 24025 ns, '1' after 27000 ns, '0' after 27025 ns;
tbit <= '0', '1' after 200ns, '0' after 220ns;
thalfbit <= '0', '1' after 100ns, '0' after 120ns;
countdword <= '0', '1' after 2000ns;
countfourbits <= '0', '1' after 3000ns;
wdtimer<='0';
-- clock generation
clkgen : process
begin
		loop
				wait for 10 ns;
				clk<=not clk;
		end loop;
end process clkgen;


end Behavioral;

