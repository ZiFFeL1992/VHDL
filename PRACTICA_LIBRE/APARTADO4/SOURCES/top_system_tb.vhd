library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity top_system_tb is

end top_system_tb;

architecture sim of top_system_tb is

  signal RELOJ_i      : std_logic := '0';
  signal RST_i        : std_logic := '1';
  signal ASTRB_i      : std_logic;
  signal DSTRB_i      : std_logic;
  signal DATA_i       : std_logic_vector(7 downto 0);
  signal PWRITE_i     : std_logic;
  signal PWAIT_i      : std_logic;
  signal BIT_CLK_i    : std_logic;
  signal RESET_i      : std_logic;
  signal SYNC_i       : std_logic;
  signal SDATA_OUT_i  : std_logic;
  signal LINE_OUT_R_i : real := 0.0;
  signal LINE_OUT_L_i : real := 0.0;
begin  -- sim

  DUT : entity work.top_system
    port map (
        RELOJ     => RELOJ_i,
        RST       => RST_i,
        ASTRB     => ASTRB_i,
        DSTRB     => DSTRB_i,
        DATA      => DATA_i,
        PWRITE    => PWRITE_i,
        PWAIT     => PWAIT_i,
        bit_clk   => bit_clk_i,
        reset     => reset_i,
        sync      => sync_i,
        sdata_out => sdata_out_i);

  RELOJ_i <= not RELOJ_i after 5 ns;
  RST_i   <= '0' after 258 ns;

  U_EPP : entity work.epp_device_ts
    port map (
      DATA   => DATA_i,
      PWRITE => PWRITE_i,
      DSTRB  => DSTRB_i,
      ASTRB  => ASTRB_i,
      PWAIT  => PWAIT_i);

  codec : entity work.LM4550
    port map (
      BIT_CLK    => BIT_CLK_I,
      RESET      => RESET_I,
      SDATA_OUT  => SDATA_OUT_I,
      SYNC       => SYNC_I,
      LINE_OUT_R => LINE_OUT_R_I,
      LINE_OUT_L => LINE_OUT_L_I);

 process(sync_i)
   file arch_out      : text open write_mode is "../sources/vout.dat";
   variable buffer_wr : line;
   variable vout      : real := 0.0;
 begin  -- process
   if sync_i = '1' and sync_i'event then
     vout := LINE_OUT_L_i;
     write (buffer_wr, vout);
     write (buffer_wr, " ");
     vout := LINE_OUT_R_i;
     write (buffer_wr, vout);
     writeline (arch_out, buffer_wr);
   end if;
 end process;

end sim;
