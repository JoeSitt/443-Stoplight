----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2018 09:19:41 AM
-- Design Name: 
-- Module Name: clockdivider - Behavioral
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
use work.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clockdivider is
generic(f_in : natural := 100E6; -- fin = 100MHz
f_out: natural := 1-- fout = 1 Hz
);
    Port ( clk : in STD_LOGIC;
           cout : out STD_LOGIC:='0');
end clockdivider;

architecture Behavioral of clockdivider is
signal cont:integer:=0;
signal c: std_logic:='0';
constant cmax : natural := integer( round( real(f_in)/real(f_out) ));
begin


process(clk)
variable count:integer :=cont;
begin
if rising_edge(clk) then
    count := count + 1;
    if count = (cmax)/2 then
        count :=0;
        c<=not c;
    end if;
end if;
cont<=count;
end process;
cout<=c;
end Behavioral;
