library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity codec_controller is
  port (
    RST        : in  std_logic;
    BIT_CLK    : in  std_logic;
    CLK        : in  std_logic;
    VOL_CODE   : in  std_logic_vector(4 downto 0);
    RESTART    : in  std_logic;
    CHANNEL    : in  std_logic_vector(1 downto 0);
    RESET      : out std_logic;
    SYNC       : out std_logic;
    FREC_CODE  : in  std_logic_vector(7 downto 0);
    SDATA_OUT  : out std_logic);
end codec_controller;


architecture rtl of codec_controller is

  signal   cmd_addr     : std_logic_vector(19 downto 0);
  signal   cmd_data     : std_logic_vector(19 downto 0);
  signal   sync_counter : unsigned(7          downto 0);
  signal   left_data    : std_logic_vector(19 downto 0);
  signal   right_data   : std_logic_vector(19 downto 0);
  constant Tag          : std_logic_vector(15 downto 0) := X"F800";

  signal address : unsigned(11 downto 0);
  signal data    : std_logic_vector(19 downto 0);

begin  -- rtl



  memoria : entity work.seno_4kX20
    port map (
      clk  => clk,
      addr => std_logic_vector(address),
      dout => data );



  --Trama de salida SDATA_OUT
  process (clk, rst)
  begin
    if rst = '1' then
      sdata_out                                     <= '0';
    elsif clk'event and clk = '1' then
      if reset_aux = '0' then
        sdata_out                                   <= '0';
      elsif (sync_counter < 15) then
        sdata_out                                   <= tag(15-to_integer(sync_counter));
      elsif (sync_counter >= 16) and (sync_counter  <= 35) then  --Slot 1 : Command address
        sdata_out                                   <= cmd_addr(35 - to_integer(sync_counter));
      elsif (sync_counter >= 36) and (sync_counter  <= 55) then  --Slot 2 : Command data
        sdata_out                                   <= cmd_data(55 - to_integer(sync_counter));
      elsif ((sync_counter >= 56) and (sync_counter <= 75)) then  --Slot 3 : left channel
        sdata_out                                   <= left_data(75 - to_integer(sync_counter));
      elsif ((sync_counter >= 76) and (sync_counter <= 95)) then  --Slot 4 : right channel
        sdata_out                                   <= right_data(95 - to_integer(sync_counter));
      else
        sdata_out                                   <= '0';
      end if;
    end if;
  end process;
end rtl;
