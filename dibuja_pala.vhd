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
    vel_pala      : integer := 3;    -- píxeles por refresh
    anchura_pala  : integer := 64;   -- ancho pala
    altura_pala   : integer := 16;   -- alto pala
    lim_derecho   : integer := 512;  -- límite derecho del área de juego
    pos_y_const   : integer := 400;   -- posicion Y fija de la pala
    wall_width    : integer := 15;        -- ancho del muro en píxeles
    
    -- Colores de distintas zonas de la pantalla (0-15)
    -- Colores (4 bits por canal). Valores por defecto:
    --  Fondo juego: azul oscuro    (0,0,2)
    --  Fondo fuera: gris aprox     (13,13,14)
    --  Muro: blanco                 (15,15,15)
    --  Pala: rojo                   (15,0,0)
     z_juego_R     : STD_LOGIC_VECTOR (3 downto 0):= "0000";      -- fondo dentro de juego
     z_juego_G      : STD_LOGIC_VECTOR (3 downto 0) := "0000";
     z_juego_B    : STD_LOGIC_VECTOR (3 downto 0) := "0010";

    z_f_juego_R      : STD_LOGIC_VECTOR (3 downto 0) := "1000";     -- fondo fuera de juego (gris aprox 218,220,232)
    z_f_juego_G       : STD_LOGIC_VECTOR (3 downto 0) := "1111";
    z_f_juego_B       : STD_LOGIC_VECTOR (3 downto 0) := "0111";

    wall_r        : STD_LOGIC_VECTOR (3 downto 0) := "1111";     -- muro (blanco)
    wall_g        : STD_LOGIC_VECTOR (3 downto 0) := "1111";
    wall_b        : STD_LOGIC_VECTOR (3 downto 0) := "1111";

    pala_R      : STD_LOGIC_VECTOR (3 downto 0) := "1111";     -- pala (rojo)
    pala_G      : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    pala_B      : STD_LOGIC_VECTOR (3 downto 0) := "0000"
  );

    Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0); 
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

architecture Behavioral of dibuja_pala is

type tipo_estado is (reposo, mover);
signal estado, p_estado : tipo_estado;
signal pos_x, p_pos_x: unsigned (9 downto 0);


 constant MAX_POS_X  : integer := lim_derecho - anchura_pala; -- tope derecho para la X de la pala
  constant POS_Y_U    : unsigned(9 downto 0) := to_unsigned(pos_y_const, 10);
  constant ANCH_U     : unsigned(9 downto 0) := to_unsigned(anchura_pala, 10);
  constant ALT_U      : unsigned(9 downto 0) := to_unsigned(altura_pala, 10);
  constant VEL_U      : unsigned(9 downto 0) := to_unsigned(vel_pala, 10);

begin

  -- Proceso secuencial: registra estado y posición
  proc_seq : process(clk, reset)
  begin
    if reset = '1' then
      estado <= REPOSO;
      -- posición inicial centrada en el área de juego
      pos_x  <= to_unsigned(MAX_POS_X/2, 10);
    elsif rising_edge(clk) then
      estado <= p_estado;
      pos_x  <= p_pos_x;
    end if;
  end process;

  -- Proceso combinacional: próximo estado y próxima posición
  proc_comb : process(estado, refresh, b_izq, b_der, pos_x)
    variable pos_int : integer;
    variable new_x   : integer;
  begin
    -- valores por defecto (mantener)
    p_estado <= estado;
    p_pos_x  <= pos_x;

    case estado is
      when REPOSO =>
        if refresh = '1' then
          p_estado <= MOVER;
        end if;

      when MOVER =>
        -- calcula nueva X en entero con saturación
        pos_int := to_integer(pos_x);
        new_x   := pos_int;

        if (b_izq = '1') and (b_der = '0') then
          new_x := pos_int - vel_pala;
        elsif (b_der = '1') and (b_izq = '0') then
          new_x := pos_int + vel_pala;
        else
          -- si ambos o ninguno, no se mueve
          new_x := pos_int;
        end if;

        -- saturación a los límites [0, MAX_POS_X]
        if new_x < 0 then
          new_x := 0;
        elsif new_x > MAX_POS_X then
          new_x := MAX_POS_X;
        end if;

        p_pos_x  <= to_unsigned(new_x, 10);
        p_estado <= REPOSO;
    end case;
  end process;

  -- Pintado de el fondo, muro y pala (combinacional)
  pintar : process(eje_x, eje_y, pos_x)
    variable X        : unsigned(9 downto 0);
    variable Y        : unsigned(9 downto 0);
    constant LIM_U    : unsigned(9 downto 0) := to_unsigned(lim_derecho, 10);--- limite de 512 
    constant WALL_W_U : unsigned(9 downto 0) := to_unsigned(wall_width, 10); --- anchura del muro 
    variable in_game  : boolean; -- varable que indica si estoy en la zona de juego
    variable in_wall  : boolean; --variable que indica si estoy en el muro
    variable in_padd  : boolean; --variable que indica si estoy en la pala
  begin
    X := unsigned(eje_x);
    Y := unsigned(eje_y);

    -- Zona de juego y muro
    in_game := (X < LIM_U); -- zona e juego
    in_wall := (X >= LIM_U) and (X < LIM_U + WALL_W_U); -- zona del muro separador
    
   -- Pala (solo dentro de zona de juego)
    in_padd := in_game and
               (X >= pos_x) and (X < pos_x + ANCH_U) and
               (Y >= POS_Y_U) and (Y < POS_Y_U + ALT_U);


    -- colores  por defecto según zona
    if in_game then --- zona de juego
      R_pala <= z_juego_R;
      G_pala <= z_juego_G;
      B_pala <= z_juego_B;
    else
      R_pala <= z_f_juego_R; ---fuera de la zona de juego
      G_pala <= z_f_juego_G;
      B_pala <= z_f_juego_B;
    end if;

    -- Muro (prioridad sobre fondo)
    if in_wall then --- en el muro
      R_pala <= wall_r;
      G_pala <= wall_g;
      B_pala <= wall_b;
    end if;

    -- Pala (máxima prioridad dentro de juego)
    if in_padd then  --- pala
      R_pala <= pala_R;
      G_pala <= pala_G;
      B_pala <= pala_B;
    end if;
  end process;

end Behavioral;
