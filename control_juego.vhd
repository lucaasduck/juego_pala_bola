----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2025 18:58:40
-- Design Name: 
-- Module Name: control_juego - Behavioral
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

entity control_juego is
    generic(Posy_pala : integer:= 400);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           RGB_pala : in STD_LOGIC_VECTOR (11 downto 0);
           RGB_bola : in STD_LOGIC_VECTOR (11 downto 0);
           RGB_bloques : in STD_LOGIC_VECTOR (11 downto 0);
           RGB_in : out STD_LOGIC_VECTOR (11 downto 0);
           data_bola : out STD_LOGIC_VECTOR (3 downto 0);
           valid_bola : out STD_LOGIC;
           ready_bola : in STD_LOGIC;
           data_bloque : out STD_LOGIC_VECTOR (7 downto 0);
           valid_bloque : out STD_LOGIC;
           ready_bloque : in STD_LOGIC;
           refresh : in STD_LOGIC;
           eje_x : in STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in STD_LOGIC_VECTOR (9 downto 0)
           );
end control_juego;

architecture Behavioral of control_juego is
    type estados is (reposo,choquebolapala,choquebolabloque,borrarbloque,espera);
    signal est,est_p: estados;
    signal ADDR_B : STD_LOGIC_VECTOR (7 downto 0);
begin

sinc: process (clk,reset)
        begin
            if (reset ='1')then 
                est <= reposo;
            elsif (rising_edge (clk))then
                est <= est_p ;
                ADDR_B (3 DOWNTO 0) <= eje_x(8 downto 5);
                ADDR_B (7 DOWNTO 4) <= eje_y(7 downto 4);
            end if;
            
end process;
                
palabola: process (est,RGB_pala,RGB_bola,RGB_bloques, ready_bola,ready_bloque,ADDR_B,refresh )
            begin
                est_p <= est ;
                case est is 
                    when reposo => 
                       valid_bola <= '0';
                       valid_bloque <= '0';
                       if ((RGB_pala /= "000000000000") and (RGB_bola/= "000000000000")) then
                            est_p <= choquebolapala;
                       end if;
                       if ((RGB_bloques /= "000000000000") and (RGB_bola/= "000000000000")) then
                            est_p <= choquebolabloque;
                       end if;     
                    when choquebolapala =>
                        data_bola<="0000";
                        valid_bola <='1';
                        if (ready_bola ='1') then
                            est_p <= espera;
                        end if;
                    when choquebolabloque => 
                        valid_bola <='1';
                        data_bola <="1000";
                        if (ready_bola ='1') then
                            est_p <= borrarbloque;
                        end if;    
                    when borrarbloque => 
                        valid_bloque <= '1';
                        data_bloque<= ADDR_B;
                        est_p <= espera;        
                    when espera => 
                        if (refresh='1') then
                            est_p <=reposo;
                        end if;            
                    
                
                
            
                end case;
end process;
               
RGB_in <= RGB_bloques OR RGB_bola OR RGB_pala;
end Behavioral;
