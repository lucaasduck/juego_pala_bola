----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.25
-- Design Name: 
-- Module Name: contador - Behavioral
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

entity contador is
    Generic (Nbit: INTEGER :=8);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           resets : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (Nbit-1 downto 0));--Q=Tamaño de bits asignados en la implementación.
end contador;

architecture Behavioral of contador is
--señales internas del bloque para llevar la cuenta:
signal p_cuenta,cuenta: unsigned (Nbit-1 downto 0);
constant MAX_VAL: unsigned(Nbit-1 downto 0) := to_unsigned(2**Nbit - 1, Nbit);

begin
Q<=std_logic_vector(cuenta);
--------------------------------------------- PROCESO SÍNCRONO ----------------------------------
sinc: process(clk,reset)
begin
if (reset='1') then
    cuenta<= (others=>'0');--pone la cuenta a cero en cuento pulso reset
elsif(rising_edge(clk)) then
    cuenta <= p_cuenta;
    --Esto se evalua en el proceso asincrono/combinacional
end if;
end process;
-------------------------------------------------------------------------------------------------

--------------------------------------------- PROCESO COMBINACIONAL ---------------------------------
comb: process(enable, cuenta,resets)--ve el valor sincrono de la cuenta en el proceso sincrono
begin
 p_cuenta <= cuenta;
    if (resets = '1') then
        p_cuenta<= (others=>'0');
    
    elsif (enable='1')then 
            if (cuenta = MAX_VAL )then--Lo comprobamos en su valor decimal
                p_cuenta <= (others=>'0');--satura
            
            else
                p_cuenta <= cuenta + 1;
            end if;
              
        end if;

end process;
-------------------------------------------------------------------------------------------------
end Behavioral;
