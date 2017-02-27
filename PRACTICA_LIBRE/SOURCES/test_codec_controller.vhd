-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity test_codec_controller is
  port (
    rst       : in  std_logic;
    bit_clk   : in  std_logic;
    clk       : in  std_logic;
    sw        : in  std_logic_vector(7 downto 0);
    BTN_vol   : in  std_logic;
    BTN_Frec  : in  std_logic;
	 BTN_ch  : in  std_logic;
    RESTART   : in  std_logic;
    reset     : out std_logic;
    sync      : out std_logic;
    leds      : out std_logic_vector(3 downto 0);
    sdata_out : out std_logic);
end test_codec_controller;

-------------------------------------------------------------------------------

architecture rtl of test_codec_controller is
  signal frec_code   : std_logic_vector(7 downto 0);
  signal vol_code    : std_logic_vector(4 downto 0);
  signal CHANNEL_i    : std_logic_vector(1 downto 0);
  signal reset_i     : std_logic;
  signal sync_i      : std_logic;
  signal sdata_out_i : std_logic;
begin

  DUT : entity work.codec_controller
    port map (
      rst       => rst,
      bit_clk   => BIT_CLK,
      clk       => clk,
      vol_code  => vol_code,
      RESTART   => RESTART,
      reset     => reset_i,
      CHANNEL    => CHANNEL_i,
      sync      => sync_i,
      frec_code => frec_code,
      sdata_out => sdata_out_i);

  reset     <= reset_i;
  sync      <= sync_i;
  sdata_out <= sdata_out_i;

  leds <= reset_i&sync_i&sdata_out_i&bit_clk;

  process (clk, rst)
  begin
    if rst = '1' then
      frec_code   <= (others => '0');
      vol_code    <= (others => '0');
      CHANNEL_i    <= (others => '0');
    elsif clk'event and clk = '1' then
      if BTN_vol = '1' then
        vol_code  <= sw(4 downto 0);
      elsif BTN_frec = '1' then
        frec_code <= sw;
      elsif BTN_ch = '1' then
        CHANNEL_i  <= sw(1 downto 0);
      end if;
    end if;
  end process;

end rtl;
