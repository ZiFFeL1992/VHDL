entity top_system is
  port (
    RELOJ : in std_logic;
    RST : in std_logic;
    ASTRB : in std_logic;
    DSTRB : in std_logic;
    DATA: in std_logic_vector(7 downto 0);
    PWRITE : in std_logic;
    PWAIT : out std_logic;
    BIT_CLK : in std_logic;
    RESET : out std_logic;
    SYNC : out std_logic;
    SDATA_OUT : out std_logic
  ) ;
end entity ; -- top_system