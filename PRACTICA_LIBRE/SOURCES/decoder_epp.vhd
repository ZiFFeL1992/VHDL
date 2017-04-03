library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity decoder_epp is
  port (
    CLK       : in  std_logic;
    RST       : in  std_logic;
    DIR       : in  std_logic_vector(7 downto 0);
    DATO      : in  std_logic_vector(7 downto 0);
    DATOS_VLD : in  std_logic;
    RESTART   : out std_logic;
    VOL_CODE  : out std_logic_vector(4 downto 0);
    FREC_CODE : out std_logic_vector(7 downto 0);
    CHANEL    : out std_logic_vector(1 downto 0));
end decoder_epp;

architecture rtl of decoder_epp is

begin

  process(clk, rst)
    variable flag : std_logic := '0';
  begin
    if rst = '1' then
      RESTART <= '0';
      flag := '0';
    elsif clk'event and clk = '1' then
      if DIR = x"11" and DATO = x"11" then
        if flag = '0' then
          RESTART <= '1';
          flag := '1';
        else
          RESTART <= '0';
        end if;
      end if;
    end if;
  end process; -- restart

  process(clk, rst)
  begin
    if rst = '1' then
      frec_code <= (others => '0');
    elsif clk'event and clk = '1' then
      if datos_vld = '1' and dir = x"F0" then
        frec_code <= dato;
      end if;
    end if;
  end process; -- frec_code

  process(clk, rst)
  begin
    if rst = '1' then
      vol_code <= (others => '0');
    elsif clk'event and clk = '1' then
      if datos_vld = '1' and dir = x"B0" then
        vol_code <= dato(4 downto 0);
      end if;
    end if;
  end process; -- vol_code

  process(clk, rst)
  begin
    if rst = '1' then
      chanel <= (others => '0');
    elsif clk'event and clk = '1' then
      if datos_vld = '1' and dir = x"CA" then
        case(dato) is
          when x"DD" =>
            chanel <= "10";
          when x"11" =>
            chanel <= "01";
          when x"22" =>
            chanel <= "11";
          when others =>
            chanel <= "00";
        end case;
      end if;
    end if;
  end process; -- channel

end rtl;
