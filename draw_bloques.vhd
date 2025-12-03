----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2025 20:22:21
-- Design Name: 
-- Module Name: draw_bloques - Behavioral
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

entity draw_bloques is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ADDR_B : out STD_LOGIC_VECTOR (7 downto 0);
           RGB_bloques : out STD_LOGIC_VECTOR (11 downto 0);
           data_out_B : in STD_LOGIC_VECTOR (0 downto 0);
           eje_x : in STD_LOGIC_VECTOR (9 downto 0);
           eje_y : in STD_LOGIC_VECTOR (9 downto 0));
end draw_bloques;

architecture Behavioral of draw_bloques is

begin
sinc: process(clk,reset)
    begin
    if (reset='1') then
        ADDR_B <= (others => '0');
        RGB_bloques <= (others => '0');
    elsif (rising_edge (clk))then
        ADDR_B (3 DOWNTO 0) <= eje_x(8 downto 5);
        ADDR_B (7 DOWNTO 4) <= eje_y(7 downto 4);
    end if;    
end process;

comb:process (data_out_B,eje_x ,eje_y )
    begin
        if (data_out_B = "1") then
        
            if (eje_x (0 downto 0) = "1") then
                if (eje_y (0 downto 0) = "1") then
                    RGB_bloques <= "000000001111";
                elsif (eje_y (0 downto 0) = "0") then
                    RGB_bloques <= "000000001100";
                end if;
            elsif (eje_x (0 downto 0) = "0") then
                if (eje_y (0 downto 0) = "1") then
                    RGB_bloques <= "000000001100";
                elsif (eje_y (0 downto 0) = "0") then
                    RGB_bloques <= "000000001111";
                end if;
            end if;    
        else
            RGB_bloques <= (others => '0');    
        end if;
    
end process;    

end Behavioral;
