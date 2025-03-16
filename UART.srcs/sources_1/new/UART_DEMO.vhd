----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.03.2025 20:34:21
-- Design Name: 
-- Module Name: UART_DEMO - Behavioral
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

entity UART_DEMO is
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
    
end UART_DEMO;

architecture Behavioral of UART_DEMO is
component uart
generic (
    CLK_FREQ    :   integer:=100_000_000;
    BAUD_RATE   :   integer:=115_200;
    STOP_BIT    :   integer:=1
    );
    
port(
           Tx_Done_Tick_O : out STD_LOGIC;
           Tx_O : out STD_LOGIC;
           Data_O : out std_logic_vector(7 downto 0);
           Rx_Done_Tick_O : out STD_LOGIC;
           
           clk : in STD_LOGIC;
           Tx_Start_Tick_I : in STD_LOGIC :='0';
           D_in : in std_logic_vector(7 downto 0);
           Rx_I : in STD_LOGIC
           );
end component;

signal Rx_1                 : std_logic :='1';
signal Rx_2                 : std_logic :='1';
signal Tx_1                 : std_logic :='1';
signal Tx_2                 : std_logic :='1';
signal Tx_Done_Tick_O_2     : std_logic :='0';
signal Rx_Done_Tick_O_2     : std_logic :='0';
signal Tx_Done_Tick_O_1     : std_logic :='0';
signal Rx_Done_Tick_O_1     : std_logic :='0';

begin
UART_1 : uart
generic map(
    CLK_FREQ    => CLK_FREQ,
    BAUD_RATE   => BAUD_RATE,
    STOP_BIT    => STOP_BIT)
    
port map(
    
    Tx_Done_Tick_O  =>Tx_Done_Tick_O_1,
    Tx_O            => Tx_1,
    Data_O          =>Data_1_out,
    Rx_Done_Tick_O  => Rx_Done_Tick_O_1,
    clk             =>CLK,
    Tx_Start_Tick_I =>Tx_Start_Tick_I,
    D_in            =>D_1_in,
    Rx_I            =>Rx_1  );
    
UART_2 : uart
generic map(
    CLK_FREQ    => CLK_FREQ,
    BAUD_RATE   => BAUD_RATE,
    STOP_BIT    => STOP_BIT)
    
port map(
    
    Tx_Done_Tick_O  =>Tx_Done_Tick_O_2,
    Tx_O            => Tx_2,
    Data_O          =>Data_2_out,
    Rx_Done_Tick_O  => Rx_Done_Tick_O_2,
    clk             =>CLK,
    Tx_Start_Tick_I =>Tx_Start_Tick_I,
    D_in            =>D_2_in,
    Rx_I            =>Rx_2  );
    
    Rx_2<=Tx_1;
    Rx_1<=Tx_2;

    


end Behavioral;
