library ieee;
use ieee.std_logic_1164.all;


entity top_system is
  port (
   clk      : in  std_logic;
   rst     : in  std_logic;
   polarity  : in  std_logic;
   direction : in  std_logic;
   led      : out std_logic_vector(7 downto 0));

end top_system;

architecture for_top_system of top_system is

  component prescaler
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      pre_out : out std_logic);
  end component;

  component shifter8
    port (
      clk         : in  std_logic;
      rst         : in  std_logic;
		ce         : in  std_logic;
      direction   : in  std_logic;
      polarity    : in  std_logic;
      shifter_out : out std_logic_vector(7 downto 0));
  end component;


  signal pre_out : std_logic;

begin  -- for_top_system_v1

  press : prescaler
    port map (
      clk     => clk,
      rst     => rst,
      pre_out => pre_out);

  shiff : shifter8
    port map (
      clk         => pre_out,
      rst         => rst,     
		 ce         => '1', 
      direction   => direction,
      polarity    => polarity,
      shifter_out => led);

end for_top_system;
