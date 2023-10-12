library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity top is
Port ( 
reset:in std_logic;
Operation: in std_logic;
clk:in std_logic;
A: in  std_logic_vector(31 downto 0);
B: in  std_logic_vector(31 downto 0);
DisplayResult: out std_logic_vector (31 downto 0);
FlagReg: out std_logic_vector (2 downto 0)
);
end TOP;

architecture Behavioral of TOP is

component CU is
  port(A      : in  std_logic_vector(31 downto 0);
       B      : in  std_logic_vector(31 downto 0);
       clk,enable,Operation    : in  std_logic;
       reset  : in  std_logic;
       start  : in  std_logic;
       done   : out std_logic;
       sum : out std_logic_vector(31 downto 0);
       ovf: out std_logic
       );
end component;

component PreAdder
port(clk:in std_logic;
Number1,Number2 : in std_logic_vector(31 downto 0); 
Operation: in std_logic;
SpecialCase: out std_logic;
ZeroFlag:out std_logic;
DisplayResult: out std_logic_vector (31 downto 0)
--;
--S1,S2:out std_logic;
--E1,E2:out std_logic_vector (7 downto 0);
--M1,M2: out std_logic_vector (22 downto 0)
);
end component;
signal zero,sc : std_logic := '0';
signal enable: std_logic:='0';
signal sum1,sum2: std_logic_vector(31 downto 0);
signal done: std_logic;
signal ovf:std_logic;
begin


Label1: PreAdder port map (clk,A,B,Operation,sc,zero,sum1);
Label2: CU port map (A,B,clk,enable,Operation,'0',reset,done,sum2,ovf);

FlagReg(0)<=zero;
FlagReg(1)<=sc;
FlagReg(2)<=ovf;

process(zero,sc,done,ovf)
begin
if (zero='1' or sc='1' ) then
DisplayResult<=sum1;
else
if(done='1') then
DisplayResult<=sum2;
else
DisplayResult<="00000000000000000000000000000000";
end if;
end if;
end process;


end architecture;
