----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2025 22:24:08
-- Design Name: 
-- Module Name: UART_TB - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART_TB is
generic(
    CLK_FREQ    :  integer :=100_000_000;
    BAUD_RATE   :  integer :=115_200;
    STOP_BIT    :  integer :=1  );
end UART_TB;

architecture Behavioral of UART_TB is
component UART_DEMO
generic(
    CLK_FREQ    :  integer :=100_000_000;
    BAUD_RATE   :  integer :=115_200;
    STOP_BIT    :  integer :=1  );

port(
    Tx_Start_Tick_I :in std_logic;
    D_1_in          :in std_logic_vector(7 downto 0);
    D_2_in          :in std_logic_vector(7 downto 0);
    CLK             :in std_logic;
    Data_1_out      :out std_logic_vector(7 downto 0);
    Data_2_out      :out std_logic_vector(7 downto 0)
    );
end component;
signal D_1_in       : std_logic_vector(7 downto 0):=x"00";
signal D_2_in       : std_logic_vector(7 downto 0):=x"00";
signal clk          :std_logic                    :='0';
signal Data_1_out   :std_logic_vector(7 downto 0);
signal Data_2_out   :std_logic_vector(7 downto 0);
signal Tx_Start_Tick_I : std_logic :='0';
constant d_76       : std_logic_vector(7 downto 0)  :=x"76";
constant d_ac       : std_logic_vector(7 downto 0)  :=x"ac";

begin
dev_to_test :UART_DEMO
generic map(
    CLK_FREQ    => CLK_FREQ,
    BAUD_RATE   => BAUD_RATE,
    STOP_BIT    => STOP_BIT)
    
port map(
    Tx_Start_Tick_I => Tx_Start_Tick_I,
    D_1_in  =>  D_1_in,
    D_2_in  =>  D_2_in,
    Clk     => Clk,
    Data_1_out  => Data_1_out,
    Data_2_out  =>  Data_2_out
    );
    
clk_stimulus    :   process
begin
wait for 5ns;

Clk<= not Clk;
end process clk_stimulus;

data_stimulus   : process
begin 

Tx_Start_Tick_I <='1';
D_1_in <= d_76;
D_2_in <= d_ac;

wait for 100 us;
assert false
report "SIM DONE"
severity  failure;
end process data_stimulus;

end Behavioral;
