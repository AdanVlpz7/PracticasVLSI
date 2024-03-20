library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controlador is
    Port(
        reloj: in std_logic;
        altoBarcos: in std_logic;
        NS : in std_logic;
        OE : in std_logic;
        SUR: out std_logic;
        NORTE: out std_logic;
        ESTE: out std_logic;
        OESTE: out std_logic;
        verde: out std_logic;
        amarillo: out std_logic;
        rojo : out std_logic
    );
end controlador;

architecture Behavioral of controlador is
    signal segundo:std_logic;
    type estados is(s0,s1);
    signal edo_pres,edo_sigu: estados;

begin
    process(reloj)
    begin
        if rising_edge(reloj) then
            edo_pres <= edo_sigu;
        end if;
    end process;
    
    process(edo_pres,NS,OE,altoBarcos,segundo)
    begin
		  oeste<='0';
		  este<='0';
		  norte <= '0';
        sur <= '0';
        case edo_pres is
            when s0 =>
                if altoBarcos = '1' then
						  oeste<='0';
						  este<='0';

						  verde <= '0';
                    amarillo <= '1';
                    rojo <= '0';
                    -- se pone semaforo en rojo despues de un segundo
                    if rising_edge(segundo) then 
                        
                        amarillo <= '0';
								rojo <= '1';
                    end if;
                    -- primero validamos si va de norte a sur o al reves
                    if NS = '1' then
							
                        norte <= '1';
                        sur <= '0';
                        if rising_edge(segundo) then 
                            sur <= '1';
                            norte <= '0';
                        end if;
                    else
                        norte <= '0';
                        sur <= '1';
                        if rising_edge(segundo) then 
                            norte <= '1';
                            sur <= '0';
                        end if;
                    end if;
                    
						  
						  edo_sigu <= s1;
                else
						  
						  verde <= '1'; -- Encendemos el verde
                    amarillo <= '0';
                    rojo <= '0';
                    edo_sigu <= s1;
                end if;
                
            when s1 =>
					 if altoBarcos = '0' then
						 if OE = '1' then
								oeste <= '1';
								este <= '0';
								if rising_edge(segundo) then 
									este <= '1';
									oeste <= '0';
								end if;
								edo_sigu <= s0;
						else
								oeste <= '0';
								este <= '1';
								if rising_edge(segundo) then 
									oeste <= '1';
									este <= '0';
								end if;
								edo_sigu <= s0;
						end if;
					 else
						edo_sigu <= s0;
					 end if;
                
					 
        end case;
    end process;
end Behavioral;