library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is
	port (
        CLK: in std_logic;
        RST: in std_logic;
        Addr : in std_logic_vector(5 downto 0);--address
        DataOutput: out std_logic_vector(31 downto 0) -- output
		);
end entity;

ARCHITECTURE Behavioral  OF Data_Memory IS 
type table is array(63 downto 0) of std_logic_vector(31 downto 0); 
function init_banc return table is 
    variable result : table; 
    begin 
    for i in 63 downto 0 loop 
    result(i) := (others=>'0'); 
    end loop;   
    return result; 
    end init_banc;
signal Mem: table:=init_banc;
begin 
	process (CLK, RST)
	begin 
		if RST='1' then
            for i in 0 to 63 loop 
                Mem(i) <= std_logic_vector(to_unsigned(i, 32));
            end loop;   
        elsif  rising_edge(CLK) then
            DataOutput<=Mem(To_integer(Unsigned(Addr)));
        end if;

	end process;
end architecture;