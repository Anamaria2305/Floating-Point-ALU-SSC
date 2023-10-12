library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity CU is
  port(A      : in  std_logic_vector(31 downto 0);
       B      : in  std_logic_vector(31 downto 0);
       clk ,enable, Operation   : in  std_logic;
       reset  : in  std_logic;
       start  : in  std_logic;
       done   : out std_logic;
       sum : out std_logic_vector(31 downto 0);
       ovf:out std_logic
       );
end CU;

architecture beh of CU is
  type ST is (WAIT_STATE, ALIGN_STATE, ADDITION_STATE, NORMALIZE_STATE, OUTPUT_STATE);
  signal state : ST := WAIT_STATE;

  signal A_mantissa, B_mantissa : std_logic_vector (24 downto 0);
  signal A_exp, B_exp           : std_logic_vector (8 downto 0);
  signal A_sgn, B_sgn           : std_logic;
  
  signal sum_exp: std_logic_vector (8 downto 0);
  signal sum_mantissa           : std_logic_vector (24 downto 0);
  signal sum_sgn           : std_logic;
  

begin
  
  Control_Unit : process (clk, reset,enable) is
  variable diff : signed(8 downto 0);
  variable off: std_logic ;
  begin
    if(reset = '1') then
      state <= WAIT_STATE;                 
      done    <= '0';
    elsif rising_edge(clk) then
      case state is
        when WAIT_STATE =>
          off:='0';
          if (start = '1') then 
            A_sgn      <= A(31);
            A_exp      <= '0' & A(30 downto 23);
            A_mantissa <= "01" & A(22 downto 0);
            if(Operation='1') then
            B_sgn      <= not B(31);
            else 
            B_sgn      <= B(31);
            end if;
            B_exp      <= '0' & B(30 downto 23);	
            B_mantissa <= "01" & B(22 downto 0);
            state    <= ALIGN_STATE;
          else
            state <= WAIT_STATE;    
          end if;
        when ALIGN_STATE =>  
          if unsigned(A_exp) > unsigned(B_exp) then
            diff := signed(A_exp) - signed(B_exp);
            if diff > 23 then
              sum_mantissa <= A_mantissa; 
			  sum_exp <= A_exp;
              sum_sgn      <= A_sgn;
              state      <= OUTPUT_STATE; 
            else       
			  sum_exp <= A_exp;
              B_mantissa(24-to_integer(diff) downto 0)  <= B_mantissa(24 downto to_integer(diff));
              B_mantissa(24 downto 25-to_integer(diff)) <= (others => '0');
              state                                   <= ADDITION_STATE;
            end if;
          elsif unsigned(A_exp) < unsigned(B_exp)  then   
            diff := signed(B_exp) - signed(A_exp);  
            if diff > 23 then
              sum_mantissa <= B_mantissa;  
              sum_sgn      <= B_sgn;
              sum_exp      <= B_exp; 
              state      <= OUTPUT_STATE;   
            else       
              sum_exp <= B_exp;
              A_mantissa(24-to_integer(diff) downto 0)  <= A_mantissa(24 downto to_integer(diff));
              A_mantissa(24 downto 25-to_integer(diff)) <= (others => '0');
              state                                   <= ADDITION_STATE;
            end if;
		  else				
		    sum_exp <= A_exp;
            state <= ADDITION_STATE;          
          end if;
        when ADDITION_STATE =>                    --Mantissa addition
          state <= NORMALIZE_STATE;
          if (A_sgn xor B_sgn) = '0' then  
            sum_mantissa <= std_logic_vector((unsigned(A_mantissa) + unsigned(B_mantissa)));	
            sum_sgn      <= A_sgn;     
          elsif unsigned(A_mantissa) >= unsigned(B_mantissa) then
            sum_mantissa <= std_logic_vector((unsigned(A_mantissa) - unsigned(B_mantissa)));	
            sum_sgn      <= A_sgn;
          else
            sum_mantissa <= std_logic_vector((unsigned(B_mantissa) - unsigned(A_mantissa)));	
            sum_sgn      <= B_sgn;
          end if;

        when NORMALIZE_STATE => 
          if(sum_mantissa(24) = '1') then  
          sum_mantissa <= '0' & sum_mantissa(24 downto 1); 
           sum_exp        <= std_logic_vector((unsigned(sum_exp)+ 1));
           off:='1';
           state      <= OUTPUT_STATE;
          elsif(sum_mantissa(23) = '0') then  
			  sum_mantissa <= sum_mantissa(23 downto 0) & '0';	
			  sum_exp <= std_logic_vector((unsigned(sum_exp)-1));
			  state<= NORMALIZE_STATE; 
          else
            state <= OUTPUT_STATE;
            
          end if;
        when OUTPUT_STATE =>
          sum(22 downto 0)  <= sum_mantissa(22 downto 0);
          sum(30 downto 23) <= sum_exp(7 downto 0);
          sum(31) <= sum_sgn;
          done              <= '1';   
         if (start = '0') then        
            done    <= '0';
            state <= WAIT_STATE;
          end if;
        when others => 
			state <= WAIT_STATE;  
      end case;
    end if;
    ovf<=off; 
  end process;

end beh;