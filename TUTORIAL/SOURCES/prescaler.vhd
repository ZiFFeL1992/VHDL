library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prescaler is
  port (
    clk     : in  std_logic;
    rst     : in  std_logic;
    pre_out : out std_logic);
end prescaler;


architecture for_prescaler of prescaler is

  --constant CLKDIV      : integer := 25e6;  
  constant CLKDIV      : integer := 25;
  signal   counter_reg : integer range 0 to CLKDIV-1;

begin  -- for_prescaler

  process (clk, rst)
  begin  -- process
    if rst = '0' then
      counter_reg   <= 0;
    elsif clk'event and clk = '1' then
      if counter_reg = CLKDIV-1 then
        counter_reg <= 0;
      else
        counter_reg <= counter_reg+1;
      end if;
    end if;
  end process;

  pre_out <= '1' when counter_reg = CLKDIV-1 else '0';

end for_prescaler;
