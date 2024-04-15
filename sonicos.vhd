library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity sonicos is
  Port (clk    	: in std_logic;
    	sensor_eco : in std_logic;
    	sensor_disp: out std_logic;
    	display1 	: out std_logic_vector (7 downto 0);
    	display2 	: out std_logic_vector (7 downto 0);
		display3 	: out std_logic_vector (7 downto 0)
    	);
end sonicos;

architecture Behavioral of sonicos is

signal cuenta      	: unsigned (16 downto 0):=(others=>'0');
signal centimetros 	: unsigned (15 downto 0):=(others=>'0');
signal centimetros_unid: unsigned (3 downto 0) :=(others=>'0');
signal centimetros_dece: unsigned (3 downto 0) :=(others=>'0');
signal sal_unid    	: unsigned (3 downto 0) :=(others=>'0');
signal sal_dece    	: unsigned (3 downto 0) :=(others=>'0');
signal digito1     	: unsigned (3 downto 0) :=(others=>'0');
signal digito2     	: unsigned (3 downto 0) :=(others=>'0');
signal eco_pasado  	: std_logic:='0';
signal eco_sinc    	: std_logic:='0';
signal eco_nsinc   	: std_logic:='0';
signal espera      	: std_logic:='0';
signal siete_seg_cuenta: unsigned (15 downto 0):=(others=>'0');

signal anodo1: std_logic_vector(7 downto 0);


begin
   --En este proceso se despliega el resultado de la distanciaa calculada.
--sean unidades o decenas.

	siete_seg:process(clk, siete_seg_cuenta)
          	begin                                                               	 
            	if rising_edge(clk)then                                         	 
                	if siete_seg_cuenta(siete_seg_cuenta'high)='1'then             	 
                    	digito2<=sal_unid;
                	else
                    	digito1<=sal_dece;
                	end if;
            	end if;
          	 
            	siete_seg_cuenta<=siete_seg_cuenta+1;
          	end process;
	trigger:process(clk)
        	begin
            	if rising_edge(clk)then
                	if (espera='0')then
                    	if(cuenta=500)then
                        	sensor_disp<='0';
                        	espera<='1';
                        	cuenta<=(others=>'0');
                    	else
                        	sensor_disp<='1';
                        	cuenta<=cuenta+1;    
                    	end if;
                	elsif (eco_pasado='0'and eco_sinc='1')then
                    	cuenta<=(others=>'0');
                    	centimetros<=(others=>'0');
                    	centimetros_unid<=(others=>'0');
                    	centimetros_dece<=(others=>'0');
                	elsif (eco_pasado='1' and eco_sinc='0')then
                    	sal_unid<=centimetros_unid;
                    	sal_dece<=centimetros_dece;
                	elsif (cuenta=2900-1)then
                    	if (centimetros_unid=9)then
                        	centimetros_unid<=(others=>'0');
                        	centimetros_dece<=centimetros_dece+1;
                    	else
                        	centimetros_unid<=centimetros_unid+1;    
                    	end if;
                 	centimetros<=centimetros+1;
                 	cuenta<=(others=>'0');
                  	 
                    	if(centimetros=3448)then
                        	espera<='0';
                    	end if;
                 	else
                    	cuenta<=cuenta+1;  
                 	end if;
                 	eco_pasado<=eco_sinc;
                 	eco_sinc<=eco_nsinc;
                 	eco_nsinc<=sensor_eco;       	 
            	end if;
          	 
        	end process;

decodificador:process(digito1)
          	begin
            	if	digito1=X"0" then display2 <="11000000";
            	elsif digito1=X"1" then display2 <="11111001";
            	elsif digito1=X"2" then display2 <="10100100";
            	elsif digito1=X"3" then display2 <="10110000";
            	elsif digito1=X"4" then display2 <="10011001";
            	elsif digito1=X"5" then display2 <="10010010";
            	elsif digito1=X"6" then display2 <="10000010";
            	elsif digito1=X"7" then display2 <="11111000";
            	elsif digito1=X"8" then display2 <="10000000";
            	elsif digito1=X"9" then display2 <="10011000";
            	else
                	display2<="11000000";
            	end if;    
          	end process;
        	 
decodificador2:process(digito2)
          	begin
            	if	digito2=X"0" then display1 <="11000000";
            	elsif digito2=X"1" then display1 <="11111001";
            	elsif digito2=X"2" then display1 <="10100100";
            	elsif digito2=X"3" then display1 <="10110000";
            	elsif digito2=X"4" then display1 <="10011001";
            	elsif digito2=X"5" then display1 <="10010010";
            	elsif digito2=X"6" then display1 <="10000010";
            	elsif digito2=X"7" then display1 <="11111000";
            	elsif digito2=X"8" then display1 <="10000000";
            	elsif digito2=X"9" then display1 <="10011000";
            	else
                	display1<="11000000";
            	end if;    
          	end process;         	 
        	 

stopper:process(digito1,digito2)
				begin
					if (digito1=X"0" and digito2<=X"3")
						then display3 <= "10010010";
					else
						 display3 <= "11111111";
					end if;
					
				end process;
				
end Behavioral;
