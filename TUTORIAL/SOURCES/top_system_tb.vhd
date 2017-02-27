-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity top_system_tb is

end top_system_tb;

-------------------------------------------------------------------------------

architecture sim of top_system_tb is

  component top_system
    port (
      clk       : in  std_logic;
      rst       : in  std_logic;
      polarity  : in  std_logic;
      direction : in  std_logic;
      led       : out std_logic_vector(7 downto 0));
  end component;

  signal clk_i       : std_logic := '0';
  signal rst_i       : std_logic := '0';
  signal polarity_i  : std_logic := '0';
  signal direction_i : std_logic := '0';
  signal led_i       : std_logic_vector(7 downto 0);

begin  -- sim

  DUT : top_system
    port map (
        clk       => clk_i,
        rst       => rst_i,
        polarity  => polarity_i,
        direction => direction_i,
        led       => led_i);


  rst_i      <=  '1'  after 33 ns;
  clk_i      <= not clk_i after 5 ns;
  polarity_i <= '1'       after 3 us, '0' after 9 us;
 direction_i <= '1'       after 6 us;



end sim;

-------------------------------------------------------------------------------
