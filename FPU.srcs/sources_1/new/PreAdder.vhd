library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity PreAdder is
Port (
clk:in std_logic;
Number1,Number2 : in std_logic_vector(31 downto 0); 
Operation: in std_logic;
SpecialCase: out std_logic;
ZeroFlag:out std_logic;
DisplayResult: out std_logic_vector (31 downto 0)
);
end PreAdder;

architecture Behavioral of PreAdder is

begin
process(Number1,Number2,Operation)
variable var: std_logic_vector(2 downto 0);
begin
var:="000";
-- if both are 0 or -0 the result is 0
if   ( Number1 = "00000000000000000000000000000000" and Number2 = "00000000000000000000000000000000" )    then
    DisplayResult<= "00000000000000000000000000000000";
    ZeroFlag<='1';
    SpecialCase<='0';
    var:="001";
end if;
if   ( Number1 = "10000000000000000000000000000000" and Number2 = "10000000000000000000000000000000" )    then
    DisplayResult<= "00000000000000000000000000000000";
    ZeroFlag<='1';
    SpecialCase<='0';
    var:="001";
end if;
if   ( Number1 = "00000000000000000000000000000000" and Number2 = "10000000000000000000000000000000" )    then
    DisplayResult<= "00000000000000000000000000000000";
    ZeroFlag<='1';
    SpecialCase<='0';
    var:="001";
end if;
if   ( Number1 = "10000000000000000000000000000000" and Number2 = "00000000000000000000000000000000" )    then
    DisplayResult<= "00000000000000000000000000000000";
    ZeroFlag<='1';
    SpecialCase<='0';
    var:="001";
end if;
-- daca primul nr e 0, daca e adunare rezultatul e exact celalalt nr, daca e scadere doar schimbam bitul de semn
if ( Number1 = "10000000000000000000000000000000" or Number1 = "00000000000000000000000000000000" )then
  if(var = "000")then
    if (Operation = '0')then -- adunare
        DisplayResult<=Number2;
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="011";
    else
        DisplayResult<= ( not Number2(31) ) & Number2(30 downto 0);
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="011";
    end if;
    end if;
end if;
--daca al doilea nr e 0, indiferent de operatie, rezultatul e primul
if ( Number2 = "10000000000000000000000000000000" or Number2 = "00000000000000000000000000000000" )then
  if (var="000") then
        DisplayResult<=Number1;
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="011";
        end if;
end if;
-- if both are + - infinite the result is undefined
if( Number1="01111111100000000000000000000000" and Number2="01111111100000000000000000000000" )then
        DisplayResult<="01111111100000000000000000000001";
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
end if;
if( Number1="11111111100000000000000000000000" and Number2="11111111100000000000000000000000" )then
        DisplayResult<="01111111100000000000000000000001";
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
end if;
if( Number1="11111111100000000000000000000000" and Number2="01111111100000000000000000000000" )then
        DisplayResult<="01111111100000000000000000000001";
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
end if;
if( Number1="01111111100000000000000000000000" and Number2="11111111100000000000000000000000" )then
        DisplayResult<="01111111100000000000000000000001";
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
end if;
-- daca unul dintre ele e + sau - infinite, rez depinde de op
if( Number1="01111111100000000000000000000000" or Number1="11111111100000000000000000000000" )then
        DisplayResult<=Number1;
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
end if;
if( Number2="01111111100000000000000000000000" or Number2="11111111100000000000000000000000" )then
    if (Operation = '0')then -- adunare
        DisplayResult<=Number2;
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
    else
        DisplayResult<= ( not Number2(31) ) & Number2(30 downto 0);
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
end if;
end if;
--daca unul e nan , rezultatul e nan
if( Number1="01111111100000000000000000000001" or Number2="01111111100000000000000000000001" )then
        DisplayResult<="01111111100000000000000000000001";
        ZeroFlag<='0';
        SpecialCase<='1';
        var:="111";
    
end if;
--daca adunam numere de semne diferite rez e 0
if( (Number1(30 downto 0)= Number2(30 downto 0 )) and ( Number1(31)= not Number2(31)) ) then
   if(Operation='0')then
        DisplayResult<="00000000000000000000000000000000";
        ZeroFlag<='1';
        SpecialCase<='0';
        var:="111";
   end if;
end if;
--daca scadem numere egale rez e 0
if( Number1=Number2 ) then
   if(Operation='1')then
        DisplayResult<="00000000000000000000000000000000";
        ZeroFlag<='1';
        SpecialCase<='0';
        var:="111";
   end if;
end if;

if(var="000") then
        DisplayResult<="01111111100000000000000000000001";
        ZeroFlag<='0';
        SpecialCase<='0';
end if;

end process;
end Behavioral;
