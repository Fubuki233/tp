library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;

entity ALU is
    port (
        OP : in std_logic_vector(2 downto 0);   
        A, B : in std_logic_vector(31 downto 0);
        CPSR : out std_logic_vector(3 downto 0); -- output flags
        S : out std_logic_vector(31 downto 0) -- output
    );
end entity;

architecture Behavioral of ALU is 
    signal MediateResult : std_logic_vector(31 downto 0):=(others=>'0');
    signal comp : std_logic_vector(31 downto 0):=(others=>'0');
begin 
    process (OP, A, B) 
    begin 
        case OP is
            when "000" =>  -- ADD
                S <= std_logic_vector(signed(A) + signed(B));
                CPSR(1) <= '0'; 
                CPSR(0) <= '0';

            when "001" =>  -- B
                S <= B;

            when "010" =>  -- SUB
                S <= std_logic_vector(signed(A) - signed(B));
                CPSR(1) <= '0'; 
                CPSR(0) <= '0';

            when "011" =>  -- A
                S <= A;

            when "100" =>  -- OR
                S <= A or B;

            when "101" =>  -- AND
                S <= A and B;

            when "110" =>  -- XOR
                S <= A xor B;

            when "111" =>  -- NOT
                S <= not A;
            when others =>
        end case;
        MediateResult <= S;
        -- Set the N flag
        if MediateResult(31) = '1' then
             CPSR(3) <= '1';
        else
             CPSR(3) <= '0';
        end if;

        -- Set the Z flag
        if to_integer(unsigned(MediateResult))=0 then
            CPSR(2) <= '1';
        else
            CPSR(2) <= '0';
        end if;
    end process; 
end architecture;
