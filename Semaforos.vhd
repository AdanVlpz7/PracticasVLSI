
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;
entity Semaforos is
    Port(
        clk : in std_logic; -- Reloj
        rst : in std_logic; -- Reset
        entrada1 : in std_logic; --Tb
        entrada2 : in std_logic; --Ta
        semaforo1_verde, semaforo1_amarillo, semaforo1_rojo : out std_logic; --semaforos bici
        semaforo2_verde, semaforo2_amarillo, semaforo2_rojo : out std_logic  --semaforos alumnos
    );
end entity Semaforos;

architecture Behavioral of Semaforos is
    
    signal segundo : std_logic;
    type estados is (s0,s1,s2,s3);
    signal edo_pres, edo_sigu: estados;
    --signal prueba: std_logic;
begin
    
    process(clk)
        variable cuenta: std_logic_vector(27 downto 0):=X"0000000";
        begin
        if rising_edge(clk)then
            if(cuenta=X"48009E0")then
                cuenta:=X"0000000";
					 
            else
                cuenta:=cuenta+1;    
            end if;
        end if;
        segundo<=cuenta(22);    
        end process;

	 process(segundo,rst)
    begin
		  if(rst = '0') then
				edo_pres <= s0;
		  elsif(clk'event and clk='1') then 
				edo_pres <= edo_sigu;  -- Actualizar el estado actual
		  end if;
    end process;

	 
	 process(entrada1, entrada2, segundo,clk,rst)
	 variable contadorSeg :integer := 0;
	 
    begin
		  --prueba <= entrada1;
		  --reset de semaforos
	     semaforo1_verde <= '0';
		  semaforo2_rojo <= '0';
		  semaforo1_amarillo <= '0';
		  semaforo1_rojo <= '0';
		  semaforo2_verde <= '0';
		  semaforo2_amarillo <= '0';
		  case edo_pres is
				when s0 =>
					semaforo2_amarillo <= '0';
					semaforo1_rojo <= '0';
					if entrada1 ='0' then
						contadorSeg := 0;
						edo_sigu <= s1;											
					elsif entrada1 = '1' then 
						semaforo1_verde <= '1';
						semaforo2_rojo <= '1';
						edo_sigu <= s0;
					end if;
				when s1 =>
					semaforo1_verde <= '0';
					semaforo1_amarillo <= '1';
					semaforo2_rojo <= '1';
					
					if(contadorSeg = 5) then
						semaforo1_amarillo <= '0';
						semaforo2_rojo <= '0';
						edo_sigu <= s2;
					else 
						contadorSeg := contadorSeg +1;
						edo_sigu <= s1;
					end if;
				when s2 =>				
					if (entrada2 = '0') then 
						edo_sigu <= s3;
						contadorSeg := 0;
					elsif (entrada2 = '1') then
						contadorSeg := 0;
						edo_sigu <= s2;
						semaforo1_rojo <= '1';
						semaforo2_verde <= '1';						
					end if;
				when s3 =>
					semaforo2_verde <= '0';
					semaforo2_amarillo <= '1';
					semaforo1_rojo <= '1';
					semaforo1_amarillo <= '0';
					semaforo2_rojo <= '0';
					if(contadorSeg = 5) then
						edo_sigu <= s0;
					else 
						contadorSeg := contadorSeg +1;
						edo_sigu <= s3;
					end if;
		  
		  end case;
    end process;
   
    
end architecture Behavioral;
