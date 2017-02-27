
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity codec_controller_tb is

end codec_controller_tb;


architecture sim of codec_controller_tb is

  signal clk_i        : std_logic := '0';
  signal RST_i        : std_logic := '1';
  signal BIT_CLK_i    : std_logic := '0';
  signal vol_code_i   : std_logic_vector(4 downto 0);
  signal restart_i    : std_logic := '0';
  signal CHANNEL_i    : std_logic_vector(1 downto 0);
  signal reset_i      : std_logic;
  signal sync_i       : std_logic;
  signal FREC_CODE_i  : std_logic_vector(7 downto 0);
  signal sdata_out_i  : std_logic;
  signal LINE_OUT_R_i : real      := 0.0;
  signal LINE_OUT_L_i : real      := 0.0;
begin  -- sim

  DUT : entity work.codec_controller
    port map (
      rst       => rst_i,
      bit_clk   => bit_clk_i,
      clk       => clk_i,
      vol_code  => vol_code_i,
      restart   => restart_i,
		CHANNEL   => CHANNEL_i,
      reset     => reset_i,
      sync      => sync_i,
      FREC_CODE => FREC_CODE_i,
      sdata_out => sdata_out_i);

  codec : entity work.LM4550
    port map (
      bit_clk    => bit_clk_i,
      reset      => reset_i,
      SDATA_OUT  => SDATA_OUT_i,
      sync       => sync_i,
      LINE_OUT_R => LINE_OUT_R_i,
      LINE_OUT_L => LINE_OUT_L_i);


  RST_i <= '1', '0'  after 223 ns;
  clk_i <= not clk_i after 5 ns;


  process
  begin  -- process
  CHANNEL_i<="00";
    vol_code_i  <= std_logic_vector(to_unsigned(3, vol_code_i'length));
    FREC_CODE_i <= std_logic_vector(to_unsigned(24, FREC_CODE_i'length));
    wait for 10 us;
	 CHANNEL_i<="01";
	 wait for 2 ms;
	 CHANNEL_i<="10";
	 wait for 2 ms;
	 CHANNEL_i<="11";
	 wait for 2 ms;
    wait until clk_i = '0';
    restart_i   <= '1';
    wait until clk_i = '0';
    restart_i   <= '0';
	 CHANNEL_i<= not CHANNEL_i;
    vol_code_i  <= std_logic_vector(to_unsigned(1, vol_code_i'length));
    FREC_CODE_i <= std_logic_vector(to_unsigned(12, FREC_CODE_i'length));
	 CHANNEL_i<="00";
    wait for 10 us;
	 CHANNEL_i<="01";
	 wait for 2 ms;
	 CHANNEL_i<="10";
	 wait for 2 ms;
	 CHANNEL_i<="11";
	 wait for 2 ms;
	 vol_code_i  <= std_logic_vector(to_unsigned(7, vol_code_i'length));
         FREC_CODE_i <= std_logic_vector(to_unsigned(6, FREC_CODE_i'length));
	 CHANNEL_i<="00";
    wait for 2 ms;
	 CHANNEL_i<="01";
	 wait for 2 ms;
	 CHANNEL_i<="10";
	 wait for 2 ms;
	 CHANNEL_i<="11";
	 wait for 2 ms;
    report "FIN CONTROLADO DE LA SIMULACION" severity failure;
  end process;

  process(sync_i)
    file arch_out      : text open write_mode is "../fuentes/vout.dat";
    variable buffer_wr : line;
    variable vout      : real := 0.0;
  begin  -- process
    if sync_i = '1' and sync_i'event then
      vout                    := LINE_OUT_L_i;
		write (buffer_wr, vout);
		write (buffer_wr, "  ");
		vout                    := LINE_OUT_R_i;
		write (buffer_wr, vout);
      writeline (arch_out, buffer_wr);
    end if;
  end process;

end sim;

-------------------------------------------------------------------------------
