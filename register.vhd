library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG is
	port (
        CLK: in std_logic;
        RST: in std_logic;
        RA,RB,RW : in std_logic_vector(3 downto 0);--address
        W: in std_logic_vector(31 downto 0);
        WE : in std_logic; -- write flag
        A,B: out std_logic_vector(31 downto 0) -- output
		);
end entity;

ARCHITECTURE Behavioral  OF REG IS 
signal  Banc : std_logic_vector(31 downto 0);
begin
	process (CLK, RST)
	begin 
		if RST='1' then
            Banc <= "00000000000000000000000000000000";
        elsif  rising_edge(CLK) then
            Banc <= std_logic_vector(unsigned(Banc)+'1');
        end if;
 
	end process;
end architecture;