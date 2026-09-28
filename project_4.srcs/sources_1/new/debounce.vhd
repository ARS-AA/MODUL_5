----------------------------------------------------------------------------------
-- debounce.vhd : debouncer berbasis pencacah stabilitas
-- Keluaran hanya berubah jika masukan stabil selama STABLE_MS milidetik.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Generic ( CLK_FREQ_HZ : integer := 100_000_000;
              STABLE_MS   : integer := 10 );
    Port ( clk     : in  STD_LOGIC;
           btn_in  : in  STD_LOGIC;    -- sinyal mentah dari tombol
           btn_out : out STD_LOGIC );  -- sinyal yang sudah bersih (debounced)
end debounce;

architecture Behavioral of debounce is
    constant LIMIT : integer := (CLK_FREQ_HZ / 1000) * STABLE_MS;
    signal ff1, ff2, ff3 : STD_LOGIC := '0';  -- ff1,ff2: synchronizer 2-tingkat; ff3: sampel sebelumnya
    signal cnt    : integer range 0 to LIMIT := 0;
    signal stable : STD_LOGIC := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            ff1 <= btn_in;
            ff2 <= ff1;
            ff3 <= ff2;

            if ff2 /= ff3 then          -- masukan (tersinkron) baru berubah -> hitung ulang
                cnt <= 0;
            elsif cnt < LIMIT then      -- masukan tidak berubah -> terus hitung
                cnt <= cnt + 1;
            else                        -- sudah stabil sepanjang LIMIT siklus
                stable <= ff2;
            end if;
        end if;
    end process;

    btn_out <= stable;
end Behavioral;