----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/16/2018 09:37:22 AM
-- Design Name: 
-- Module Name: 7seg_disp - Behavioral
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
use work.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenseg_disp is
generic(
f_board : natural := 100E6; -- fin = 100MHz
f_flicker: real:=62.5;
n: natural:=8
);
    Port ( 
           input : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           cath : out STD_LOGIC_VECTOR (6 downto 0));
end sevenseg_disp;

architecture Behavioral of sevenseg_disp is
signal max1: natural:=integer(real(f_board)/(real(n)*f_flicker));
constant max2: integer := integer(ceil(log2(real(n))));
signal cmax2: unsigned( (max2 - 1) downto 0):=to_unsigned(n-1, max2 );
signal n_state1:integer;--:=1;
signal c_state1: integer:=0;
signal c_state2: std_logic_vector((max2-1) downto 0):=(others=>'0');
signal n_state2: unsigned(max2-1 downto 0);
signal mux_ctl: std_logic:='0';
signal cath1 : STD_LOGIC_VECTOR (3 downto 0);

component to_7seg is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (0 to 6)
             );
end component;


component D_ff_sync_reset Is
port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		d2 : in STD_LOGIC_vector(max2-1 downto 0);
		q2  : out STD_LOGIC_vector(max2-1 downto 0)
	);
end component;

component D_ff_int Is
port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		d : in integer;
		q   : out integer
	);
end component;

begin
n_state2<=unsigned(c_state2)+1 when c_state1 = max1 else unsigned(c_state2);
n_state1<=0 when c_state1 = max1 else c_state1+1;
--ctl_mux<=c_state=1;
a1: D_ff_int port map(clk, rst,n_state1,c_state1);
a2: D_ff_sync_reset port map(clk,rst,std_logic_vector(n_state2),c_state2);

hex2sevenseg: to_7seg port map(cath1,cath);

process(c_state2) 
    --variable I: integer range 0 to n-1;
begin
--    if(rising_edge(clk)) then
--    --mux_ctl<='0';
--        if((rst='1') ) then
--            c_state1<=0;
--            c_state2<=(others=>'0');
--            n_state2(max2-1 downto 1)<=(others=>'0');
--            n_state2(0)<='1';
--        elsif(c_state1=max1) then
--            c_state1<=0;
--            c_state2<=std_logic_vector(n_state2);
--            n_state2<=n_state2+1;
--        end if;
        
--        if(unsigned(c_state2)=cmax2) then
--            c_state2<=(others=>'0');
--            n_state2(max2-1 downto 1)<=(others=>'0');
--            n_state2(0)<='1';
--        end if;
        
    --    I := 0;    
    --    while (I < n-1) loop
    --      if ((n_state2) = I) then
    --        an(I) <= '0';
    --        cath1<=input((4*I+3) downto (4*i));
    --      else
    --        an(I) <= '1';
    --      end if;
    --      I := I + 1;
    --    end loop; 
    
    
    --end if;
    an <= (others => '1');
    an(to_integer(unsigned(c_state2))) <= '0';
end process;
    --an <= (to_integer(unsigned(c_state2)) => '0', others => '1');
    --an <= (others => '1');
    --an(to_integer(unsigned(c_state2))) <= '0';
    cath1<= input((4*to_integer(unsigned(c_state2))+3) downto (4*to_integer(unsigned(c_state2))));
end Behavioral;
