----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2025 20:22:21
-- Design Name: 
-- Module Name: mod_bloques - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mod_bloques is
    Port ( data_bloque : in STD_LOGIC_VECTOR (7 downto 0);
           valid_bloque : in STD_LOGIC;
           ready_bloque: out STD_LOGIC;
           ADDR_A : out STD_LOGIC_VECTOR (7 downto 0);
           data_in_A : out STD_LOGIC_VECTOR (0 downto 0);
           WR_A : out STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end mod_bloques;

architecture Behavioral of mod_bloques is

type estados is (reposo,borrar);
signal est, est_p: estados;


begin
sinc:process (clk,reset)
    begin 
        if(reset='1')then   
            est <= reposo;
           
        elsif(rising_edge(clk))then
            est <= est_p;
            
        end if;    
    end process;

comb: process(est,data_bloque)
        begin
        est_P <= est;
        
 -- aqui habria que leer con douta para los bloques especiales (abria que recrear la memoria con puerto A completo)   
        case est is 
            when reposo =>
                ready_bloque <='1';
                WR_A <='0';
                if (valid_bloque ='1') then
                        est_p <= borrar;
                    end if;
                    
           when borrar =>
                ready_bloque <='0';
                WR_A <='1';
                data_in_A <= "0";
                ADDR_A <=data_bloque ;
                if (valid_bloque ='0') then
                        est_p <= reposo;
                    end if;
           
           end case;      
        
    end process;    

end Behavioral;
