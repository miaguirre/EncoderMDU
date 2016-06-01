----------------------------------------------------------------------------------
-- Company: Universidad de Sevilla	
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date::29:15 05/14/2016 
-- Design Name:     activity_detector
-- Module Name:    activity_detector - Behavioral 
-- Project Name: 
-- Target Devices: Microsemi IGLOO2 FPGA 12K LE M2GL010T-1FGG484 
-- Tool versions: 
-- Description: Detects activity of digital signals. Detects Errors in digital signals if there is a discrepancy
-- between A and B copies of a pushbutton. The selector gives a digital value of the position and there is a alarm value.
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity activity_detector is
    Port ( PB_Enc0A : in  STD_LOGIC; --!digital Push Button Encoder 0, first signal
           PB_Enc0B : in  STD_LOGIC; --!digital Push Button Encoder 0, second signal
			  PB_DEnc0A : in  STD_LOGIC;--!digital Push Button Encoder 0 DH, first signal
           PB_DEnc0B : in  STD_LOGIC;--!digital Push Button Encoder 0 DH, second signal
           PB_Enc1A : in  STD_LOGIC; --!digital Push Button Encoder 1, first signal
           PB_Enc1B : in  STD_LOGIC; --!digital Push Button Encoder 1, second signal
			  Sel0_Enc1 : in  STD_LOGIC;--! Selector Encoder 1, signal 0
			  Sel1_Enc1 : in  STD_LOGIC;--! Selector Encoder 1, signal 1
			  Sel2_Enc1 : in  STD_LOGIC;--! Selector Encoder 1, signal 2
			  PB_Enc0 : out STD_LOGIC; --! State of the Pushbutton Encoder 0
			  Error_PB_Enc0 : out STD_LOGIC; --! Discrepancy between A and B in Push Button Encoder 0
			  PB_Enc0D : out STD_LOGIC; --! State of the Pushbutton Encoder 0 DH
			  Error_PB_Enc0D : out STD_LOGIC; --! Discrepancy between A and B in Push Button Encoder 0 DH
			  PB_Enc1 : out STD_LOGIC; --! State of the Pushbutton Encoder 1
			  Error_PB_Enc1 : out STD_LOGIC; --! Discrepancy between A and B in Push Button Encoder 1
           Sel_Enc1 : out STD_LOGIC_VECTOR(1 downto 0);  --!Selector value (00,01,10)
			  Error_Sel_Enc1 : out STD_LOGIC --! Error in the Selector 
			  );
end activity_detector;

architecture Behavioral of activity_detector is

begin 
PB_Enc0 <= PB_Enc0A when (PB_Enc0A = PB_Enc0B) else '0';
Error_PB_Enc0 <= '1' when (PB_Enc0A /= PB_Enc0B) else '0';

PB_Enc0D <= PB_Enc0A when (PB_DEnc0A = PB_DEnc0B) else '0';
Error_PB_Enc0D <= '1' when (PB_DEnc0A /= PB_DEnc0B) else '0';

PB_Enc1 <= PB_Enc1A when (PB_Enc1A = PB_Enc1B) else '0';
Error_PB_Enc1 <= '1' when (PB_Enc1A /= PB_Enc1B) else '0';

sel_asinc : Process(Sel0_Enc1, Sel1_Enc1, Sel2_Enc1)
begin
	if((Sel0_Enc1='1') and (Sel1_Enc1 = '0') and (Sel2_Enc1 = '0')) then
        Sel_Enc1<="00";
        Error_Sel_Enc1 <= '0';
   elsif	((Sel0_Enc1='0') and (Sel1_Enc1 = '1') and (Sel2_Enc1 = '0')) then	  
        Sel_Enc1<="01";
        Error_Sel_Enc1 <= '0';
   elsif	((Sel0_Enc1='0') and (Sel1_Enc1 = '0') and (Sel2_Enc1 = '1')) then	  
        Sel_Enc1<="10";
        Error_Sel_Enc1 <= '0';
   else
        Sel_Enc1<="11";
        Error_Sel_Enc1 <= '1';
   end if;
end process sel_asinc;        	
			  
			  
			  
end Behavioral;

