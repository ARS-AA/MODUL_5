----------------------------------------------------------------------------------
-- tb_debounce.vhd : testbench debounce dengan masukan "berisik" (bouncing)
-- Clock 1 MHz dan STABLE_MS = 2 agar simulasi cepat (LIMIT = 2000 siklus = 2 ms).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_debounce is
end tb_debounce;

architecture sim of tb_debounce is
    constant CLK_PERIOD : time := 1 us;

    signal clk     : STD_LOGIC := '0';
    signal btn_in  : STD_LOGIC := '0';
    signal btn_out : STD_LOGIC;
    signal done    : boolean := false;
begin
    uut : entity work.debounce
        generic map ( CLK_FREQ_HZ => 1_000_000,
                      STABLE_MS   => 2 )
        port map ( clk => clk, btn_in => btn_in, btn_out => btn_out );

    clk <= not clk after CLK_PERIOD/2 when not done else clk;

    stim : process
    begin
        wait for 100 us;

        -- 1) Penekanan: bouncing 6 kali (tiap fase < 100 us), lalu stabil '1'
        for i in 1 to 6 loop
            btn_in <= '1'; wait for 30 us;
            btn_in <= '0'; wait for 50 us;
            assert btn_out = '0'
                report "GAGAL: btn_out berubah saat masih bouncing (tekan)" severity error;
        end loop;
        btn_in <= '1';
        wait for 5 ms;
        assert btn_out = '1'
            report "GAGAL: btn_out tidak menjadi '1' setelah stabil" severity error;

        -- 2) Pelepasan: bouncing 6 kali, lalu stabil '0'
        for i in 1 to 6 loop
            btn_in <= '0'; wait for 30 us;
            btn_in <= '1'; wait for 50 us;
            assert btn_out = '1'
                report "GAGAL: btn_out berubah saat masih bouncing (lepas)" severity error;
        end loop;
        btn_in <= '0';
        wait for 5 ms;
        assert btn_out = '0'
            report "GAGAL: btn_out tidak kembali '0' setelah stabil" severity error;

        -- 3) Glitch pendek (< STABLE_MS) harus diabaikan
        btn_in <= '1'; wait for 500 us;
        btn_in <= '0'; wait for 3 ms;
        assert btn_out = '0'
            report "GAGAL: glitch pendek lolos ke keluaran" severity error;

        report "Simulasi selesai." severity note;
        done <= true;
        wait;
    end process;
end sim;