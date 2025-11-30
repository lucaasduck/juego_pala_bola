----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 17:32:43
-- Design Name: 
-- Module Name: dibuja_pala - Behavioral
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
library UNISIM;
use UNISIM.VComponents.all;

entity dibuja_pala is
generic (
vel_pala: integer := 1;  ---- velocidad de la pala
anchura_pala :integer := 64; --- anchura pala
altura_pala : integer := 16; ---- altura de la pala
lim_derecho : integer := 512; ---- limite derecho de la pantalla 
pos_y: unsigned (8 downto 0):= "111001100"); --- 460 en decimal

    Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0); ---
           eje_y : in STD_LOGIC_VECTOR (9 downto 0);
           refresh : in STD_LOGIC;
           b_izq : in STD_LOGIC;
           b_der : in STD_LOGIC;
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           R_pala : out STD_LOGIC_VECTOR (3 downto 0);
           G_pala : out STD_LOGIC_VECTOR (3 downto 0);
           B_pala : out STD_LOGIC_VECTOR (3 downto 0));
end dibuja_pala;

architecture Behavioral of pala is

type tipo_estado is (reposo, mover);
signal estado, p_estado : tipo_estado;
signal pos_x, p_pos_x: unsigned (9 downto 0);


begin


---- estando en reposo ----
movimiento_pala: process(refresh)
begin
case estado is 
when reposo =>
        if(refresh ='1') then
        p_estado <= mover;
        else 
        p_estado <= reposo;
        end if;
        
when mover => 
if(b_izq = '1') then
      if(to_integer(pos_x) > vel_pala) then
       p_pos_x <= pos_x - vel_pala;
       end if;
       
    elsif (b_der = '1') then 
      if (to_integer(pos_x) < 513) then  
      p_pos_x <= pos_x + vel_pala; 
      end if; 
   end if;
   p_estado <= reposo;
   end case;
   
   
   estado <= p_estado;
   pos_x <= p_pos_x;
   
end process;

----------- proceso combinacional que dibuja la pala ---------------
pintar_pala: process(eje_x, eje_y )
begin 
    -- valores por defecto
    R_pala <= (others => '0');
    G_pala <= (others => '0');
    B_pala <= (others => '0');
 ---- si estamos dentro del cuadrado de la pala
if ((unsigned(eje_x) > pos_x) and (unsigned(eje_x) < pos_x +to_unsigned(anchura_pala, 10)) and
    (unsigned(eje_y) > pos_y) and (unsigned(eje_y) < pos_y + to_unsigned(altura_pala, 10))) then
  R_pala <= "1111";      ---- pinta de rojo
else
   R_pala <= (others => '0');
end if;


end Behavioral;
architecture Behavioral of dibuja_pala is

begin


end Behavioral;
