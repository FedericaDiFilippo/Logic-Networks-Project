----------------------------------------------------------------------------------

-- Module Name: project_reti_logiche - Behavioral
-- Federica Di Filippo
-- 10666561
-- 934669
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

component datapath is
    Port (
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_data: in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_data : out std_logic_vector (7 downto 0);
        U_load : in std_logic;
        Q0_load : in std_logic; 
        Q1_load : in std_logic;
        PK1_load : in std_logic;
        PK2_load : in std_logic;
        reg_sel : out std_logic_vector (1 downto 0);
        NP_load : in std_logic;
        IL_load : in std_logic;
        IS_load : in std_logic;
        address_sel : in std_logic;
        fine_parola : out std_logic;
        parole_finite : out std_logic;
        R0_load : in std_logic;
        R1_load : in std_logic;
        R2_load : in std_logic;
        R3_load : in std_logic;
        I_load : in std_logic;
        reset_all : in std_logic
         );
end component datapath;
    
signal U_load : std_logic; 
signal Q0_load : std_logic;
signal Q1_load : std_logic;
signal PK1_load : std_logic;
signal PK2_load : std_logic;
signal reg_sel : std_logic_vector (1 downto 0);
signal NP_load : std_logic;
signal IL_load : std_logic;
signal IS_load : std_logic;
signal address_sel : std_logic;
signal fine_parola : std_logic;
signal parole_finite : std_logic;
signal R0_load : std_logic;
signal R1_load : std_logic;
signal R2_load : std_logic;
signal R3_load : std_logic;
signal I_load : std_logic;
signal reset_all : std_logic;


type S is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14);
signal cur_state, next_state : S;

begin
    Datapath0: datapath port map (
            i_clk,
            i_rst,
            i_data,
            o_address,
            o_data,                            
            U_load,
            Q0_load,
            Q1_load,
            PK1_load,
            PK2_load,
            reg_sel,
            NP_load,
            IL_load,
            IS_load,
            address_sel,
            fine_parola,
            parole_finite,
            R0_load,
            R1_load,
            R2_load,
            R3_load,        
            I_load,
            reset_all
   );

  process(i_clk, i_rst)
    begin
        if(i_rst = '1') then
            cur_state <= S0;
        elsif i_clk'event and i_clk = '1' then
            cur_state <= next_state;
        end if;
    end process;

  process(i_clk, i_start,i_rst)
    begin        
        o_en <= '0';
        o_we <= '0';
        o_done <= '0';
        address_sel <= '0';
        IL_load <= '0';
        NP_load <= '0';
        IS_load <= '0';
        q0_load <= '0';
        q1_load <= '0';
        pk1_load <= '0';
        pk2_load <= '0';
        R0_load <= '0';        
        R1_load <= '0';
        R2_load <= '0';
        R3_load <= '0';
        U_load <= '0';
        i_load <= '0';
        reset_all <= '0';
        next_state <= cur_state;  
        case cur_state is
           when S0 => --stato di attesa di start
               if i_start = '1' then
                   next_state <= S1;
               end if;
            when S1 => --attivo lettura
                o_en <='1';
                if i_rst = '1' then
                    next_state <= S0;
                elsif i_rst = '0' then
                    next_state <= S2;
                end if;
           when S2 => --chiedo lettura NP
               NP_load <='1';
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst = '0' then
                   next_state <= S3;
               end if;
           when S3 =>    --aggiorno indirizzo lettura  
               IL_load <= '1';   
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst='0' then
                   if fine_parola = '1' and parole_finite = '1' then
                       next_state <= S14;
                   else  
                       next_state <= S4;
                   end if;  
               end if;  
           when S4 => --attivo lettura
               o_en <='1';
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst='0' then
                   next_state <= S5;
               end if;
           when S5 => --richiedo lettura di U
               U_load <= '1';
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst = '0' then
                   next_state <= S6; 
               end if;              
           when S6 => --wait  
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst = '0' then
                   next_state <= S7;
               end if;                        
           when S7 => --calcolo PK1,PK2, Q0,Q1
               q0_load <= '1';
               q1_load <= '1';
               pk1_load <= '1';
               pk2_load <= '1';                
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst='0' then
                   if reg_Sel = 0 then
                       next_state <= S8;
                   elsif reg_sel = 1 then
                       next_state <= S9; 
                   elsif reg_sel = 2 then
                       next_state <= S10;
                   elsif reg_sel = 3 then
                       next_state <= S11;
                   end if;
              end if;
           when S8 => --qui salvo in R0
               R0_load  <= '1'; 
               i_load <= '1';                                  
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst = '0' then
                   next_state <= S5;
               end if;
           when S9 => --qui salvo in R1
               R1_load <= '1';
               i_load <= '1'; 
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst = '0' then
                   next_state <= S5;
               end if;   
           when S10 => --qui salvo in R2
               R2_load <= '1';
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst='0' then
                    i_load <= '1';
                    next_state <= S5;
               end if;
           when S11 => --qui salvo in R3
               R3_load <='1';             
               address_sel <= '1'; 
               if i_rst = '1' then
                   next_state <= S0;
               elsif i_rst='0' then              
                   next_state <= S12;
               end if;
           when s12 => --wait 
                if i_rst = '1' then
                    next_state <= S0;
                elsif i_rst='0' then   
                    next_state <= S13; 
                end if;
           when S13 => --qui scrivo il valore trovato
                address_sel <= '1';
                o_en <='1';
                o_we <= '1'; 
                IS_load<='1';
                i_load <='1';
                if i_rst='1' then
                    next_state <= S0;
                elsif i_rst='0' then
                    if fine_parola = '1' AND parole_finite = '0' then
                        next_state <= S3;
                    elsif fine_parola='1' AND parole_finite = '1' then  
                        next_state <= S14;
                    else
                        next_state <= S4;
                    end if;
                end if;
           when S14 =>
               o_done <= '1'; 
               reset_all <= '1';
               next_state <= S0;
        end case;
   end process;
   
end Behavioral;

--DATAPATH

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Datapath is
    Port(
        i_clk: in std_logic;
        i_rst: in std_logic;
        i_data: in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_data : out std_logic_vector (7 downto 0);
        U_load : in std_logic;
        Q0_load : in std_logic; 
        Q1_load : in std_logic;
        PK1_load : in std_logic;
        PK2_load : in std_logic;
        reg_sel : out std_logic_vector (1 downto 0);
        NP_load : in std_logic;
        IL_load : in std_logic;
        IS_load : in std_logic;
        address_sel : in std_logic;
        fine_parola : out std_logic;
        parole_finite : out std_logic;
        R0_load : in std_logic;        
        R1_load : in std_logic;
        R2_load : in std_logic;
        R3_load : in std_logic;
        I_load : in std_logic;
        reset_all : in std_logic    
    );        
end Datapath;

architecture Behavioral of Datapath is
signal U : std_logic;
signal Q0 : std_logic;
signal Q1 : std_logic;
signal Q0_temp : std_logic;
signal Q1_temp : std_logic;
signal PK1 : std_logic;
signal PK2 : std_logic;
signal R0 : std_logic_vector (1 downto 0);
signal R1 : std_logic_vector (1 downto 0);
signal R2 : std_logic_vector (1 downto 0);
signal R3 : std_logic_vector (1 downto 0);
signal Numero_Parole : std_logic_vector (7 downto 0);
signal Indice_Lettura : std_logic_vector (15 downto 0);
signal Indice_Scrittura : std_logic_vector (15 downto 0); 
signal I : std_logic_vector(2 downto 0);

begin

    --lettura del numero di parole
    process(i_clk, i_rst)
    begin
        if(i_rst= '1' or reset_all ='1') then
            Numero_Parole <= "UUUUUUUU";
         elsif i_clk'event and i_clk = '1' then
            if(NP_load ='1') then
                Numero_parole <= i_data;                    
            end if;
        end if;
    end process;
         
    --lettura dei bit di ogni parola
    process(i_clk,i_rst)
    begin
        if(i_rst = '1'or reset_all = '1' ) then
            U <= 'U';
        elsif i_clk'event and i_clk = '1' then
           if(U_load ='1') then
               if(i = 7) then
                    U <= i_data(7);
               elsif(i = 6 ) then
                    U <= i_data(6);
               elsif(i = 5) then
                    U <= i_data(5);
               elsif(i = 4 ) then
                    U <= i_data(4);
               elsif(i = 3) then
                    U <= i_data(3);
               elsif(i = 2) then
                    U <= i_data(2);
               elsif(i = 1) then
                    U <= i_data(1);
               elsif(i = 0) then
                    U <= i_data(0);
               end if;                                   
           end if;
        end if;
    end process;
    
    process(i_clk,i_rst)
    begin
        if(i_rst = '1' or reset_all = '1') then
            i <= "111";
        elsif i_clk'event and i_clk = '1' then
            if (i_load = '1') then 
                i <= i-1;       
            end if;            
        end if;
    end process;

    fine_parola <= '1' when (i = 0 or numero_parole = 0) else '0';
   
    --incremento indirizzi per lettura e scrittura
    process(i_clk, i_rst)
    begin
        if(i_rst = '1' or reset_all = '1') then
            Indice_scrittura <= "0000001111101000";
        elsif i_clk'event and i_clk = '1' then
            if (IS_load = '1') then
                Indice_Scrittura <= indice_scrittura + 1;
            end if;
        end if;         
    end process;
    
    process(i_clk, i_rst)
    begin
        if(i_rst = '1' or reset_all = '1') then
            Indice_Lettura <= "0000000000000000";
        elsif i_clk'event and i_clk = '1' then
            if (IL_load = '1') then
                Indice_Lettura <= indice_lettura + 1; 
            end if;
        end if; 
   end process;
    
   parole_finite <= '1' when (indice_lettura = numero_parole or numero_parole = 0) else '0';
    
    
   with address_sel select
        o_address <= Indice_Lettura when '0',
                     Indice_Scrittura when '1',
                     "UUUUUUUUUUUUUUUU" when others;
        
    --calcolo PK1,PK2, Q0, Q1
   process(i_clk,i_rst)
   begin
        if(i_rst = '1' or reset_all = '1') then
              pk1 <= 'U';
              pk2 <= 'U';
              Q0 <= '0';
              Q1 <= '0';
              Q0_temp <= 'U';
              Q1_temp <= 'U';
        elsif i_clk'event and i_clk = '1' then                                                          
            Q0_temp <= Q0;
            Q1_temp <= Q1;
            if(pk2_load = '1') then
                pk2 <= ((Q0_temp and not(U xor Q1_temp)) or (not Q0_temp and(U xor Q1_temp))); 
            end if;
            if(pk1_load = '1') then
                pk1 <= (U xor Q1_temp);
            end if;
            if (Q0_load = '1') then
                Q0 <= U;
            end if;
            if (Q1_load = '1') then
                Q1 <= Q0_temp;
            end if;
        end if;
    end process;

    
    with i select
        reg_sel <= "11" when "000","11" when "100", --carico in R3 quando i = 0/4              
                   "10" when "001","10" when "101", --carico in R2 quando i = 1/5              
                   "01" when "010","01" when "110", --carico in R1 quando i = 2/6
                   "00" when "011","00" when "111", --carico in R0 quando i = 3/7              
                   "UU" when others;
               
    --salvo pk1,pk2 nei registri
    process(i_clk, i_rst)
    begin
        if( i_rst = '1' or reset_all = '1') then
            R0 <= "UU";
            R1 <= "UU";
            R2 <= "UU";
            R3 <= "UU";
        elsif i_clk'event and i_clk = '1' then
            if (R0_load ='1') then
                R0 <= pk1 & pk2; 
            elsif (R1_load ='1') then
                R1 <= pk1 & pk2;            
            elsif (R2_load ='1') then
                R2 <= pk1 & pk2;  
            elsif (R3_load ='1') then
                R3 <= pk1 & pk2;
            end if;
        end if;
    end process;
    
    process(i_clk, i_rst)
    begin
        if( i_rst = '1' or reset_all = '1') then
            o_data <= "UUUUUUUU";
        elsif i_clk'event and i_clk = '1' then                  
                o_data <= R0 & R1 & R2 & R3;
        end if;       
    end process;
      
end Behavioral;