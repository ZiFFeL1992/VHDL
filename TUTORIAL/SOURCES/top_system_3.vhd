library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_system_3 is
  port (
   clk       : in  std_logic;
   rst       : in  std_logic;
   polarity  : in  std_logic;
   direction : in  std_logic;
   led       : out std_logic_vector(7 downto 0));

end top_system_3;

architecture for_top_system of top_system_3 is

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
      ce          : in  std_logic;
      direction   : in  std_logic;
      polarity    : in  std_logic;
      shifter_out : out std_logic_vector(7 downto 0));
  end component;

component dcm
port
 (-- Clock in ports
  CLK_IN           : in     std_logic;
  -- Clock out ports
  CLK_OUT          : out    std_logic
 );
end component;

  signal pre_out, clk_out : std_logic;

begin  -- for_top_system_v1

U_dcm : dcm
  port map (
    CLK_IN  => CLK,
    cLK_OUT => CLK_OUT);

  press : prescaler
    port map (
      clk     => clk_out,
      rst     => rst,
      pre_out => pre_out);

  shiff : shifter8
    port map (
      clk         => clk_out,
      rst         => rst,
      ce          => pre_out,
      direction   => direction,
      polarity    => polarity,
      shifter_out => led);

end for_top_system;
