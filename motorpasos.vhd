library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity motorpasos is
  Port (reloj: in std_logic; --reloj 
        UD   : in std_logic;--dip_switch
        rst  : in std_logic; --pushbutton
        FH   : in std_logic_vector(1 downto 0);--dip_switch
        led  : out std_logic_vector(3 downto 0);--gp_pin que van al driver
        MOT  : out std_logic_vector(3 downto 0)--gp_in que van al driver
        );
end motorpasos;

architecture Behavioral of motorpasos is
signal div: std_logic_vector (17 downto 0);
signal clks: std_logic;

type estado is (sm0, sm1, sm2, sm3, sm4, sm5, sm6, sm7, sm8, sm9, sm10);
signal pres_s, next_s: estado;
signal motor: std_logic_vector (3 downto 0); --para la salida


begin

process(reloj,rst)
begin
    if(rst='0')then
        div<=(others=>'0');
    elsif(reloj'event and reloj='1')then
        div<=div+1;
    end if;        
end process;

clks<=div(17);

process(clks, rst)
begin
    if(rst='0')then
        pres_s<=sm0;
    elsif(clks'event and clks='1')then
        pres_s<=next_s;
    end if;        
end process;

process(pres_s, UD, rst, FH)
begin
    case(pres_s)is    
        when sm0 =>             --estado 0
            next_s <= sm1;
        when sm1 =>             --estado 1
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm3;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm9;
                else
                    next_s<=sm4;
                end if;
             else
                next_s<=sm1;
             end if;
             
        when sm2 =>             --estado 2
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm4;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm3;
                else
                    next_s<=sm1;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm9;
                else
                    next_s<=sm4;
                end if;
             else
                next_s<=sm2;
             end if;
       
        when sm3 =>             --estado 3
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm5;
                else
                    next_s<=sm1;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm4;
                else
                    next_s<=sm2;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm9;
                else
                    next_s<=sm4;
                end if;
             else
                next_s<=sm3;
             end if;    
             
        when sm4 =>             --estado 4
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm6;
                else
                    next_s<=sm2;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm5;
                else
                    next_s<=sm3;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm9;
                else
                    next_s<=sm10;
                end if;
             else
                next_s<=sm4;
             end if;    
             
        when sm5 =>             --estado 5
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm7;
                else
                    next_s<=sm3;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm6;
                else
                    next_s<=sm4;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm9;
                else
                    next_s<=sm4;
                end if;
             else
                next_s<=sm3;
             end if;    
       
        when sm6 =>             --estado 6
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm8;
                else
                    next_s<=sm4;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm7;
                else
                    next_s<=sm5;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm9;
                else
                    next_s<=sm4;
                end if;
             else
                next_s<=sm7;
             end if;    
             
        when sm7 =>             --estado 7
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm5;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm8;
                else
                    next_s<=sm6;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm9;
                else
                    next_s<=sm4;
                end if;
             else
                next_s<=sm7;
             end if;    
             
        when sm8 =>             --estado 8
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm6;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm10;
                else
                    next_s<=sm8;
                end if;
             else
                next_s<=sm1;
             end if;    
             
        when sm9 =>             --estado 9
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm8;
                else
                    next_s<=sm9;
                end if;
             else
                next_s<=sm1;
             end if;    
             
        when sm10 =>            --estado 10
            if (FH="00")then    --motor bipolar
                if (UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm7;
                end if;
             elsif(FH="01")then
                if(UD='1')then
                    next_s<=sm2;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="10")then
                if(UD='1')then
                    next_s<=sm1;
                else
                    next_s<=sm8;
                end if;
             elsif(FH="11")then
                if(UD='1')then
                    next_s<=sm4;
                else
                    next_s<=sm8;
                end if;
             else
                next_s<=sm10;
             end if;      
             
        when others=>
            next_s<=sm0;    
end case;
end process;            
             
--codigo de salidas de estados al motor
process(pres_s)
begin
    case (pres_s)is
        when sm0 => motor <= "0000";
        when sm1 => motor <= "1000";
        when sm2 => motor <= "1100";
        when sm3 => motor <= "0100";
        when sm4 => motor <= "0110";
        when sm5 => motor <= "0010";
        when sm6 => motor <= "0011";
        when sm7 => motor <= "0001";
        when sm8 => motor <= "1010";
        when sm9 => motor <= "0101";
        when sm10 => motor <= "0000";
        when others => motor <= "0000";
       
    end case;
   
end process;
                 
MOT<=motor;
led<=motor;

end Behavioral;