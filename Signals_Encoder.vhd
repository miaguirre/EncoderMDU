----------------------------------------------------------------------------------
-- Company: Universidad de Sevilla
-- Engineer: Miguel A. Aguirre
-- 
-- Create Date:    08:53:04 05/13/2016 
-- Design Name: Encoders signals
-- Module Name:    Signals_Encoder - Behavioral 
-- Project Name: 
-- Target Devices: Any
-- Tool versions: 
-- Description: This module encapsulates the to encoders used in the design
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

entity Signals_Encoder is
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
end Signals_Encoder;

architecture Behavioral of Signals_Encoder is

component fsm_encoder
    Port ( clk : in  STD_LOGIC; --Clock
           resetz : in  STD_LOGIC; --Reset signal, active low
           InA : in  STD_LOGIC; --Encoder 0 signal A
           InB : in  STD_LOGIC; --Encoder 0 signal B
           OutR : out STD_LOGIC; --Right spinning
           OutL : out STD_LOGIC; --Left spinning
			  Active : out STD_LOGIC
			  );
end component;

component counter_up
	 generic( N : integer := 8);
    Port ( clk : in  STD_LOGIC;
           resetz : in  STD_LOGIC; --!master reset, active low
           resets : in  STD_LOGIC; --!synchronous reset, active high
			  up: in  STD_LOGIC; -- !count up
           value : out STD_LOGIC_VECTOR(N-1 downto 0)); -- ! pulses counter left and right
end component;

component Comparator_Enc 
	 Generic (NBits : integer := 5);
    Port ( Enc_Right : in  STD_LOGIC_VECTOR (NBits-1 downto 0);
           Enc_Left : in  STD_LOGIC_VECTOR (NBits-1 downto 0);
           Enc_Value : out  STD_LOGIC_VECTOR (NBits-1 downto 0);
           Enc_Spinning : out  STD_LOGIC);
end component;

signal sOut0R, sOut0L, sOut1R, sOut1L : STD_LOGIC;
signal Pulses00, Pulses01, Pulses10, Pulses11 : STD_LOGIC_VECTOR (N-1 downto 0);
--signal value0, value1 : STD_LOGIC_VECTOR(N-1 downto 0);

begin
Enc0: fsm_encoder
    Port map( clk => clk,
           resetz => resetz,
           InA => In0A,
           InB => In0B,
           OutR => sOut0R,
           OutL => sOut0L,
			  Active => Active0
			  );
Cont00: counter_up
	 generic map( N => N)
    Port map( clk  => clk,
           resetz=> resetz,
           resets => Initialize,
			  up => sOut0R,
           value => Pulses00);
Cont01: counter_up
	 generic map( N => N)
    Port map( clk  => clk,
           resetz=> resetz,
           resets => Initialize,
			  up => sOut0L,
           value => Pulses01);
Comp0: Comparator_Enc 
	 Generic map(NBits => N)
    Port map( Enc_Right => Pulses00,
           Enc_Left =>  Pulses01,
           Enc_Value =>  Pulses0,
           Enc_Spinning  => SpinRL0);

Enc1: fsm_encoder
    Port map( clk => clk,
           resetz => resetz,
           InA => In1A,
           InB => In1B,
           OutR => sOut1R,
           OutL => sOut1L,
			  Active => Active1
			  );
Cont10: counter_up
	 generic map( N => N)
    Port map( clk  => clk,
           resetz=> resetz,
           resets => Initialize,
			  up => sOut1R,
           value => Pulses10);
Cont11: counter_up
	 generic map( N => N)
    Port map( clk  => clk,
           resetz=> resetz,
           resets => Initialize,
			  up => sOut1L,
           value => Pulses11);
Comp1: Comparator_Enc 
	 Generic map(NBits => N)
    Port map( Enc_Right => Pulses10,
           Enc_Left =>  Pulses11,
           Enc_Value =>  Pulses1,
           Enc_Spinning  => SpinRL1);

Error0 <= '0';
Error1 <= '1';		  
end Behavioral;

