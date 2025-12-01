----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2025 17:48:36
-- Design Name: 
-- Module Name: dibuja_bola - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dibuja_bola is
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
end dibuja_bola;

architecture Behavioral of dibuja_bola is

begin


end Behavioral;
