-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity prescaler_tb is

end prescaler_tb;

-------------------------------------------------------------------------------

architecture sim of prescaler_tb is

  component prescaler
    port (
      clk     : in  std_logic;
      rst     : in  std_logic;
      pre_out : out std_logic);
  end component;

  signal clk_i     : std_logic := '0';
  signal rst_i     : std_logic := '1';
  signal pre_out_i : std_logic;

begin  -- sim

  DUT : prescaler
    port map (
      clk     => clk_i,
      rst     => rst_i,
      pre_out => pre_out_i);


  rst_i <= '0'       after 123 ns;
  clk_i <= not clk_i after 5 ns;

end sim;

-------------------------------------------------------------------------------
