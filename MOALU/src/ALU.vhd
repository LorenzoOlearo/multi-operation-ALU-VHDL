library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
  generic(
    DATA_WIDTH : integer := 4
    );
  port(
    enable : in std_logic;
    op : in std_logic_vector(1 downto 0);
    x1 : in unsigned(DATA_WIDTH-1 downto 0);
    x2 : in unsigned(DATA_WIDTH-1 downto 0);
    y1 : out unsigned(DATA_WIDTH-1 downto 0);
    y2 : out unsigned(DATA_WIDTH-1 downto 0);
    result : out std_logic_vector(2 downto 0)
    );
end ALU;

architecture ALU_arch of ALU is
  signal enable_muldiv : std_logic;
  signal enable_compare : std_logic;
  signal overflow1 : std_logic;
  signal overflow2 : std_logic;
  signal compare_res : std_logic_vector(2 downto 0);
begin

  enable_muldiv <= not op(1) and enable;
  enable_compare <= op(1) and not op(0) and enable;

  muldiv1 : entity work.twoDivMul
    generic map(
      DATA_WIDTH => DATA_WIDTH
      )
    port map(
      enable => enable_muldiv,
      op => op(0),
      x => x1,
      y => y1,
      overflow => overflow1
      );
    
  muldiv2 : entity work.twoDivMul
    generic map(
      DATA_WIDTH => DATA_WIDTH
      )
    port map(
      enable => enable_muldiv,
      op => op(0),
      x => x2,
      y => y2,
      overflow => overflow2
      );
  
  compare : entity work.comparator
    generic map(
      DATA_WIDTH => DATA_WIDTH
      )
    port map(
      a => x1,
      b => x2,
      result => compare_res
      );

  result(2) <= (enable_compare and compare_res(2)) or (enable_muldiv and overflow1);
  result(1) <= enable_compare and compare_res(1);
  result(0) <= (enable_compare and compare_res(0)) or (enable_muldiv and overflow2);

end ALU_arch;