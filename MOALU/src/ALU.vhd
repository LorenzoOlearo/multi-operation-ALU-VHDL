LIBRARY ieee;

USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ALU IS
  GENERIC(
    DATA_WIDTH : integer := 4
    );
  PORT(
    enable : IN  std_logic;
    op     : IN  std_logic_vector(1 DOWNTO 0);
    x1     : IN  unsigned(DATA_WIDTH-1 DOWNTO 0);
    x2     : IN  unsigned(DATA_WIDTH-1 DOWNTO 0);
    y1     : OUT unsigned(DATA_WIDTH-1 DOWNTO 0);
    y2     : OUT unsigned(DATA_WIDTH-1 DOWNTO 0);
    result : OUT std_logic_vector(2 DOWNTO 0)
    );
END ALU;

ARCHITECTURE ALU_arch OF ALU IS
  SIGNAL enable_muldiv  : std_logic;
  SIGNAL enable_compare : std_logic;
  SIGNAL overflow1      : std_logic;
  SIGNAL overflow2      : std_logic;
  SIGNAL compare_res    : std_logic_vector(2 DOWNTO 0);
BEGIN

  enable_muldiv  <= NOT op(1) AND enable;
  enable_compare <= op(1) AND NOT op(0) AND enable;

  muldiv1 : ENTITY work.mul_div
    GENERIC MAP(
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP(
      enable   => enable_muldiv,
      op       => op(0),
      x        => x1,
      y        => y1,
      overflow => overflow1
      );

  muldiv2 : ENTITY work.mul_div
    GENERIC MAP(
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP(
      enable   => enable_muldiv,
      op       => op(0),
      x        => x2,
      y        => y2,
      overflow => overflow2
      );

  compare : ENTITY work.comparator
    GENERIC MAP(
      DATA_WIDTH => DATA_WIDTH
      )
    PORT MAP(
      a      => x1,
      b      => x2,
      result => compare_res
      );

  result(2) <= (enable_compare AND compare_res(2)) OR (enable_muldiv AND overflow1);
  result(1) <= enable_compare AND compare_res(1);
  result(0) <= (enable_compare AND compare_res(0)) OR (enable_muldiv AND overflow2);

END ALU_arch;
