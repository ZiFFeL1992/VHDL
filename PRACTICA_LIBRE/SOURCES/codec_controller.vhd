library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity codec_controller is
  port (
    RST        : in  std_logic;
    BIT_CLK    : in  std_logic;
    CLK        : in  std_logic;
    VOL_CODE   : in  std_logic_vector(4 downto 0);
    RESTART    : in  std_logic;
    CHANNEL    : in  std_logic_vector(1 downto 0);
    RESET      : out std_logic;
    SYNC       : out std_logic;
    FREC_CODE  : in  std_logic_vector(7 downto 0);
    SDATA_OUT  : out std_logic);
end codec_controller;


architecture rtl of codec_controller is

  signal   cmd_addr     : std_logic_vector(19 downto 0);
  signal   cmd_data     : std_logic_vector(19 downto 0);
  signal   sync_counter : unsigned(7 downto 0);
  signal   left_data    : std_logic_vector(19 downto 0);
  signal   right_data   : std_logic_vector(19 downto 0);
  constant Tag          : std_logic_vector(15 downto 0) := X"F800";

  signal address : unsigned(11 downto 0);
  signal data    : std_logic_vector(19 downto 0);


  -- reset
  constant CLK_DIV     : integer := 110;
  signal   rst_counter : integer range 0 to CLK_DIV; -- 100 should be enought but just making sure
  signal   reset_aux   : std_logic;


  -- prescaler
  signal prescaler_counter : unsigned(7 downto 0);
  signal prescaler_ce      : std_logic;
  signal prescaler_aux     : std_logic;

  -- sync
  signal sync_ce : std_logic;

  -- counter
  signal contador_aux : unsigned(11 downto 0);

  -- fsm
  type FSM is (S0, S1, S2, S3);
  signal std_act, prox_std : FSM;

begin  -- rtl



  memoria : entity work.seno_4kX20
    port map (
      clk  => clk,
      addr => std_logic_vector(address),
      dout => data );



  --Trama de salida SDATA_OUT
  process (clk, rst)
  begin
    if rst = '1' then
      sdata_out <= '0';
    elsif clk'event and clk = '1' then
      if reset_aux = '0' then
        sdata_out <= '0';
      elsif (sync_counter < 15) then
        sdata_out <= tag(15 - to_integer(sync_counter));
      elsif (sync_counter >= 16) and (sync_counter <= 35) then  --Slot 1 : Command address
        sdata_out <= cmd_addr(35 - to_integer(sync_counter));
      elsif (sync_counter >= 36) and (sync_counter <= 55) then  --Slot 2 : Command data
        sdata_out <= cmd_data(55 - to_integer(sync_counter));
      elsif ((sync_counter >= 56) and (sync_counter <= 75)) then  --Slot 3 : left channel
        sdata_out <= left_data(75 - to_integer(sync_counter));
      elsif ((sync_counter >= 76) and (sync_counter <= 95)) then  --Slot 4 : right channel
        sdata_out <= right_data(95 - to_integer(sync_counter));
      else
        sdata_out <= '0';
      end if;
    end if;
  end process;


  process(clk, rst)
  begin
    if rst = '1' then
      rst_counter <= 0;
      reset_aux <= '1';
    elsif clk'event and clk = '1' then
      if restart = '1' then
        rst_counter <= 0;
        reset_aux <= '1';
      else
        if rst_counter < CLK_DIV then
          rst_counter <= rst_counter + 1;
          reset_aux <= '0';
        else
          reset_aux <= '1';
        end if;
      end if;
    end if;
  end process ; -- reset_aux

  reset <= '1' when reset_aux = '1' else '0';


  process(bit_clk, rst)
  begin
    if rst = '1' then
      sync_counter <= x"FE";
      sync <= '0';
    elsif bit_clk'event and bit_clk = '1' then
      sync_counter <= sync_counter + 1;
      if sync_counter = 254 then
        sync <= '1';
      elsif sync_counter = 14 then
        sync <= '0';
      end if ;
    end if;
  end process ; -- sync_counter

  sync_ce <= '1' when (sync_counter = 222) else '0';


  prescaler : process(clk, rst)
  begin
    if rst = '1' then
      prescaler_counter <= (others => '0');
    elsif clk'event and clk = '1' then
      prescaler_counter <= prescaler_counter + 1;
      if (prescaler_counter = unsigned(FREC_CODE)) then
        prescaler_aux <= '1';
        prescaler_counter <= (others => '0');
      else
        prescaler_aux <= '0';
      end if ;
    end if;
  end process ; -- prescaler

  prescaler_ce <= '1' when prescaler_aux = '1' else '0';


  contador : process(clk, rst, prescaler_ce)
  begin
    if rst = '1' then
      contador_aux <= (others => '0');
    elsif clk'event and clk = '1' then
      if prescaler_ce = '1' then
        contador_aux <= contador_aux + 1;
      end if;
    end if;
  end process ; -- contador

  address <= contador_aux;


  states : process(std_act)
  begin
    case(std_act) is
      when S0 =>
        prox_std <= S1;
      when S1 =>
        prox_std <= S2;
      when S2 =>
        prox_std <= S3;
      when S3 =>
        prox_std <= S1;
    end case ;
  end process ; -- states

  change_state : process(bit_clk, rst)
  begin
    if rst = '1' then
      std_act <= S0;
    elsif bit_clk'event and bit_clk = '1' then
      if sync_ce = '1' then
        std_act <= prox_std;
      end if ;
    end if ;
  end process ; -- change_state

  assigns : process(std_act, vol_code)
  begin
    case(std_act) is
      when S0 =>
        cmd_addr <= x"00000"; -- npi
        cmd_data <= x"00000"; -- npi
      when S1 => -- 20h
        cmd_addr <= x"20000";
        cmd_data <= x"80000";
      when S2 => -- 18h
        cmd_addr <= x"18000";
        cmd_data <= x"08080";
      when S3 => -- 02h
        cmd_addr   <= x"02000";
        cmd_data   <= b"000" & vol_code & b"000" & vol_code & x"0";
    end case ;
  end process ; -- assigns

  channels : process(bit_clk, rst, sync_ce)
  begin
    if rst = '1' then
      left_data  <= (others => '0');
      right_data <= (others => '0');
    elsif bit_clk'event and bit_clk = '1' then
      if sync_ce = '1' then
        if channel = "00" then
          left_data  <= x"00000";
          right_data <= x"00000";
        elsif channel = "01" then
          left_data  <= data;
          right_data <= x"00000";
        elsif channel = "10" then
          left_data  <= x"00000";
          right_data <= data;
        else
          left_data  <= data;
          right_data <= data;
        end if ;
      end if ;
    end if ;
  end process ; -- channels

end rtl;
