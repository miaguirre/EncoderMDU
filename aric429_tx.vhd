----------------------------------------------------------------------------------
-- Company: University of Sevilla	
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date:    12:31:31 11/14/2014 
-- Design Name: 	ARINC 429 transmitter	
-- Module Name:    aric429_tx - Behavioral 
-- Project Name: 	SEA2ME
-- Target Devices: 
-- Tool versions: 
-- Description: ARINC 429 transmitter complete. The frequency of base counter is supposed to be 100MHz. If diffferent
--  to fullfil the normatives should be scaled
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

entity arinc429_tx is
    Port ( clk : in  STD_LOGIC;
           io_resetz : in  STD_LOGIC;
           start_tx : in  STD_LOGIC;
           message0 : in  STD_LOGIC_VECTOR (31 downto 0);
           message1 : in  STD_LOGIC_VECTOR (31 downto 0);
           message2 : in  STD_LOGIC_VECTOR (31 downto 0);
           line_p : out  STD_LOGIC;
           line_n : out  STD_LOGIC);
end arinc429_tx;

architecture Structural of arinc429_tx is

component fsm_arinc429_tx
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
component counter_dword is
	 generic( N : integer := 5);
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC; --master reset
           resets : in  STD_LOGIC; --synchronous reset
			  enable: in  STD_LOGIC; --one count more
			  saturation4 : out STD_LOGIC;
           saturationN : out STD_LOGIC); --pulse when time of half bit
end component;
component basecounter
	 generic( N : integer := 14; Cycle_tbit : integer := 8000; Cycle_halfbit : integer := 4000);
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC; --master reset
           resets : in  STD_LOGIC; --synchronous reset
           low_high_tx : in  STD_LOGIC; --the enable counter signal			  
           tbit : out  STD_LOGIC; --pulse when time of one bit
           thalfbit : out STD_LOGIC); --pulse when time of half bit
end component;
component par_serial
	 generic( N : integer := 32);
    Port ( clk : in  STD_LOGIC; --system clock
           resetz : in  STD_LOGIC; --system reset
           resets : in  STD_LOGIC; --synchronous reset
           ena_serial : in  STD_LOGIC; --enable the shifting of the word
           loadpar : in  STD_LOGIC; --load the parallel input 
           parallel_word : in  STD_LOGIC_VECTOR(N-1 downto 0); --parallel input of size N
           serial_bit : out  STD_LOGIC); --LSB of the word
end component;
component voter
    Port ( in0 : in  STD_LOGIC;
           in1 : in  STD_LOGIC;
           in2 : in  STD_LOGIC;
           out_tmr : out  STD_LOGIC);
end component;
component DrvLine
    Port (
        clk : in STD_LOGIC; --reloj
		  resetz : in STD_LOGIC; --negative reset
        Bit_tx : in  STD_LOGIC; --signal to transmit
		  Active : in  STD_LOGIC; -- when signal to transmit is active
        Line_p : out  STD_LOGIC; -- positive of differential sognal
        Line_n : out  STD_LOGIC); -- negative of differential sognal
end component;

component VHDL_resetsinc
	Port (clk: in STD_LOGIC;
			io_resetz: in STD_LOGIC;
			int_resetz: out STD_LOGIC);
end component;

signal tbit,thalfbit : STD_LOGIC;
signal countdword, countfourbits : STD_LOGIC;
signal wdtimer : STD_LOGIC;
signal ena_basecounter, ena_bitcounter, resets, shift_dword, active_bit: STD_LOGIC;
signal serial_bit,serial_bit0,serial_bit1,serial_bit2: STD_LOGIC;

signal resetz :STD_LOGIC;  
begin

fsm: fsm_arinc429_tx
    Port map( clk => clk,
           resetz => resetz,
           start_trx  => start_tx,
           tbit => tbit,
           thalfbit => thalfbit,
           countdword => countdword,--dword completed
           countfourbits =>  countfourbits, --four bits completed
			  wdtimer => wdtimer, 
			  resets=> resets,
           ena_basecounter => ena_basecounter,
           ena_bitcounter => ena_bitcounter,
--			  load_dword => load_dword,
			  shift_dword => shift_dword,
           active_bit=> active_bit);
ct32: counter_dword 
	 generic map( N => 5)
    Port map( clk => clk,
           resetz => resetz,
           resets => resets,
			  enable=> ena_bitcounter,
			  saturation4 => countfourbits,
           saturationN => countdword );
ctbase: basecounter
	 generic map( N=>7, Cycle_tbit=> 32, Cycle_halfbit=>16) --! Time for 1 bit, tbit is 32 cycles, half bit is 16 cycles. BAse frequency should be adjusted
    Port map( clk => clk,
           resetz => resetz,
           resets => resets,
           low_high_tx =>	ena_basecounter,	  
           tbit => tbit,
           thalfbit => thalfbit); --pulse when time of half bit
shftreg0: par_serial
	 generic map( N => 32)
    Port map( clk => clk,
           resetz => resetz,
           resets => resets,
           ena_serial =>shift_dword,
--           loadpar =>load_dword,
			  loadpar =>start_tx,
           parallel_word =>message0,
           serial_bit =>serial_bit0); --LSB of the word	
shftreg1: par_serial
	 generic map( N => 32)
    Port map( clk => clk,
           resetz => resetz,
           resets => resets,
           ena_serial =>shift_dword,
--           loadpar =>load_dword,
			  loadpar =>start_tx,
           parallel_word =>message1,
           serial_bit =>serial_bit1); --LSB of the word
shftreg2: par_serial
	 generic map( N => 32)
    Port map( clk => clk,
           resetz => resetz,
           resets => resets,
           ena_serial =>shift_dword,
--           loadpar =>load_dword,
			  loadpar =>start_tx,
           parallel_word =>message2,
           serial_bit =>serial_bit2); --LSB of the word	
tmr: voter
    Port map( in0 => serial_bit0,
           in1 => serial_bit1,
           in2 => serial_bit2,
           out_tmr => serial_bit);			  
outputs: DrvLine 
   Port map( 
           clk => clk,
           resetz => resetz,
           Bit_tx => serial_bit,
           Active=> active_bit,
           Line_p =>line_p,
           Line_n =>line_n);	
ctwdt: basecounter
	 generic map( N=>13, Cycle_tbit=> 8000, Cycle_halfbit=>16) --! timer then should cover all the message time. 
																				  --! N, the number of bits and Cycle_tbit covers 36*time of one bit
    Port map( clk => clk,
           resetz => resetz,
           resets => resets,
           low_high_tx =>	ena_basecounter,	  
           tbit => wdtimer,
           thalfbit => open); 			  

rst: VHDL_resetsinc
	Port map(clk => clk,
			io_resetz => io_resetz,
			int_resetz => resetz);

end Structural;

