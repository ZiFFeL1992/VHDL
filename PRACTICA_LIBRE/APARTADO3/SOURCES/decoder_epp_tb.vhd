library ieee;
use ieee.std_logic_1164.all;

entity decoder_epp_tb is

end decoder_epp_tb;


architecture sim of decoder_epp_tb is

    signal CLK_i       : std_logic := '0';
    signal RST_i       : std_logic := '1';
    signal DIR_i       : std_logic_vector(7 downto 0);
    signal DATO_i      : std_logic_vector(7 downto 0);
    signal DATOS_VLD_i : std_logic := '0';
    signal RESTART_i   : std_logic;
    signal VOL_CODE_i  : std_logic_vector(4 downto 0);
    signal FREC_CODE_i : std_logic_vector(7 downto 0);
    signal CHANNEL_i   : std_logic_vector(1 downto 0);

begin  -- sim

  DUT : entity work.decoder_epp
    port map (
        CLK       => CLK_i,
        RST       => RST_i,
        DIR       => DIR_i,
        DATO      => DATO_i,
        DATOS_VLD => DATOS_VLD_i,
        RESTART   => RESTART_i,
        VOL_CODE  => VOL_CODE_i,
        FREC_CODE => FREC_CODE_i,
        CHANNEL   => CHANNEL_i);


  RST_i <= '1', '0'  after 223 ns;
  CLK_i <= not CLK_i after 5 ns;


  process
  begin  -- process

    DIR_i <= (others => '0');
    DATO_i <= (others => '0');

    wait until RST_i'event and RST_i = '0';

    -- Init
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '1';
    DIR_i <= x"11";
    DATO_i <= x"11";
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '0';

    wait for 150 ns;


    -- right channels
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '1';
    DIR_i <= x"CA";
    DATO_i <= x"DD";
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '0';

    wait for 150 ns;

	 -- left channels
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '1';
    DIR_i <= x"CA";
    DATO_i <= x"11";
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '0';

    wait for 150 ns;

	 -- any channels
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '1';
    DIR_i <= x"CA";
    DATO_i <= x"34";
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '0';

    wait for 150 ns;

    -- both channels
     wait until CLK_i'event and CLK_i = '0';
     DATOS_VLD_i <= '1';
     DIR_i <= x"CA";
     DATO_i <= x"22";
     wait until CLK_i'event and CLK_i = '0';
     DATOS_VLD_i <= '0';

     wait for 150 ns;


    -- vol
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '1';
    DIR_i <= x"B0";
    DATO_i <= x"55";
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '0';

    wait for 150 ns;


    -- frec
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '1';
    DIR_i <= x"F0";
    DATO_i <= x"AB";
    wait until CLK_i'event and CLK_i = '0';
    DATOS_VLD_i <= '0';

    wait for 150 ns;

    report "FIN CONTROLADO DE LA SIMULACION" severity failure;
  end process;


end sim;
