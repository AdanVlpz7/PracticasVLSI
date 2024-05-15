library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Tx_UART is
  Port (clk    : in std_logic;
        SW     : in std_logic_vector(3 downto 0);
        LED    : out std_logic;
        TX_WIRE: out std_logic
        );
end Tx_UART;

architecture Behavioral of Tx_UART is

signal conta   : integer:= 0;
signal valor   : integer:= 70000;
signal INICIO  : std_logic;
signal dato    : std_logic_vector(7 downto 0);
signal PRE     : integer range 0 to 5208:=0;
signal INDICE  : integer range 0 to 121:=0;
signal BUFF    : std_logic_vector(121 downto 0);
signal flag    : std_logic:='0';
signal PRE_VAL : integer range 0 to 41600;
signal baud    : std_logic_vector(2 downto 0);
signal i       : integer range 0 to 15;
signal j       : integer range 0 to 4;
signal pulso   : std_logic:='0';
signal conta2  : integer range 0 to 50000000:=0;
signal dato_bin: std_logic_vector(3 downto 0);

begin

TX_divisor: process(clk)
            begin
                if rising_edge(clk)then
                    conta<=conta+1;
                    if(conta<50000000)then
                        pulso<='1';
                        conta<=0;
                    else
                        pulso<='0';    
                       
                    end if;
                end if;
            end process;


--en este proceso solo se envia el carcater de cero y salto de linea por default.
TX_prepara: process(clk, pulso)
            type arreglo is array (0 to 1) of std_logic_vector(7 downto 0);
            variable asc_dato: arreglo:= (X"30", X"0A");
				type HEX_VALUES is array(0 to 15) of std_logic_vector(7 downto 0);
				variable valores:HEX_VALUES:=
				(
					 x"56", -- 'V'
					 x"61", -- 'a'
					 x"6C", -- 'l'
					 x"6F", -- 'o'
					 x"72", -- 'r'
					 x"20", -- espacio
					 x"62", -- 'b'
					 x"69", -- 'i'
					 x"6E", -- 'n'
					 x"61", -- 'a'
					 x"72", -- 'r'
					 x"69", -- 'i'
					 x"6F", -- 'o'
					 x"3D",  -- '='
					 x"30", -- 0
					 x"31" -- 1
				);
            begin
                --asc_dato(0):=valores(0);
                if pulso = '1' then
						  if rising_edge(clk) then
								if conta2 = valor then
									 conta2 <= 0;
									 INICIO <= '1';							 
									 if i = 14 then		
											j<=4;
										  --recorrer dato_bin
											if(j > 0) then
												if(SW(j-1) = '1') then
														dato <= valores(15);
														j <= j - 1;
												else 
														dato <= valores(14);
														j <= j - 1;
												end if;
											else
												dato <= asc_dato(1);
												i <= 0;
											end if;											
									 else
										  asc_dato(0):=valores(i);
										  dato <= asc_dato(0);
										  i <= i + 1;    
									 end if;
								else
									 conta2 <= conta2 + 1;
									 INICIO <= '0';    
								end if;
						  end if;
					 end if;
               
            end process;
           
TX_envia: process(clk,inicio,dato)
          begin
            if(clk'event and clk='1')then
                if(flag='0' and INICIO='1')then
                    flag<='1';
                    BUFF(0)<='0'; --bit de inicio de dato en cero
                    BUFF(9)<='1';--bit en uno donde finaliza el dato
						  BUFF(8 downto 1)<=dato;--cadena de bits del dato a transmitir
                end if;
                if(flag='1')then
                    if(PRE<PRE_VAL)then
                        PRE<=PRE+1;
                    else
                        PRE<=0;    
                    end if;
                    if(PRE=PRE_VAL/2)then
									TX_WIRE<=BUFF(INDICE);
                        if(INDICE<9)then
									 
                            INDICE<=INDICE+1;
                        else
                            flag<='0';
                            INDICE<=0;    
                        end if;
                    end if;
                end if;
            end if;
          end process;   
         
LED<=pulso;
dato_bin<=SW;
baud<="011";
               
with(baud) select
    PRE_VAL <= 41600 when "000",     --1200  bauds
               20800 when "001",     --2400  bauds
               10400 when "010",     --4800  bauds
               5200  when "011",     --9600  bauds
               2600  when "100",     --19200 bauds
               1300  when "101",     --38400 bauds
               866   when "110",     --57600 bauds
               432   when others;    --115200 bauds          
                    
end Behavioral;
