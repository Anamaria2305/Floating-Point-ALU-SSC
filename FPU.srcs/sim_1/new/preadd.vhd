----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2021 12:26:21 AM
-- Design Name: 
-- Module Name: preadd - Behavioral
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

entity preadd is
--  Port ( );
end preadd;

architecture Behavioral of preadd is
component PreAdder
Port (
clk:in std_logic;
Number1,Number2 : in std_logic_vector(31 downto 0); 
Operation: in std_logic;
SpecialCase: out std_logic;
ZeroFlag:out std_logic;
DisplayResult: out std_logic_vector (31 downto 0)
);
end component;

signal Operation,clk,zf,sc: std_logic;
signal A,B,DisplayResult: std_logic_vector (31 downto 0);
begin
label1: PreAdder port map (clk,A,B,Operation,sc,zf,DisplayResult);
process
begin
clk<='1';
wait for 20ns;
clk<='0';
wait for 20ns;
end process;

process
begin
Operation<='0';
A<="01111111100000000000000000000000";
B<="01111111100000000000000000000000";
wait for 100 ns;
end process;

end Behavioral;
