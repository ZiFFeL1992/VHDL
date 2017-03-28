library ieee;
use ieee.std_logic_1164.all;

entity test_epp_controller is
  port (
    CLK      : in  std_logic;
    RST      : in  std_logic;
    ASTRB    : in  std_logic;
    DSTRB    : in  std_logic;
    DATA     : in  std_logic_vector(7 downto 0);
    PWRITE   : in  std_logic;
    sel      : in  std_logic;
    leds     : out std_logic_vector (7 downto 0);
    PWAIT    : out std_logic);
end;

architecture rtl of test_epp_controller is

	signal DATO_i,DIR_i     : std_logic_vector (7 downto 0);
	signal DATO_aux,DIR_aux : std_logic_vector (7 downto 0);
	signal DATOS_VLD_i      : std_logic;

begin

  DUT : entity work.epp_controller
    port map (
      CLK       => CLK,
      RST       => RST,
      ASTRB     => ASTRB,
      DSTRB     => DSTRB,
      DATA      => DATA,
      PWRITE    => PWRITE,
      PWAIT     => PWAIT,
      DIR       => DIR_i,
      DATO      => DATO_i,
      DATOS_VLD => DATOS_VLD_i);

  process (clk, rst)
  begin
    if rst = '1' then
      DIR_aux    <= (others => '0');
      DATO_aux   <= (others => '0');
    elsif clk'event and clk = '1' then
      if DATOS_VLD_i = '1' then
        DIR_aux  <= DIR_i;
        DATO_aux <= DATO_i;
    end if;
  end if;
end process;

  leds <= DIR_aux when  sel = '1'  else DATO_aux;

end rtl;
