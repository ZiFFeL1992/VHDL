entity epp_controller is
  port (
    CLK : in std_logic;
    RST : in std_logic;
    ASTRB : in std_logic;
    DSTRB : in std_logic;
    DATA : in std_logic_vector(7 downto 0);
    PWRITE : in std_logic;
    PWAIT : out std_logic;
    DIR : out std_logic_vector(7 downto 0);
    DATO : out std_logic_vector(7 downto 0);
    DATOS_VLD : in std_logic
  ) ;
end entity ; -- epp_controller