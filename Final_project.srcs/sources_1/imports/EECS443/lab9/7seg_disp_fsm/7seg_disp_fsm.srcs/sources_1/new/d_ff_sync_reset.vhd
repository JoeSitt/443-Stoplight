--------------------------------------------
-- Module Name: D_ff_sync_reset_behavior
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

Entity D_ff_sync_reset Is
generic(n:integer:=3);
port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		d2 : in STD_LOGIC_vector(n-1 downto 0);
		q2   : out STD_LOGIC_vector(n-1 downto 0)
	);
end D_ff_sync_reset;

Architecture behavior of D_ff_sync_reset Is

begin

    process (clk) 
    begin
        
        if rising_edge(clk) then
            if (rst = '1') then
                q2 <= (others=>'0');
            else
                q2 <= d2;
            end if;
        end if;
        
    end process;
end behavior;