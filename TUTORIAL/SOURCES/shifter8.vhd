library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shifter8 is
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    ce          : in  std_logic;
    direction   : in  std_logic;
    polarity    : in  std_logic;
    shifter_out : out std_logic_vector(7 downto 0));
end shifter8;

architecture for_shifter8 of shifter8 is
 signal c_out : unsigned(2 downto 0);
 signal shf_aux : std_logic_vector(7 downto 0);
begin  -- for_shifter8
-- contador  8 bits
  process (clk, rst)
  begin  -- process
    if rst = '0' then
      c_out     <= (others => '0');
    elsif clk'event and clk = '1' then
      if ce = '1' then
        if direction = '1' then
          c_out <= c_out+1;
        else
          c_out <= c_out-1;
        end if;
      end if;
    end if;
  end process;

--decodificador 3:8
  process (c_out)
  begin  -- process
    case c_out is
      when "000"  => shf_aux <= "00000001";
      when "001"  => shf_aux <= "00000010";
      when "010"  => shf_aux <= "00000100";
      when "011"  => shf_aux <= "00001000";
      when "100"  => shf_aux <= "00010000";
      when "101"  => shf_aux <= "00100000";
      when "110"  => shf_aux <= "01000000";
      when "111"  => shf_aux <= "10000000";
      when others => null;
    end case;
  end process;

  shifter_out <= shf_aux when polarity = '1'else not shf_aux;

end for_shifter8;
