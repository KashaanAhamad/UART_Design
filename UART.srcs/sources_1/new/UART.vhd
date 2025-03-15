----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.03.2025 20:48:15
-- Design Name: 
-- Module Name: UART - Behavioral
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

entity UART is
    generic(CLK_FREQ  : integer := 100_000_000;
            BAUD_RATE : integer := 115_200;
            STOP_BIT  : integer := 1);
            
    Port ( Tx_Done_Tick_O : out STD_LOGIC;
           Tx_O : out STD_LOGIC;
           Data_O : out std_logic_vector(7 downto 0);
           Rx_Done_Tick_O : out STD_LOGIC;
           
           clk : in STD_LOGIC;
           Tx_Start_Tick_I : in STD_LOGIC :='0';
           D_in : in std_logic_vector(7 downto 0);
           Rx_I : in STD_LOGIC);
end UART;

architecture Behavioral of UART is
    type T_STATE is (Tx_IDLE,Tx_START,Tx_DATA,Tx_STOP);
    signal Tx_STATE : T_STATE :=Tx_IDLE;
    
    type R_STATE is (Rx_IDLE,Rx_START,Rx_DATA,Rx_STOP);
    signal RX_STATE : R_STATE :=Rx_IDLE;
    
    constant bit_timer_lim      :integer :=CLK_FREQ/BAUD_RATE;
    constant halfbit_timer_lim  :integer :=bit_timer_lim/2;
    signal bit_timer_Tx         :integer :=0;
    signal bit_cntr_Rx          :integer :=0;
    signal bit_timer_Rx         :integer :=0;
    signal bit_cntr_Tx          :integer :=0;
    signal tx_buffer            :std_logic_vector(7 downto 0);
    
    

begin
uart_tx:process (CLK)
begin
    if rising_edge(CLK) then
        if(Tx_Start_Tick_I='0') then
        Tx_STATE<=Tx_IDLE;
        else
            
            bit_timer_tx<=bit_timer_tx + 1;
            case Tx_STATE is
                when Tx_IDLE=>
                    Tx_O<='1';
                    Tx_Done_Tick_O <= '0';
                    
                    if(Tx_Start_Tick_I = '1') then
                        tx_buffer<=D_in;
                        Tx_O <='0';
                        Tx_State <= Tx_START;
                     end if;
                  when Tx_START  =>
                           --Tx_O<='0'
                           
                           if(bit_timer_tx=bit_timer_lim-1) then
                            
                                bit_timer_tx<=0;
                                Tx_STATE <=Tx_DATA;
                            end if;
                  WHEN Tx_DATA =>
                        Tx_O <= tx_buffer(bit_cntr_Tx);
                        
                        if bit_timer_tx=bit_timer_lim -1 then
                           bit_timer_tx <=0;
                           bit_cntr_tx <= bit_cntr_tx +1;
                                if bit_cntr_tx =7 then
                                    bit_timer_tx<=0;
                                    
                                    Tx_O <='1';
                                    Tx_STATE<= Tx_STOP;
                                 end if;
                          end if;
                    when Tx_STOP =>
                        
                        if(bit_timer_tx = bit_timer_lim -1 ) then
                            bit_timer_tx <=0;
                            bit_cntr_tx <=bit_cntr_tx +1;
                            
                            if bit_cntr_Tx =7 +STOP_BIT then
                                
                                bit_timer_tx <=0;
                                bit_cntr_Tx <=0;
                                Tx_Done_Tick_O<='1';
                                Tx_STATE <=Tx_IDLE;
                             end  if;
                          end if;
                          
                       end case;
                   end if;
               end if;
      end process uart_tx;
                                    
                           
                        


end Behavioral;
