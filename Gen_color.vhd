----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.25 
-- Design Name: 
-- Module Name: Gen_color - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Bloque combinacional que asegura que el cañón de electrones esté apagado
--                      cuando apunta fuera de la pantalla o está volviendo al comienzo de otra línea.
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

entity Gen_color is
    Port ( blank_h : in STD_LOGIC;-- Indicador de que está fuera de pantalla procedente comparador horizontal
           blank_v : in STD_LOGIC;-- Indicador de que está fuera de pantalla procedente comparador vertical
           RED_in : in STD_LOGIC_VECTOR (3 downto 0);--Entrada de color procedentes del bloque DIBUJA
           GRN_in : in STD_LOGIC_VECTOR (3 downto 0);--Entrada de color procedentes del bloque DIBUJA
           BLU_in : in STD_LOGIC_VECTOR (3 downto 0);--Entrada de color procedentes del bloque DIBUJA
           RGB_out : out STD_LOGIC_VECTOR (11 downto 0)); -- salida de colores RGB de 12 bits 
end Gen_color;

architecture Behavioral of Gen_color is

begin
gen_color:process(Blank_H, Blank_V, RED_in, GRN_in,
BLU_in)
begin
    if (Blank_H='1' or Blank_V='1') then
        RGB_out<=(others => '0');
    else
    RGB_out<= RED_in & GRN_in & BLU_in;
    end if;
end process;


end Behavioral;
