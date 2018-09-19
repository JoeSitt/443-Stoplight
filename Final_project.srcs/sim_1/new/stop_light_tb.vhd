----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2018 07:44:12 AM
-- Design Name: 
-- Module Name: stop_light_tb - Behavioral
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

entity stop_light_tb is
 --Port ( );
end stop_light_tb;

architecture Behavioral of stop_light_tb is
 component stop_light is
    Port ( ew_car : in STD_LOGIC;
           ns_car : in STD_LOGIC;
           Am_0am_6am : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg: out STD_LOGIC_VECTOR (6 downto 0);
           --clk_switch:in std_logic;
           lights_ew : out STD_LOGIC_VECTOR (5 downto 0);--0:green_w, 1:yellow_w, 2:red_w, 3:green_e, 4:yellow_e, 5:red_e,
           lights_ns : out STD_LOGIC_VECTOR (5 downto 0);--0:green_n, 1:yellow_n, 2:red_n, 3:green_s, 4:yellow_s, 5:red_s,
           clk1 : in STD_LOGIC);
           
end component;
         signal an : out STD_LOGIC_VECTOR (7 downto 0);
         signal  seg: out STD_LOGIC_VECTOR (6 downto 0);
         signal clk1 : in STD_LOGIC:='0';
         signal lights_ew : out STD_LOGIC_VECTOR (5 downto 0);--0:green_w, 1:yellow_w, 2:red_w, 3:green_e, 4:yellow_e, 5:red_e,
         signal lights_ns : out STD_LOGIC_VECTOR (5 downto 0);--0:green_n, 1:yellow_n, 2:red_n, 3:green_s, 4:yellow_s, 5:red_s,
begin
s1: stop_light port map('1','1','0',an,seg,light_ew,lights_ns,clk1);
clk1<=not clk1 after 5ns;
end Behavioral;
