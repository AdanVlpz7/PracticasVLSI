library IEEE;

USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity reloj is

    port( clk: in std_logic;
            AN   : out std_logic_vector (3 downto 0);
				Hd   : out std_logic_vector (6 downto 0);
				Hu	  : out std_logic_vector (6 downto 0);
				Md	  : out std_logic_vector (6 downto 0);
            Mu   : out std_logic_vector (6 downto 0)
         );
       
end reloj;  


architecture behavioral of reloj is

    signal segundo: std_logic;
    signal rapido : std_logic;
    signal n      : std_logic;
    signal Qs     : std_logic_vector (3 downto 0);
    signal Qum    : std_logic_vector (3 downto 0);
    signal Qdm    : std_logic_vector (3 downto 0);
    signal e      : std_logic;
    signal Qr     : std_logic_vector (1 downto 0);
    signal Quh    : std_logic_vector (3 downto 0);
    signal Qdh    : std_logic_vector (3 downto 0);
    signal z      : std_logic;
    signal u      : std_logic;
    signal d      : std_logic;
    signal reset  : std_logic;
   
begin

    divisor: process(clk)
        variable cuenta: std_logic_vector (27 downto 0):=X"0000000";
    begin
   
        if rising_edge (clk) then
       
            if (cuenta=X"48009E") then
           
                cuenta:=X"0000000";
               
            end if;
        end if;
       
    segundo <= cuenta (22);
	 rapido  <= cuenta (10);
   
    end process;
   
   
    unidades: process (segundo)
        variable cuenta: std_logic_vector(3 downto 0) := "0000";
   begin
   
        if rising_edge (segundo) then
       
            if cuenta ="1001" then
                cuenta:="0000";
            n <= '1';
         else
                cuenta:= cuenta +1;
            n <= '0';
         end if;
           
      end if;
       
      qum <= cuenta;
       
    end process;
   
   
    decenas: process (n)
        variable cuenta: std_logic_vector(3 downto 0) := "0000";
       
    begin
   
        if rising_edge (n) then
       
            if cuenta ="0101" then
                cuenta:="0000";
                e <= '1';
            else
                cuenta:= cuenta +1;
                e<= '0';
            end if;
        end if;
       
        Qdm <= cuenta;
       
    end process;
   
    HoraU: Process(e,reset)
        variable cuenta: std_logic_vector(3 downto 0):="0000";
       
    begin
   
        if rising_edge(e) then
       
            if cuenta="1001" then
                cuenta:= "0000";
                z<='1';
            else
                cuenta:=cuenta+1;
                z<='0';
            end if;
           
        end if;
       
            if reset='1' then
                cuenta:="0000";
            end if;
           
            Quh<=cuenta;
            u<=cuenta(2);
           
    end Process;
   
   
    HoraD: Process(z, reset)
        variable cuenta: std_logic_vector(3 downto 0):="0000";
    begin
   
        if rising_edge(z) then
            if cuenta="0010" then
                cuenta:= "0000";
            else
                cuenta:=cuenta+1;
            end if;
        end if;
       
            if reset='1' then
                cuenta:="0000";
            end if;
           
            Qdh<=cuenta;
            d <=cuenta(1);
           
end Process;


    inicia: process (u,d)
   
        begin
        reset <= (u and d);
       
    end process;
   
   
    Contrapid: process (rapido)
        variable cuenta: std_logic_vector(1 downto 0) := "00";
    begin
   
        if rising_edge (rapido) then
            cuenta:= cuenta +1;
        end if;
       
        Qr <= cuenta;
       
end process;


    muxy: process (Qr)
    begin 
        if (Qr = "00") then
             with Qum select --modificamos el digito de unidades de minutos
					  Mu <= "1000000" when "0000", --0
							  "1111001" when "0001", --1
							  "0100100" when "0010", --2
							  "0110000" when "0011", --3
							  "0011001" when "0100", --4
							  "0010010" when "0101", --5
							  "0000010" when "0110", --6
							  "1111000" when "0111", --7
							  "0000000" when "1000", --8
							  "0010000" when "1001", --9
							  "1000000" when others; --F
         elsif (Qr = "01") then
             with Qdm select --modificamos el digito de decenas de minutos
					  Md <= "1000000" when "0000", --0
							  "1111001" when "0001", --1
							  "0100100" when "0010", --2
							  "0110000" when "0011", --3
							  "0011001" when "0100", --4
							  "0010010" when "0101", --5
							  "1000000" when others; --F
            elsif (Qr = "10") then
             with Quh select --modificamos el digito de unidades de hora
					  Hd <= "1000000" when "0000", --0
							  "1111001" when "0001", --1
							  "0100100" when "0010", --2
							  "0110000" when "0011", --3
							  "0011001" when "0100", --4
							  "0010010" when "0101", --5
							  "0000010" when "0110", --6
							  "1111000" when "0111", --7
							  "0000000" when "1000", --8
							  "0010000" when "1001", --9
							  "1000000" when others; --F
        elsif (Qr = "11") then
             with Qdh select --modificamos el digito de decenas de hora
					  Hd <= "1000000" when "0000", --0
							  "1111001" when "0001", --1
							  "0100100" when "0010", --2
							  "1000000" when others; --F
        end if;
       
end process;

    
             
end behavioral;
