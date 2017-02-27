
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity top_system is
  port (
    RELOJ     : in  std_logic;
    RST       : in  std_logic;
    --puerto EPP
    ASTRB     : in  std_logic;
    DSTRB     : in  std_logic;
    DATA      : in  std_logic_vector(7 downto 0);
    PWRITE    : in  std_logic;
    PWAIT     : out std_logic;
    --CODEC
    BIT_CLK   : in  std_logic;
    RESET     : out std_logic;
    SYNC      : out std_logic;
    SDATA_OUT : out std_logic);

end;

architecture rtl of top_system is


begin


end rtl;
