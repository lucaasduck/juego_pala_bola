----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.12.2025 18:20:10
-- Design Name: 
-- Module Name: TOP_bola - Behavioral
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

entity TOP_bola is
     Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data_bola :in STD_LOGIC;
           valid_bola : in STD_LOGIC; 
           RGB_out : out STD_LOGIC_VECTOR (11 downto 0); -- salida de colores RGB de 12 bits
           VS : out STD_LOGIC;
           HS : out STD_LOGIC);
end TOP_bola;

architecture Behavioral of TOP_bola is
------------------------ declaracion de componentes ------------------------------
component frec_pixel is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_pixel : out STD_LOGIC);
end component;


component contador is
    Generic (Nbit: INTEGER :=8);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           resets : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (Nbit-1 downto 0));--Q=Tamaño de bits asignados en la implementación.
end component;


component comparador is
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
end component;


component dibuja_bola is
  generic (
         vel_bola      : integer := 3 -- velocidad de la bola
  );
    Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in STD_LOGIC_VECTOR (9 downto 0);
           data_bola : in STD_LOGIC;
           valid_bola : in STD_LOGIC;
           refresh : in STD_LOGIC;
           R_bola : out STD_LOGIC_VECTOR (3 downto 0);
           G_bola : out STD_LOGIC_VECTOR (3 downto 0);
           B_bola : out STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           reset : in STD_LOGIC);
end component;

component Gen_color is 
 Port ( blank_h : in STD_LOGIC;-- Indicador de que está fuera de pantalla procedente comparador horizontal
           blank_v : in STD_LOGIC;-- Indicador de que está fuera de pantalla procedente comparador vertical
           RED_in : in STD_LOGIC_VECTOR (3 downto 0);--Entrada de color procedentes del bloque DIBUJA
           GRN_in : in STD_LOGIC_VECTOR (3 downto 0);--Entrada de color procedentes del bloque DIBUJA
           BLU_in : in STD_LOGIC_VECTOR (3 downto 0);--Entrada de color procedentes del bloque DIBUJA
           RGB_out : out STD_LOGIC_VECTOR (11 downto 0)); -- salida de colores RGB de 12 bits           
end component;

------------- señales de conexionenre los distintos bloques ----------------------------------------------
--conectamos los distintos bloques
signal pixel_enable : std_logic; 
signal contV_enable: std_logic; 

signal  compV_o1,compV_o3: std_logic;
signal  compH_o1,compH_o2,compH_o3: std_logic;

signal eje_X, eje_Y,contV_Q,contH_Q,compV_data,compH_data: std_logic_vector (9 downto 0);
signal rojo_DG, azul_DG, verde_DG,rojo, azul, verde: std_logic_vector (3 downto 0);

signal color_red, color_green, color_blue :  std_logic_vector (3 downto 0);
begin
contV_enable <= pixel_enable AND compH_o3;

frecuencia_pixel:frec_pixel
PORT MAP (
    clk=>clk,
    reset=>reset,
    clk_pixel=>pixel_enable);
 
 
    
Conth:contador
GENERIC MAP(Nbit=>10)
PORT MAP(
    clk=>clk,
    reset=>reset,
    resets=>contV_enable,
    enable=>pixel_enable,
    Q=>eje_X);

Contv:contador
GENERIC MAP(Nbit=>10)
PORT MAP(
    clk=>clk,
    reset=>reset,
    resets=>compV_o3,
    enable=>contV_enable,
    Q=>eje_Y);
 
 
 Compv:comparador
GENERIC MAP(Nbit=>10,
            End_of_Screen=>479,
            Start_Of_Pulse=>489,
            End_Of_Pulse=>491,
            End_Of_Line=>520)
PORT MAP(
    clk=>clk,
    reset=>reset,
    O1=>compV_o1,
    O2=>VS,
    O3=>compV_o3,
    data=>eje_Y);
    

Comph:comparador
GENERIC MAP(Nbit=>10,
            End_of_Screen=>639,
            Start_Of_Pulse=>655,
            End_Of_Pulse=>751,
            End_Of_Line=>799)
PORT MAP(
    clk=>clk,
    reset=>reset,
    O1=>compH_o1,
    O2=>HS,
    O3=>compH_o3,
    data=>eje_X);  


    
 dibujar: dibuja_bola
    port map (
      eje_X   => eje_X,
      eje_Y   => eje_Y,
      refresh => compV_o3,
      data_bola   => data_bola,
      valid_bola   => valid_bola,
      clk     => clk,
      reset   => reset,
      R_bola     => color_red,
      G_bola     => color_green,
      B_bola     => color_blue
    );


    
 generador_color: Gen_color
 PORT MAP (
    blank_h => compH_o1,
    blank_v => compV_o1,
    RED_in => color_red,
    GRN_in => color_green,
    BLU_in=> color_blue,
    RGB_out => RGB_out );
 
end Behavioral;
