
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity epp_controller_tb is

end epp_controller_tb;


architecture sim of epp_controller_tb is

  signal CLK_i      : std_logic:='0';
  signal RST_i      : std_logic:='1';
  signal ASTRB_i    : std_logic;
  signal DSTRB_i    : std_logic;
  signal DATA_i     : std_logic_vector(7 downto 0);
  signal PWRITE_i   : std_logic;
  signal PWAIT_i    : std_logic;
  signal DIR_i      : std_logic_vector (7 downto 0);
  signal DATO_i     : std_logic_vector (7 downto 0);
  signal DATOS_VLD_i : std_logic;

begin  -- sim

  DUT:entity work.epp_controller
    port map (
        CLK      => CLK_i,
        RST      => RST_i,
        ASTRB    => ASTRB_i,
        DSTRB    => DSTRB_i,
        DATA     => DATA_i,
        PWRITE   => PWRITE_i,
        PWAIT    => PWAIT_i,
        DIR      => DIR_i,
        DATO     => DATO_i,
        DATOS_VLD => DATOS_VLD_i);

 U_EPP:entity work.epp_device
  port map (
      DATA    => DATA_i,
      PWRITE => PWRITE_i,
      DSTRB => DSTRB_i,
      ASTRB => ASTRB_i,
      PWAIT  => PWAIT_i);

  CLK_i<=not CLK_i after 5 ns;
  RST_i<='0' after 258 ns;


end sim;
