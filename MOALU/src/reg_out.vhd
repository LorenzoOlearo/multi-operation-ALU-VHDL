library ieee;
use ieee.std_logic_1164.all;


entity reg_out is
  generic(
    DATA_WIDTH : integer := 4
    );

  port(
    clk    : in std_logic;
    rst    : in std_logic;
    enable : in std_logic;

    y1_in   : in std_logic_vector(DATA_WIDTH-1 downto 0);
    y2_in   : in std_logic_vector(DATA_WIDTH-1 downto 0);
    result_in : in std_logic_vector(2 downto 0);

    y1_out   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    y2_out   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    result_out : out std_logic_vector(2 downto 0)
    );
end entity reg_out;


architecture reg_out_arch of reg_out is

begin

  process(clk, rst) is
  begin
    if rst = '1' then
      y1_out   <= (others => '0');
      y2_out   <= (others => '0');
      result_out <= (others => '0');
    elsif clk'event and clk = '1' then
      if enable = '1' then
        y1_out   <= y1_in;
        y2_out   <= y2_in;
        result_out <= result_in;
      end if;
    end if;
  end process;

end architecture reg_out_arch;
