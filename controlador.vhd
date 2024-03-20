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
        rojo : buffer std_logic
    );
end controlador;

architecture Behavioral of controlador is
    signal segundo : std_logic;
    signal cuenta  : integer range 0 to 40000000 := 0;  -- El rango debe coincidir con la cantidad de ciclos necesarios para un segundo con tu frecuencia de reloj

    type estados is (s0, s1);
    signal edo_pres, edo_sigu: estados;

begin

    divisor: process(reloj)
    begin
        if rising_edge(reloj) then
            cuenta <= cuenta + 1;  -- Incrementar el contador en cada flanco de subida del reloj principal

            -- Si el contador alcanza el valor necesario para representar un segundo, se cambia el estado de segundo
            if cuenta = 40000000 then  -- Ajusta este valor según tu frecuencia de reloj
                segundo <= not segundo;  -- Cambiar segundo cada segundo
                cuenta  <= 0;  -- Reiniciar el contador
            end if;
        end if;
    end process;

    process(reloj)
    begin
        if rising_edge(reloj) then
            edo_pres <= edo_sigu;  -- Actualizar el estado actual
        end if;
    end process;

    process(edo_pres, NS, OE, altoBarcos, segundo)
    begin
        oeste  <= '0';
        este   <= '0';
        norte  <= '0';
        sur    <= '0';
        verde  <= '0';
        amarillo <= '0';
        rojo   <= '0';

        case edo_pres is
            when s0 =>
                if altoBarcos = '1' then
                    verde     <= '0';
                    amarillo  <= '1';
                    rojo      <= '0';
                    if segundo = '1' then
                        amarillo <= '0';
                        rojo     <= '1';
                    end if;

                    if NS = '1' then
                        norte <= '1';
                    else
                        sur   <= '1';
                    end if;
                    edo_sigu <= s1;
                else
                    verde     <= '1';
                    edo_sigu <= s1;
                end if;
            when s1 =>
					 if altoBarcos = '0' then
						 if OE = '1' then
							  oeste <= '1';
						 else
							  este  <= '1';
						 end if;
					 end if;
                edo_sigu <= s0;
        end case;
    end process;

end Behavioral;
