
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
  -- out EPP
  signal DIR_AUX       : std_logic_vector(7 downto 0)
  signal DATO_AUX      : std_logic_vector(7 downto 0);
  signal DATOS_VLD_AUX : std_logic;

  -- out DECODER
  signal RESTART_AUX       : std_logic;
  signal VOL_CODE_AUX      : std_logic_vector(4 downto 0;
  signal FREC_CODE_AUX     : std_logic_vector(7 downto 0);
  signal CHANNEL_AUX       : std_logic_vector(1 downto 0);


begin

  epp : entity work.epp_controller
    port map (
      CLK       => RELOJ,
      RST       => RST,
      ASTRB     => ASTRB,
      DSTRB     => DSTRB,
      DATA      => DATA,
      PWRITE    => PWRITE,
      PWAIT     => PWAIT,
      DIR       => DIR_AUX,
      DATO      => DATO_AUX,
      DATOS_VLD => DATOS_VLD_AUX
    );
  end;

  decoder : entity work.decoder_epp
    port map (
      CLK       => RELOJ,
      RST       => RST,
      DIR       => DIR_AUX,
      DATO      => DATO_AUX,
      DATOS_VLD => DATOS_VLD_AUX,
      RESTART   => RESTART_AUX,
      VOL_CODE  => VOL_CODE_AUX,
      FREC_CODE => FREC_CODE_AUX,
      CHANEL    => CHANNEL_AUX
    );
  end;

  codec : entity work.codec_controller
    port map (
      RST       => RST,
      BIT_CLK   => BIT_CLK,
      CLK       => RELOJ,
      VOL_CODE  => VOL_CODE_AUX,
      RESTART   => RESTART_AUX,
      CHANNEL   => CHANNEL_AUX,
      RESET     => RESET,
      SYNC      => SYNC
      FREC_CODE => FREC_CODE_AUX,
      SDATA_OUT => SDATA_OUT
    );
  end;

end rtl;
