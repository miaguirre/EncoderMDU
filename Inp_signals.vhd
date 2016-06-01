----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:14:11 05/14/2016 
-- Design Name: 
-- Module Name:    Inp_signals - Behavioral 
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

entity Inp_signals is
	 generic (Nencoder : integer := 5);
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC;
			  Enc_DH_R : in  STD_LOGIC;
			  Enc_DH_L : in  STD_LOGIC;
			  PB_Enc_DH_A : in  STD_LOGIC;
			  PB_Enc_DH_B : in  STD_LOGIC;
			  PB_Enc_DHMDA_A : in  STD_LOGIC;
			  PB_Enc_DHMDA_B : in  STD_LOGIC;

			  Enc_PC_R : in  STD_LOGIC;
			  Enc_PC_L : in  STD_LOGIC;
			  PB_Enc_PC_A : in  STD_LOGIC;
			  PB_Enc_PC_B : in  STD_LOGIC;
			  Sel0_Enc_PC : in  STD_LOGIC;
			  Sel1_Enc_PC : in  STD_LOGIC;
			  Sel2_Enc_PC : in  STD_LOGIC;
			  
           Error_CCFPGA : in  STD_LOGIC;
			  Error_TFPGA  : in  STD_LOGIC;
			  Error_Pwr1   : in  STD_LOGIC;
			  Error_Pwr2   : in  STD_LOGIC;
			  Error_Pwr3   : in  STD_LOGIC;

           message_normal : out  STD_LOGIC_VECTOR (30 downto 0);
			  message_error : out  STD_LOGIC_VECTOR (30 downto 0);
           send : out  STD_LOGIC);
end Inp_signals;

architecture Behavioral of Inp_signals is

component Signals_Encoder
	 generic (N : integer := 8);
    Port ( clk : in  STD_LOGIC; --!Clock signal
           resetz : in  STD_LOGIC; --!Reset signal, active low
			  Initialize : in  STD_LOGIC; --!initializa counters of both encoders
           In0A : in  STD_LOGIC; --!Encoder 0, port A
           In0B : in  STD_LOGIC; --!Encoder 0, port B 
           In1A : in  STD_LOGIC; --!Encoder 1, port A
           In1B : in  STD_LOGIC; --!Encoder 0, port B
			  Error0 : out STD_LOGIC; --! Error in the inputs of encoder 0
			  Error1 : out STD_LOGIC; --! Error in the inputs of encoder 1
           Active0 : out STD_LOGIC; --!Encoder 0 still spinning in the moment of sending the message
			  Active1 : out STD_LOGIC; --!Encoder 1 still spinning in the moment of sending the message
           SpinRL0 : out STD_LOGIC; --!Encoder 1 spinning to the right or to the left
			  SpinRL1 : out STD_LOGIC; --!Encoder 1 spinning to the right or to the left
			  Pulses0 : out STD_LOGIC_VECTOR(N-1 downto 0); --! absolute number of detents
			  Pulses1 : out STD_LOGIC_VECTOR(N-1 downto 0)  --! absolute number of detents		  			  
);

end component;

component activity_detector
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
end component;

component counter_sat is
--system clock 100 Mhz
--N size of counter, Sat is the vakue of Saturation. when this value is reached then a pulse is then
	 generic( N : natural := 7 ;
				Sat : natural :=126);
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC; --master reset
           resets : in  STD_LOGIC; --synchronous reset
			  enable: in  STD_LOGIC; --one count more
			  Saturation : out STD_LOGIC); --pulse when time of half bit
end component;

signal sSend : STD_LOGIC;

signal Selector_PC : STD_LOGIC_VECTOR(1 downto 0);

signal PB_DH_EncDH, PB_DH, PB_PC  : STD_LOGIC;
signal Error_PB_EncDH, Error_PB_DH, Error_PB_PC, Error_Sel_PC : STD_LOGIC;
signal Error_EncPC,Error_EncDH : STD_LOGIC;
signal Release_EncPC, Release_EncDH : STD_LOGIC;
signal SpinRL_EncPC, SpinRL_EncDH : STD_LOGIC;
signal Detents_EncPC, Detents_EncDH : STD_LOGIC_VECTOR(Nencoder-1 downto 0); 
begin
 Encs: Signals_Encoder
	 Generic map (N => Nencoder)
    Port map( clk => clk,
           resetz => resetz,
			  Initialize => sSend,
           In0A => Enc_DH_R,
           In0B => Enc_DH_L, 
           In1A => Enc_PC_R,
           In1B => Enc_PC_L,
			  Error0 => Error_EncDH,
			  Error1 => Error_EncPC,
           Active0 => Release_EncDH,
			  Active1 => Release_EncPC,
           SpinRL0 => SpinRL_EncDH,
			  SpinRL1 => SpinRL_EncPC,
			  Pulses0 => Detents_EncDH,
			  Pulses1 => Detents_EncPC	  			  
			  );

 Sings: activity_detector
     Port map( 
	        PB_Enc0A => PB_Enc_DH_A,
           PB_Enc0B => PB_Enc_DH_B,
			  PB_DEnc0A => PB_Enc_DHMDA_A,
           PB_DEnc0B => PB_Enc_DHMDA_B,
			  
           PB_Enc1A => PB_Enc_PC_A,
           PB_Enc1B => PB_Enc_PC_B,
			  Sel0_Enc1 => Sel0_Enc_PC,
			  Sel1_Enc1 => Sel1_Enc_PC,
			  Sel2_Enc1 => Sel2_Enc_PC,
			  
			  PB_Enc0 => PB_DH_EncDH,
			  Error_PB_Enc0 => Error_PB_EncDH,
			  PB_Enc0D => PB_DH,
			  Error_PB_Enc0D => Error_PB_DH, 
			  PB_Enc1 => PB_PC,
			  Error_PB_Enc1 => Error_PB_PC, 
           Sel_Enc1 => Selector_PC,
			  Error_Sel_Enc1 => Error_Sel_PC
			  );			  
 Timing100ms: counter_sat 
--system clock  32.768  KHz
--N size of counter, Sat is the vakue of Saturation. when this value is reached then a pulse is then asserted
	 generic map( N => 13,
				Sat => 3277)
    Port map( clk => clk,
           resetz => resetz,
           resets => '0',
			  enable => '1',
			  Saturation => sSend
			  ); 
message_normal (30 downto 0) <= "11" & Detents_EncPC(3 downto 0)  & Detents_EncPC(4) & SpinRL_EncPC & Release_EncPC & PB_PC & Selector_PC (1 downto 0) &
       PB_DH & Detents_EncDH(3 downto 0) & Detents_EncDH(4) & SpinRL_EncDH & Release_EncDH & PB_DH_EncDH & "00" & "11000000" ;
message_error (30 downto 0) <= "00" & "00000000" & Error_EncPC & Error_PB_PC & Error_Sel_PC &
       Error_PB_DH & Error_EncDH & Error_PB_EncDH & 
		 Error_CCFPGA & Error_TFPGA & Error_Pwr1 & Error_Pwr2 & Error_Pwr3 & "00" & "11000001";
Send <= sSend;
end Behavioral;

