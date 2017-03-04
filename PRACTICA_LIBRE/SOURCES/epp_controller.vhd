library ieee;
use ieee.std_logic_1164.all;

entity epp_controller is
  port (
    CLK       : in  std_logic;
    RST       : in  std_logic;
    ASTRB     : in  std_logic;
    DSTRB     : in  std_logic;
    DATA      : in  std_logic_vector(7 downto 0);
    PWRITE    : in  std_logic;
    PWAIT     : out std_logic;
    DIR       : out std_logic_vector(7 downto 0);
    DATO      : out std_logic_vector(7 downto 0);
    DATOS_VLD : out std_logic);
end;

architecture rtl of epp_controller is

  signal dir_aux : std_logic_vector(7 downto 0);
  signal ce_dat  : std_logic;

begin

  direccion : process(RST, CLK)
  begin
    if RST='1' then
      dir_aux <= (others => '0');
    elsif CLK'event and CLK='1' then
      if (not ASTRB and not PWRITE) = '1' then -- CE = '1'
        dir_aux <= DATA;
      end if ;
    end if ;
  end process ; -- direccion


  datos : process(RST, CLK)
  begin
    if RST='1' then
      ce_dat <= '0';
    elsif CLK'event and CLK='1' then
      if RST='1' then
        ce_dat <= '0';
      elsif CLK'event and CLK='1' then
        ce_dat <= '1' when (DSTRB and not DSTRB and not PWRITE) else '0';
      end if ;
    end if ;
  end process ; -- datos

  s_DATOS_VLD : process(RST, CLK)
  begin
    if RST='1' then
      DATOS_VLD <= '0';
    elsif CLK'event and CLK='1' then
      DATOS_VLD <= ce_dat;
    end if ;
  end process ; -- s_DATOS_VLD

  s_DATO : process(RST, CLK)
  begin
    if RST='1' then
      DATO <= (others => '0');
    elsif CLK'event and CLK='1' then
      if ce_dat = '1' then
        DATO <= DATA;
      end if ;
    end if ;
  end process ; -- s_DATO

  s_DIR : process(RST, CLK)
  begin
    if RST='1' then
      DIR <= (others => '0');
    elsif CLK'event and CLK='1' then
      if ce_dat = '1' then
        DIR <= dir_aux;
      end if ;
    end if ;
  end process ; -- s_DIR

  PWAIT <= not ASTRB or not DSTRB;

end rtl;
