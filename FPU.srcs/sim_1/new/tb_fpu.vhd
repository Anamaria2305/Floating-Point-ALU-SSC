----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/12/2021 11:06:06 PM
-- Design Name: 
-- Module Name: tb_fpu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_fpu is
--  Port ( );
end tb_fpu;

architecture Behavioral of tb_fpu is

component top 
Port ( 
reset:in std_logic;
Operation: in std_logic;
clk:in std_logic;
A: in  std_logic_vector(31 downto 0);
B: in  std_logic_vector(31 downto 0);
DisplayResult: out std_logic_vector (31 downto 0);
FlagReg: out std_logic_vector (2 downto 0)
);
end component;
component ROM
port(clk: in std_logic;
address: in integer range 0 to 15;
data: out std_logic_vector(31 downto 0));
end component;
signal reset,Operation,clk: std_logic;
signal A,B,DisplayResult: std_logic_vector (31 downto 0);
signal FlagReg: std_logic_vector (2 downto 0);
signal address : integer:=0;
signal address_2 : integer:=0;
begin
 label1:top port map(reset,Operation,clk,A,B,DisplayResult,FlagReg);
 label2: ROM port map(clk,address,A);
 label3: ROM port map (clk,address_2,B);
process
begin
clk<='1';
wait for 10ns;
clk<='0';
wait for 10ns;
end process;

process
begin
--  -3750.11
--  2.00021
reset<='1';
Operation<='1';
address<=12; --2.5
address_2<=14;-- 3

wait for 300ns;

reset<='0';

wait for 30ns;
reset<='1';
Operation<='0';
address<=12; -- -11.5
address_2<=14; --117
wait for 300ns;

reset<='0';
wait for 30ns;
reset<='1';
Operation<='1';
address<=6; -- 1000
address_2<=6; --1000
wait for 300ns;

reset<='0';
wait for 30ns;
reset<='1';
Operation<='0';
address<=2; -- +inf
address_2<=2;  --+inf
wait for 300ns;

reset<='0';
wait for 30ns;
reset<='1';
Operation<='0';
address<=5; -- greatest number
address_2<=5;  --greatest number
wait for 300ns;

reset<='0';
wait for 30ns;
reset<='1';
Operation<='0';
address<=15; -- 0.25
address_2<=5;  --greatest number
wait for 300ns;
end process;
end Behavioral;
