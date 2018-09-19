----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Joe Sittenauer
-- 
-- Create Date: 04/23/2018 08:28:28 AM
-- Design Name: 4 way stoplight with 2 seperate light styles
-- Module Name: stop_light - Behavioral
-- Project Name: stop light
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

entity stop_light is
    Port ( ew_car : in STD_LOGIC;
           ns_car : in STD_LOGIC;
           Am_0am_6am : in STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg: out STD_LOGIC_VECTOR (6 downto 0);
           lights_ew : out STD_LOGIC_VECTOR (5 downto 0);--5:green_w, 4:yellow_w, 3:red_w, 2:green_e, 1:yellow_e, 0:red_e,
           lights_ns : out STD_LOGIC_VECTOR (5 downto 0);--5:green_n, 4:yellow_n, 3:red_n, 2:green_s, 1:yellow_s, 0:red_s,
           led_ns: out STD_LOGIC_VECTOR (2 downto 0);
           led_ew: out STD_LOGIC_VECTOR (2 downto 0);
           clk1 : in STD_LOGIC);
           
end stop_light;

architecture Behavioral of stop_light is

component clockdivider is
generic(f_in : natural := 100E6; -- fin = 100MHz
f_out: natural := 1-- fout = 1 Hz
);
    Port ( clk : in STD_LOGIC;
           cout : out STD_LOGIC:='0');
end component;

component D_ff_int Is
port (
		clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		d : in integer;
		q   : out integer
	);
end component;

component to_7seg is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
          seg7 : out  STD_LOGIC_VECTOR (0 to 6)
             );
end component;

component sevenseg_disp is
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
end component;

signal state: integer:=0;
signal count: integer:=0;
signal nstate: integer:=1;
signal cmax:integer:=3;
signal ncount: integer:=1;
signal green_w, yellow_w, red_w, green_e, yellow_e, red_e, green_n, yellow_n, red_n, green_s, yellow_s, red_s, clk, rst:std_logic:='0';
signal segs: std_logic_vector(31 downto 0);
signal num1,num2,num3,num4,num5,num6,num7,num8: std_logic_vector(3 downto 0):="0000";
signal an2,an3: STD_LOGIC_VECTOR (7 downto 0):="11110111";
signal ledns,ledew:std_logic_vector(2 downto 0);
begin

--splits the display output into their respective segments(left most =8 and rightmost=1)
segs(31 downto 28)<=num8;
segs(27 downto 24)<=num7;
segs(23 downto 20)<=num6;
segs(19 downto 16)<=num5;
segs(15 downto 12)<=num4;
segs(11 downto 8)<=num3;
segs(7 downto 4)<=num2;
segs(3 downto 0)<=num1;

an<=(an2) or an3;--allows me to control if certain displays are on for specific states

c1:clockdivider port map(clk1,clk);--change clock to 1hz
a1: D_ff_int port map(clk, rst,ncount,count);--set count to next count every 1 hz

s7: sevenseg_disp port map(segs,clk1,rst,an3,seg);--display count and crosswalk

num4<=std_logic_vector(to_unsigned(count,num1'length));--displays count

ncount<=(count +1) when not (count<0 or (cmax<=count)) else 0;--increases count or resets it depending on count and cmax

state<= nstate when (count=cmax and falling_edge(clk)) else state;--sets state on falling edge to prevent racing conditions


process(state, am_0am_6am,ew_car,ns_car,clk) begin--sets state logic(cmax,lights,crosswalk signals, next state, etc)

    if(rising_edge(clk)) then--prevents racing conditions
    
        case state is
            when 0 =>                                               --default state red both ways. will flash from midnight to 6am
                an2<="11110111";
                cmax<=1; 
                red_n<='1';
                red_s<='1';
                red_e<='1';
                red_w<='1';
                green_n<='0';
                green_s<='0';
                green_e<='0';
                green_w<='0';
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='0';
                yellow_w<='0';
                ledns<="001";
                ledew<="001";
                nstate<=1;
                
                if Am_0am_6am='1' and state=0 then
                    nstate<=8;
                end if;
                
                
            when 1 =>                                               --green ns waiting on midnight or car on ew
                an2<="01110111";
                red_n<='0';
                red_s<='0';
                red_e<='1';
                red_w<='1';
                
                green_n<='1';
                green_s<='1';
                green_e<='0';
                green_w<='0';
                
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='0';
                yellow_w<='0';
                
                ledns<="100";
                ledew<="001";
                cmax<=1;
                nstate<=1;
                num8<=std_logic_vector(to_unsigned(14,num1'length));
                
                if state=1 and (ew_car = '1' or Am_0am_6am='1') then
                    nstate<=2;
                end if;
                
                
            when 2 =>                                               --green ns with car on ew or midnight
                cmax<=15;
                red_n<='0';
                red_s<='0';
                red_e<='1';
                red_w<='1';
                
                green_n<='1';
                green_s<='1';
                green_e<='0';
                green_w<='0';
                
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='0';
                yellow_w<='0';
                
                ledns<="100";
                ledew<="001";
                nstate<=2;
                
                if cmax-(count+0)<10 and state=2 and cmax-(count+0)>0  then
                    num8<=std_logic_vector(to_unsigned(cmax-(count),num1'length));
                elsif(state=2) then
                    num8<=std_logic_vector(to_unsigned(14,num1'length));
                else
                    num8<=std_logic_vector(to_unsigned(0,num1'length));
                end if;
                
                if count>5 and state=2 then
                    nstate<=3;
                end if;
                
                
            when 3 =>                                               --yellow-ns 
                num8<=std_logic_vector(to_unsigned(0,num1'length));
                cmax<=4;
                red_n<='0';
                red_s<='0';
                red_e<='1';
                red_w<='1';
                
                green_n<='0';
                green_s<='0';
                green_e<='0';
                green_w<='0';
                
                yellow_n<='1';
                yellow_s<='1';
                yellow_e<='0';
                yellow_w<='0';
                                ledns<="101";
                ledew<="001";
                nstate<=4;
                
                
            when 4 =>                                               --red both ways 2
                an2<="11110111";
                cmax<=1;
                red_n<='1';
                red_s<='1';
                red_e<='1';
                red_w<='1';
                green_n<='0';
                green_s<='0';
                green_e<='0';
                green_w<='0';
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='0';
                yellow_w<='0';
                ledns<="001";
                ledew<="001";
                nstate<=5;
                
                if Am_0am_6am='1' and state=4 then
                    nstate<=8;
                end if;
                
                
            when 5=>                                                --green ew waiting for car on ns or midnight
                an2<="11110110";
                cmax<=1;
                red_n<='1';
                red_s<='1';
                red_e<='0';
                red_w<='0';
                
                green_n<='0';
                green_s<='0';
                green_e<='1';
                green_w<='1';
                
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='0';
                yellow_w<='0';
                ledns<="001";
                ledew<="100";
                
                nstate<=5;
                num1<=std_logic_vector(to_unsigned(14,num1'length));
                
                if state=5 and (ns_car = '1' or Am_0am_6am='1') then
                    nstate<=6;
                end if;
                
                
            when 6=>                                                --ew-green with car on ns 
                cmax<=15;
                red_n<='1';
                red_s<='1';
                red_e<='0';
                red_w<='0';
                
                green_n<='0';
                green_s<='0';
                green_e<='1';
                green_w<='1';
                
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='0';
                yellow_w<='0';
                ledns<="001";
                ledew<="100";
                nstate<=6;
                
                if cmax-(count+0)<10 and state=6 and cmax-(count+0)>0  then
                    num1<=std_logic_vector(to_unsigned(cmax-(count),num1'length));
                elsif(state=6) then
                    num1<=std_logic_vector(to_unsigned(14,num1'length));
                else
                    num1<=std_logic_vector(to_unsigned(0,num1'length));
                end if;
                
                if count>5 and state=6 then
                    nstate<=7;
                end if;
                
                
            when 7 =>                                               --yellow for ew
                num1<=std_logic_vector(to_unsigned(0,num1'length));
                cmax<=4;
                red_n<='1';
                red_s<='1';
                red_e<='0';
                red_w<='0';
                
                green_n<='0';
                green_s<='0';
                green_e<='0';
                green_w<='0';
                
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='1';
                yellow_w<='1';
                
                ledns<="001";
                ledew<="101";
                
                nstate<=0;
                
                
            when others =>                                          --state 8 flashing red lights 
                cmax<=1;
                red_n<='0';
                red_s<='0';
                red_e<='0';
                red_w<='0';
                green_n<='0';
                green_s<='0';
                green_e<='0';
                green_w<='0';
                yellow_n<='0';
                yellow_s<='0';
                yellow_e<='0';
                yellow_w<='0';
                ledns<="000";
                ledew<="000";
                nstate<=0;
        end case;
    end if;    
end process;



--if using single led lights use 2 downto 0 & 2 downto 0, otherwise if you are using 3 lights use 5 downto 3 & 5 downto 3
lights_ew(5 downto 0)<=red_w & yellow_w & green_w & red_e & yellow_e & green_e;--sets ew lights, 
lights_ns(5 downto 0)<=red_s & yellow_s & green_s & red_n & yellow_n & green_n;--sets ns lights,

led_ns<= ledns;
led_ew<= ledew;
end Behavioral;
