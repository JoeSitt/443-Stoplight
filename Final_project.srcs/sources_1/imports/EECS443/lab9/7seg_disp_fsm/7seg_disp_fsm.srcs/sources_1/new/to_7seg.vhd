library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity to_7seg is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (0 to 6)
             );
end to_7seg;

architecture Behavioral of to_7seg is

begin

--'a' corresponds to MSB of seg7 and 'g' corresponds to LSB of seg7.
--process (A)
--BEGIN
--    case A is
--        when "0000"=> seg7 <="0000001";  -- '0'
--        when "0001"=> seg7 <="1001111";  -- '1'
--        when "0010"=> seg7 <="0010010";  -- '2'
--        when "0011"=> seg7 <="0000110";  -- '3'
--        when "0100"=> seg7 <="1001100";  -- '4' 
--        when "0101"=> seg7 <="0100100";  -- '5'
--        when "0110"=> seg7 <="0100000";  -- '6'
--        when "0111"=> seg7 <="0001111";  -- '7'
--        when "1000"=> seg7 <="0000000";  -- '8'
--        when "1001"=> seg7 <="0000100";  -- '9'
--        when "1010"=> seg7 <="0001000";  -- 'A'
--        when "1011"=> seg7 <="1100000";  -- 'b'
--        when "1100"=> seg7 <="0110001";  -- 'C'
--        when "1101"=> seg7 <="1000010";  -- 'd'
--        when "1110"=> seg7 <="0110000";  -- 'E'
--        when "1111"=> seg7 <="0111000";  -- 'F'
--        when others =>  NULL;
--    end case;
    
    seg7 <= "1000000" when (x = "0000") else-- xflipped it. 0
             "1001111" when (x = "0001") else -- x 1
             "0100100" when (x = "0010") else --2
             "0110000" when (x = "0011") else --3
             "0011001" when (x = "0100") else--4
             "0010010" when (x = "0101") else--5
             "0000010" when (x = "0110") else--6
             "1111000" when (x = "0111") else--7
             "0000000" when (x = "1000") else--8
             "0010000" when (x = "1001") else --9
             "0001000" when (x = "1010") else--a
             "0000011" when (x = "1011") else--b
             "0100111" when (x = "1100") else--c
             "0100001" when (x = "1101") else--d
             "0000110" when (x = "1110") else--e
             "0001110" when (x = "1111") else--f
             "1111111";

--end process;

end Behavioral;