----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.25
-- Design Name: 
-- Module Name: frec_pixel - Behavioral
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

entity frec_pixel is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_pixel : out STD_LOGIC);
end frec_pixel;

architecture Behavioral of frec_pixel is

signal cuenta,p_cuenta: unsigned(1 downto 0);
signal sat: std_logic;


begin

clk_pixel<=sat;

    sinc: process(clk,reset)
    begin
    if (reset='1') then
        cuenta<= (others=>'0');--Cuenta a 0.
    elsif(rising_edge(clk)) then
        cuenta <= p_cuenta;--Asignamos en proceso asincrono.
        
    end if;
    end process;


    comb: process(cuenta)
    begin

    if (cuenta = "11") then  --- la cuenta llega a 3
        p_cuenta<= (others=>'0');-- proximo valor de cuenta a cero.
        sat<='1';
        
    else
        p_cuenta <= cuenta +1 ;--si no satura seguimos incrementando.
        sat<='0';
    end if;
    end process;

end Behavioral;
