----------------------------------------------------------------------------------
-- updown_counter.vhd : pencacah 16-bit naik/turun
-- inc/dec : pulsa 1-siklus dari edge_detect
-- clr     : reset sinkron ke nol (prioritas tertinggi)
-- enable  : '0' = freeze; inc/dec diabaikan (clr tetap bekerja)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity updown_counter is
    Port ( clk    : in  STD_LOGIC;
           clr    : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           inc    : in  STD_LOGIC;
           dec    : in  STD_LOGIC;
           count  : out STD_LOGIC_VECTOR(15 downto 0) );
end updown_counter;

architecture Behavioral of updown_counter is
    signal cnt : unsigned(15 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if clr = '1' then
                cnt <= (others => '0');
            elsif enable = '1' then
                if inc = '1' and dec = '0' then
                    cnt <= cnt + 1;
                elsif dec = '1' and inc = '0' then
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;

    count <= std_logic_vector(cnt);
end Behavioral;