library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity epp_device is
  port (
    DATA   : out std_logic_vector(7 downto 0);
    PWRITE : out std_logic;
    DSTRB  : out std_logic;
    ASTRB  : out std_logic;
    PWAIT  : in std_logic
  );

end epp_device;
architecture sim of epp_device is

begin

 process
    procedure epp_cycle ( address : in  std_logic_vector(7 downto 0);
                          data_out : in std_logic_vector(7 downto 0)) is
    begin
      -- escritura direccion.
      PWRITE <= '0';
      wait for 33 ns;
      ASTRB <= '0';
      data  <= address;
      wait for 133 ns;
      ASTRB <= '1';
      wait for 33 ns;
      data   <= (others => 'Z');
      PWRITE <= '1';
      wait for 133 ns;
      PWRITE <= '0';
      data   <= data_out;
      wait for 33 ns;
      DSTRB <= '0';
      wait for 133 ns;
      DSTRB <= '1';
      wait for 33 ns;
      data   <= (others => 'Z');
      PWRITE <= '1';
    end procedure;

    file arch_in  : text open read_mode is "../SOURCES/datos.dat";
    variable bf   : line;
    variable dato : std_logic_vector(7 downto 0);
    variable dir  : std_logic_vector(7 downto 0);

 begin
   --inicializacion
   data   <= (others => '0');
   PWRITE <= '1';
   DSTRB  <= '1';
   ASTRB  <= '1';

   dir  := (others => '0');
   wait for 330 ns;

   while not endfile(arch_in) loop
     readline (arch_in, bf);
     hread (bf, dir);
     hread (bf, dato);
     epp_cycle ( address => dir,
                 data_out => dato);
     wait for 111 ns;
   end loop;

   report "FIN CONTROLADO DE LA SIMULACION" severity failure;
  end process;
end sim;
