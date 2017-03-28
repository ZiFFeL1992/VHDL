library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity LM4550 is
  port (
    BIT_CLK    : out std_logic;
    RESET      : in  std_logic;
    SDATA_OUT  : in  std_logic;
    sync       : in  std_logic;
    LINE_OUT_R : out real;
    LINE_OUT_L : out real);
end ;

architecture sim of LM4550 is

  constant TBCP                       : time := 81.4 ns;
  constant TRST2CLK                   : time := 162.8 ns;
  signal   BIT_CLK_i                  : std_logic;
  signal   SYNC_i                     : std_logic;
  signal   clk_i                      : std_logic := '0';
  signal   bits_trama_counter         : unsigned(7 downto 0);
  signal   trama                      : std_logic_vector(0 to 255);
  signal   REG_20,DATA_REG            : std_logic_vector(15 downto 0) := (others  => '0');
  signal   DIR_REG                    : std_logic_vector(6 downto 0) := (others  => '0');
  signal   REG_18, REG_02             : std_logic_vector(15 downto 0) := (15 => '1', others => '0');
  signal   dac_in_r, dac_in_l         : std_logic_vector(19 downto 0) := ( others => '0'); 
  signal   dac_out_r, dac_out_l       : real := 0.0;
  signal   out_gn_r, out_gn_l         : real := 0.0;
  signal   output_r, output_l         : real := 0.0;
  signal   master_gn_r, master_gn_l   : real := 0.0;
  signal   stereo_mix_r, stereo_mix_l : real := 0.0;
  signal   out_vol_r, out_vol_l       : std_logic_vector(4 downto 0) := (others  => '0');
  signal   mute_out, pop              : std_logic := '0';
  signal mute_master                  : std_logic := '0';
  signal master_vol_r, master_vol_l   : std_logic_vector(4 downto 0) := (others => '0');

begin  -- sim


  process
  begin
    BIT_CLK_i <= '0';
    wait until RESET = '1';
    if SDATA_OUT = '1' then
	    wait for 15.7 ns;
      BIT_CLK_i <= 'Z';
      wait until RESET = '0';
    else
      wait for TRST2CLK  ;
      while RESET = '1' loop
        BIT_CLK_i <= '1';
        wait for TBCP/2;
        BIT_CLK_i <= '0';
        wait for TBCP/2;
      end loop;
    end if;
  end process;

  BIT_CLK <= BIT_CLK_i;

  clk_i <= not clk_i after 5 ns;

  process (clk_i)
  begin  -- process
    if clk_i'event and clk_i = '0' then
      SYNC_i <= SYNC;
    end if;
  end process;

--lectura de datos
  process (BIT_CLK_i, SYNC_i, RESET)
  begin  -- process
    if RESET = '0' then
      bits_trama_counter <= (others => '0');
    elsif SYNC_i'event and SYNC_i = '1' then
      bits_trama_counter <= (others => '1');
    elsif BIT_CLK_i'event and BIT_CLK_i = '0' then
      bits_trama_counter <= bits_trama_counter+1;
    end if;
  end process;

  process (BIT_CLK_i, RESET)
  begin  -- process
    if RESET = '0' then
      trama <= (others => '0');
    elsif BIT_CLK_i'event and BIT_CLK_i = '0' then  -- rising clock edge
      trama(to_integer(bits_trama_counter)) <= SDATA_OUT;
    end if;
  end process;

  process (BIT_CLK_i, RESET)
  begin
    if RESET = '0' then
      REG_02   <= (15 => '1', others => '0');
      REG_18   <= (15 => '1', others => '0');
      REG_20   <= (others => '0');
      REG_20   <= (others => '0');
      dac_in_l <= (others => '0');
      dac_in_r <= (others => '0');
      DIR_REG  <= (others => '0');
      DATA_REG <= (others => '0');
    elsif (BIT_CLK_i'event and BIT_CLK_i = '1') then
      if (bits_trama_counter = 0) then
        if trama(0 to 2) = "111" and trama(16) = '0' then  -- escritura en el registro
		      DIR_REG <= trama(17 to 23); -- añadido para testear los diseños
			    DATA_REG <= trama(36 to 51);
          if trama(17 to 23) = "0011000" then     --18 (PCM Out Volume)
            REG_18 <= trama(36 to 51);
          elsif trama(17 to 23) = "0100000" then  --20 (General Purpose register)
            REG_20 <= trama(36 to 51);
          elsif trama(17 to 23) = "0000010" then  --02 (Master Volume Register)
            REG_02 <= trama(36 to 51);
          end if;
        end if;
        if trama(3) = '1' then
          dac_in_l <= trama(56 to 75);
        end if;
        if trama(4) = '1' then
          dac_in_r <= trama(76 to 95);
        end if;
      end if;
    end if;
  end process;

  dac_out_r <= real(to_integer(signed(dac_in_r(19 downto 2))))*2.0/262144.0;
  dac_out_l <= real(to_integer(signed(dac_in_l(19 downto 2))))*2.0/262144.0;

  out_vol_r <= REG_18(4 downto 0);
  out_vol_l <= REG_18(12 downto 8);
  mute_out  <= REG_18(15);

  process (out_vol_r, out_vol_l, mute_out) is
  begin
    if mute_out = '1' then
      out_gn_r <= 0.0;
      out_gn_l <= 0.0;
    else
      out_gn_r <= 10.0**((12.0-real(to_integer(unsigned(out_vol_r)))*1.5)/20.0);
      out_gn_l <= 10.0**((12.0-real(to_integer(unsigned(out_vol_l)))*1.5)/20.0);
    end if;
  end process;

  output_r <= dac_out_r*out_gn_r;
  output_l <= dac_out_l*out_gn_l;

  pop <= REG_20(15);

  stereo_mix_r <= output_r when pop = '1' else 0.0;

  stereo_mix_l <= output_l when pop = '1' else 0.0;

  master_vol_r <= REG_02(4 downto 0);
  master_vol_l <= REG_02(12 downto 8);
  mute_master  <= REG_02(15);

  process (master_vol_r, master_vol_l, mute_master) is
   begin
     if mute_master = '1' then
       master_gn_r <= 0.0;
       master_gn_l <= 0.0;
     else
       master_gn_r <= 10.0**((0.0-real(to_integer(unsigned(master_vol_r)))*1.5)/20.0);
       master_gn_l <= 10.0**((0.0-real(to_integer(unsigned(master_vol_l)))*1.5)/20.0);
     end if;
   end process;

   LINE_OUT_R <= stereo_mix_r*master_gn_r;
   LINE_OUT_L <= stereo_mix_l*master_gn_l;



end sim;

-------------------------------------------------------------------------------
