library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity mux4a1 is
port(
A,B,C,D : in STD_LOGIC; --entradas
S0,S1: in STD_LOGIC;  --entradas líneas de selección
Z: out STD_LOGIC  --salidas
);
end mux4a1;

architecture MUX4_1 of mux4a1 is
begin
process (A,B,C,D,S0,S1) is
begin
--basandonos en la canonica
	z<= (NOT S0 AND NOT S1 AND A) OR  (S0 AND NOT S1 AND B) OR (NOT S0 AND S1 AND C) OR (S0 AND S1 AND D);
end process;
 
end MUX4_1;