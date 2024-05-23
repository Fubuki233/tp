library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
	port (
        CLK: in std_logic;
        RST: in std_logic;
        RegIO_DataIN: in std_logic_vector(31 downto 0);
        RegIO_WE : in std_logic; -- write flag
        RegIO_DataOUT: out std_logic_vector(31 downto 0) -- output
		);
end entity;

ARCHITECTURE Behavioral  OF decoder IS 
signal Reg: std_logic_vector(15 downto 0);
begin 
	process (CLK, RST)
	begin 
		if RST='1' then
        elsif  rising_edge(CLK) then
            if RegIO_WE='1' then
                Reg <= RegIO_DataIN;
            end if;
            RegIO_DataOUT <= Reg;
        end if;
 
	end process;
end architecture;