library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity pwm is
  Port ( reloj_pwm: in std_logic;
         D: in std_logic_vector(7 downto 0);
         S: out std_logic  
        );
end pwm;

architecture Behavioral of pwm is

begin
process(reloj_pwm)
    variable cuenta: integer range 0 to 255:=0;
begin
    if(reloj_pwm='1' and reloj_pwm'event)then
        cuenta:=(cuenta+1)mod 256;
        if(cuenta < D)then
            S<='1';
        else
            S<='0';    
        end if;
    end if;    
end process;


end Behavioral;