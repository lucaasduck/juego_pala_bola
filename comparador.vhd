----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.25
-- Design Name: 
-- Module Name: comparador - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity comparador is
    Generic (Nbit: integer :=8;
             End_Of_Screen: integer :=10;
             Start_Of_Pulse: integer :=20;
             End_Of_Pulse: integer := 30;
             End_Of_Line: integer := 40);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
           O1 : out STD_LOGIC;
           O2 : out STD_LOGIC;
           O3 : out STD_LOGIC);
end comparador;

architecture Behavioral of comparador is

signal O3_AUX, O2_AUX, O1_AUX: std_logic;
signal  data_aux: unsigned (Nbit-1 downto 0);

begin

data_aux <= unsigned (data);

sinc: process(clk,reset)
begin
    if (reset = '1') then 
        O1<='0';
        O2<='1';
        O3<='1';
    
    elsif(rising_edge(clk)) then
       O1<=O1_AUX;
       O2<=O2_AUX;
       O3<=O3_AUX;
           
    end if;
end process;



comb: process(data_aux)
begin
    
    if (data_aux > End_Of_Screen) then--¿Fuera de Pantalla?
        O1_AUX<='1';
    
    else
        O1_AUX <='0';
    
    end if;
    
    if ((Start_Of_Pulse < data_AUX)and(data_aux < End_Of_Pulse)) then--Entre empezar y terminar el pulso
        O2_AUX<='0';
    else
        O2_AUX<='1';
        
    end if;
    
    if (data_aux = End_Of_Line)then --Comprueba final de linea
        O3_AUX<='1';
    else
        O3_AUX<='0';
        
    end if;
end process;

end Behavioral;
