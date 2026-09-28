----------------------------------------------------------------------------------
-- js05_top.vhd : top-level Jobsheet 5 (Basys 3)
-- btnU/btnD/btnC -> debounce -> edge_detect (btnU/btnD) -> updown_counter
--                -> seven_seg_driver -> seg/an/dp
-- sw(0)='1' : freeze (btnU/btnD tidak mengubah nilai)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity js05_top is
    Port ( clk  : in  STD_LOGIC;
           btnU : in  STD_LOGIC;
           btnD : in  STD_LOGIC;
           btnC : in  STD_LOGIC;
           sw   : in  STD_LOGIC_VECTOR(0 downto 0);
           seg  : out STD_LOGIC_VECTOR(6 downto 0);
           dp   : out STD_LOGIC;
           an   : out STD_LOGIC_VECTOR(3 downto 0) );
end js05_top;

architecture Structural of js05_top is
    signal u_clean, d_clean, c_clean : STD_LOGIC;
    signal u_pulse, d_pulse          : STD_LOGIC;
    signal count                     : STD_LOGIC_VECTOR(15 downto 0);
    signal enable                    : STD_LOGIC;
begin
    enable <= not sw(0);

    -- Debounce
    db_u : entity work.debounce port map (clk => clk, btn_in => btnU, btn_out => u_clean);
    db_d : entity work.debounce port map (clk => clk, btn_in => btnD, btn_out => d_clean);
    db_c : entity work.debounce port map (clk => clk, btn_in => btnC, btn_out => c_clean);

    -- Deteksi tepi naik
    ed_u : entity work.edge_detect port map (clk => clk, sig_in => u_clean, pulse => u_pulse);
    ed_d : entity work.edge_detect port map (clk => clk, sig_in => d_clean, pulse => d_pulse);

    -- Pencacah
    cnt : entity work.updown_counter
        port map (clk => clk, clr => c_clean, enable => enable,
                  inc => u_pulse, dec => d_pulse, count => count);

    -- Seven-segment
    ssd : entity work.seven_seg_driver
        generic map (DIGITS => 4, HEX_MODE => true)
        port map (clk => clk, value => count, seg => seg, dp => dp, an => an);
end Structural;