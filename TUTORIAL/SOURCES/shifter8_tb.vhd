-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity shifter8_tb is

end shifter8_tb;

-------------------------------------------------------------------------------

architecture sim of shifter8_tb is

  component shifter8
    port (
      clk         : in  std_logic;
      rst         : in  std_logic;
      ce          : in  std_logic;
      direction   : in  std_logic;
      polarity    : in  std_logic;
      shifter_out : out std_logic_vector(7 downto 0));
  end component;

  signal clk_i         : std_logic := '0';
  signal rst_i         : std_logic := '0';
  signal ce_i          : std_logic := '1';
  signal direction_i   : std_logic := '0';
  signal polarity_i    : std_logic := '0';
  signal shifter_out_i : std_logic_vector(7 downto 0);

begin  -- sim

  DUT : shifter8
    port map (
      clk         => clk_i,
      rst         => rst_i,
      ce          => ce_i,
      direction   => direction_i,
      polarity    => polarity_i,
      shifter_out => shifter_out_i);

  rst_i <=  '1'  after 123 ns;
  clk_i <= not clk_i after 5 ns;

  process
  begin  -- process

    wait for 433 ns;
     ce_i <= '0';
    wait for 33 ns;
     ce_i <= '1';
    wait for 33 ns;
     direction_i <= '1';
     wait for 133 ns;
     polarity_i <= '1';
     wait for 133 ns;
    report "fin controlado d ela simulación" severity FAILURE;
  end process;

 
end sim;

-------------------------------------------------------------------------------
