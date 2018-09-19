--------------------------------------------
-- Module Name: D_ff_sync_reset_behavior
--------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;

Entity D_ff_int Is
port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		d : in integer;
		q   : out integer
	);
end D_ff_int;

Architecture behavior of D_ff_int Is
begin

    process (clk) 
    begin
        
        if rising_edge(clk) then
            if (rst = '1') then
                q <= 0;
            else
                q <= d;
            end if;
        end if;
        
    end process;
end behavior;