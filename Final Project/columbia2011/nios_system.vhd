--megafunction wizard: %Altera SOPC Builder%
--GENERATION: STANDARD
--VERSION: WM1.0


--Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DM9000A_avalonS_arbitrator is 
        port (
              -- inputs:
                 signal DM9000A_avalonS_irq : IN STD_LOGIC;
                 signal DM9000A_avalonS_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal DM9000A_avalonS_address : OUT STD_LOGIC;
                 signal DM9000A_avalonS_chipselect_n : OUT STD_LOGIC;
                 signal DM9000A_avalonS_irq_from_sa : OUT STD_LOGIC;
                 signal DM9000A_avalonS_read_n : OUT STD_LOGIC;
                 signal DM9000A_avalonS_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal DM9000A_avalonS_reset_n : OUT STD_LOGIC;
                 signal DM9000A_avalonS_wait_counter_eq_0 : OUT STD_LOGIC;
                 signal DM9000A_avalonS_write_n : OUT STD_LOGIC;
                 signal DM9000A_avalonS_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_granted_DM9000A_avalonS : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_DM9000A_avalonS : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_DM9000A_avalonS : OUT STD_LOGIC;
                 signal cpu_data_master_requests_DM9000A_avalonS : OUT STD_LOGIC;
                 signal d1_DM9000A_avalonS_end_xfer : OUT STD_LOGIC
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of DM9000A_avalonS_arbitrator : entity is FALSE;
end entity DM9000A_avalonS_arbitrator;


architecture europa of DM9000A_avalonS_arbitrator is
                signal DM9000A_avalonS_allgrants :  STD_LOGIC;
                signal DM9000A_avalonS_allow_new_arb_cycle :  STD_LOGIC;
                signal DM9000A_avalonS_any_bursting_master_saved_grant :  STD_LOGIC;
                signal DM9000A_avalonS_any_continuerequest :  STD_LOGIC;
                signal DM9000A_avalonS_arb_counter_enable :  STD_LOGIC;
                signal DM9000A_avalonS_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal DM9000A_avalonS_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal DM9000A_avalonS_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal DM9000A_avalonS_beginbursttransfer_internal :  STD_LOGIC;
                signal DM9000A_avalonS_begins_xfer :  STD_LOGIC;
                signal DM9000A_avalonS_counter_load_value :  STD_LOGIC;
                signal DM9000A_avalonS_end_xfer :  STD_LOGIC;
                signal DM9000A_avalonS_firsttransfer :  STD_LOGIC;
                signal DM9000A_avalonS_grant_vector :  STD_LOGIC;
                signal DM9000A_avalonS_in_a_read_cycle :  STD_LOGIC;
                signal DM9000A_avalonS_in_a_write_cycle :  STD_LOGIC;
                signal DM9000A_avalonS_master_qreq_vector :  STD_LOGIC;
                signal DM9000A_avalonS_non_bursting_master_requests :  STD_LOGIC;
                signal DM9000A_avalonS_reg_firsttransfer :  STD_LOGIC;
                signal DM9000A_avalonS_slavearbiterlockenable :  STD_LOGIC;
                signal DM9000A_avalonS_slavearbiterlockenable2 :  STD_LOGIC;
                signal DM9000A_avalonS_unreg_firsttransfer :  STD_LOGIC;
                signal DM9000A_avalonS_wait_counter :  STD_LOGIC;
                signal DM9000A_avalonS_waits_for_read :  STD_LOGIC;
                signal DM9000A_avalonS_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_DM9000A_avalonS :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_DM9000A_avalonS :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_DM9000A_avalonS_wait_counter_eq_0 :  STD_LOGIC;
                signal internal_cpu_data_master_granted_DM9000A_avalonS :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_DM9000A_avalonS :  STD_LOGIC;
                signal internal_cpu_data_master_requests_DM9000A_avalonS :  STD_LOGIC;
                signal shifted_address_to_DM9000A_avalonS_from_cpu_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_DM9000A_avalonS_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT DM9000A_avalonS_end_xfer;
      end if;
    end if;

  end process;

  DM9000A_avalonS_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_DM9000A_avalonS);
  --assign DM9000A_avalonS_readdata_from_sa = DM9000A_avalonS_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  DM9000A_avalonS_readdata_from_sa <= DM9000A_avalonS_readdata;
  internal_cpu_data_master_requests_DM9000A_avalonS <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(20 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("100000001001000010000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --DM9000A_avalonS_arb_share_counter set values, which is an e_mux
  DM9000A_avalonS_arb_share_set_values <= std_logic_vector'("01");
  --DM9000A_avalonS_non_bursting_master_requests mux, which is an e_mux
  DM9000A_avalonS_non_bursting_master_requests <= internal_cpu_data_master_requests_DM9000A_avalonS;
  --DM9000A_avalonS_any_bursting_master_saved_grant mux, which is an e_mux
  DM9000A_avalonS_any_bursting_master_saved_grant <= std_logic'('0');
  --DM9000A_avalonS_arb_share_counter_next_value assignment, which is an e_assign
  DM9000A_avalonS_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(DM9000A_avalonS_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (DM9000A_avalonS_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(DM9000A_avalonS_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (DM9000A_avalonS_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --DM9000A_avalonS_allgrants all slave grants, which is an e_mux
  DM9000A_avalonS_allgrants <= DM9000A_avalonS_grant_vector;
  --DM9000A_avalonS_end_xfer assignment, which is an e_assign
  DM9000A_avalonS_end_xfer <= NOT ((DM9000A_avalonS_waits_for_read OR DM9000A_avalonS_waits_for_write));
  --end_xfer_arb_share_counter_term_DM9000A_avalonS arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_DM9000A_avalonS <= DM9000A_avalonS_end_xfer AND (((NOT DM9000A_avalonS_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --DM9000A_avalonS_arb_share_counter arbitration counter enable, which is an e_assign
  DM9000A_avalonS_arb_counter_enable <= ((end_xfer_arb_share_counter_term_DM9000A_avalonS AND DM9000A_avalonS_allgrants)) OR ((end_xfer_arb_share_counter_term_DM9000A_avalonS AND NOT DM9000A_avalonS_non_bursting_master_requests));
  --DM9000A_avalonS_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      DM9000A_avalonS_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(DM9000A_avalonS_arb_counter_enable) = '1' then 
        DM9000A_avalonS_arb_share_counter <= DM9000A_avalonS_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --DM9000A_avalonS_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      DM9000A_avalonS_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((DM9000A_avalonS_master_qreq_vector AND end_xfer_arb_share_counter_term_DM9000A_avalonS)) OR ((end_xfer_arb_share_counter_term_DM9000A_avalonS AND NOT DM9000A_avalonS_non_bursting_master_requests)))) = '1' then 
        DM9000A_avalonS_slavearbiterlockenable <= or_reduce(DM9000A_avalonS_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master DM9000A/avalonS arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= DM9000A_avalonS_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --DM9000A_avalonS_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  DM9000A_avalonS_slavearbiterlockenable2 <= or_reduce(DM9000A_avalonS_arb_share_counter_next_value);
  --cpu/data_master DM9000A/avalonS arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= DM9000A_avalonS_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --DM9000A_avalonS_any_continuerequest at least one master continues requesting, which is an e_assign
  DM9000A_avalonS_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_DM9000A_avalonS <= internal_cpu_data_master_requests_DM9000A_avalonS;
  --DM9000A_avalonS_writedata mux, which is an e_mux
  DM9000A_avalonS_writedata <= cpu_data_master_writedata (15 DOWNTO 0);
  --master is always granted when requested
  internal_cpu_data_master_granted_DM9000A_avalonS <= internal_cpu_data_master_qualified_request_DM9000A_avalonS;
  --cpu/data_master saved-grant DM9000A/avalonS, which is an e_assign
  cpu_data_master_saved_grant_DM9000A_avalonS <= internal_cpu_data_master_requests_DM9000A_avalonS;
  --allow new arb cycle for DM9000A/avalonS, which is an e_assign
  DM9000A_avalonS_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  DM9000A_avalonS_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  DM9000A_avalonS_master_qreq_vector <= std_logic'('1');
  --DM9000A_avalonS_reset_n assignment, which is an e_assign
  DM9000A_avalonS_reset_n <= reset_n;
  DM9000A_avalonS_chipselect_n <= NOT internal_cpu_data_master_granted_DM9000A_avalonS;
  --DM9000A_avalonS_firsttransfer first transaction, which is an e_assign
  DM9000A_avalonS_firsttransfer <= A_WE_StdLogic((std_logic'(DM9000A_avalonS_begins_xfer) = '1'), DM9000A_avalonS_unreg_firsttransfer, DM9000A_avalonS_reg_firsttransfer);
  --DM9000A_avalonS_unreg_firsttransfer first transaction, which is an e_assign
  DM9000A_avalonS_unreg_firsttransfer <= NOT ((DM9000A_avalonS_slavearbiterlockenable AND DM9000A_avalonS_any_continuerequest));
  --DM9000A_avalonS_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      DM9000A_avalonS_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(DM9000A_avalonS_begins_xfer) = '1' then 
        DM9000A_avalonS_reg_firsttransfer <= DM9000A_avalonS_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --DM9000A_avalonS_beginbursttransfer_internal begin burst transfer, which is an e_assign
  DM9000A_avalonS_beginbursttransfer_internal <= DM9000A_avalonS_begins_xfer;
  --~DM9000A_avalonS_read_n assignment, which is an e_mux
  DM9000A_avalonS_read_n <= NOT ((((internal_cpu_data_master_granted_DM9000A_avalonS AND cpu_data_master_read)) AND NOT DM9000A_avalonS_begins_xfer));
  --~DM9000A_avalonS_write_n assignment, which is an e_mux
  DM9000A_avalonS_write_n <= NOT (((((internal_cpu_data_master_granted_DM9000A_avalonS AND cpu_data_master_write)) AND NOT DM9000A_avalonS_begins_xfer) AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(DM9000A_avalonS_wait_counter)))>=std_logic_vector'("00000000000000000000000000000001"))))));
  shifted_address_to_DM9000A_avalonS_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --DM9000A_avalonS_address mux, which is an e_mux
  DM9000A_avalonS_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_DM9000A_avalonS_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_DM9000A_avalonS_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_DM9000A_avalonS_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_DM9000A_avalonS_end_xfer <= DM9000A_avalonS_end_xfer;
      end if;
    end if;

  end process;

  --DM9000A_avalonS_waits_for_read in a cycle, which is an e_mux
  DM9000A_avalonS_waits_for_read <= DM9000A_avalonS_in_a_read_cycle AND DM9000A_avalonS_begins_xfer;
  --DM9000A_avalonS_in_a_read_cycle assignment, which is an e_assign
  DM9000A_avalonS_in_a_read_cycle <= internal_cpu_data_master_granted_DM9000A_avalonS AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= DM9000A_avalonS_in_a_read_cycle;
  --DM9000A_avalonS_waits_for_write in a cycle, which is an e_mux
  DM9000A_avalonS_waits_for_write <= DM9000A_avalonS_in_a_write_cycle AND wait_for_DM9000A_avalonS_counter;
  --DM9000A_avalonS_in_a_write_cycle assignment, which is an e_assign
  DM9000A_avalonS_in_a_write_cycle <= internal_cpu_data_master_granted_DM9000A_avalonS AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= DM9000A_avalonS_in_a_write_cycle;
  internal_DM9000A_avalonS_wait_counter_eq_0 <= to_std_logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(DM9000A_avalonS_wait_counter))) = std_logic_vector'("00000000000000000000000000000000")));
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      DM9000A_avalonS_wait_counter <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        DM9000A_avalonS_wait_counter <= DM9000A_avalonS_counter_load_value;
      end if;
    end if;

  end process;

  DM9000A_avalonS_counter_load_value <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(((DM9000A_avalonS_in_a_write_cycle AND DM9000A_avalonS_begins_xfer))) = '1'), std_logic_vector'("000000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'((NOT internal_DM9000A_avalonS_wait_counter_eq_0)) = '1'), ((std_logic_vector'("00000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(DM9000A_avalonS_wait_counter))) - std_logic_vector'("000000000000000000000000000000001")), std_logic_vector'("000000000000000000000000000000000"))));
  wait_for_DM9000A_avalonS_counter <= DM9000A_avalonS_begins_xfer OR NOT internal_DM9000A_avalonS_wait_counter_eq_0;
  --assign DM9000A_avalonS_irq_from_sa = DM9000A_avalonS_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  DM9000A_avalonS_irq_from_sa <= DM9000A_avalonS_irq;
  --vhdl renameroo for output signals
  DM9000A_avalonS_wait_counter_eq_0 <= internal_DM9000A_avalonS_wait_counter_eq_0;
  --vhdl renameroo for output signals
  cpu_data_master_granted_DM9000A_avalonS <= internal_cpu_data_master_granted_DM9000A_avalonS;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_DM9000A_avalonS <= internal_cpu_data_master_qualified_request_DM9000A_avalonS;
  --vhdl renameroo for output signals
  cpu_data_master_requests_DM9000A_avalonS <= internal_cpu_data_master_requests_DM9000A_avalonS;
--synthesis translate_off
    --DM9000A/avalonS enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity audio_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal audio_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal audio_avalon_slave_0_reset_n : OUT STD_LOGIC;
                 signal audio_avalon_slave_0_write : OUT STD_LOGIC;
                 signal audio_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_byteenable_audio_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_granted_audio_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_audio_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_audio_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_audio_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_audio_avalon_slave_0_end_xfer : OUT STD_LOGIC
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of audio_avalon_slave_0_arbitrator : entity is FALSE;
end entity audio_avalon_slave_0_arbitrator;


architecture europa of audio_avalon_slave_0_arbitrator is
                signal audio_avalon_slave_0_allgrants :  STD_LOGIC;
                signal audio_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal audio_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal audio_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal audio_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal audio_avalon_slave_0_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal audio_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal audio_avalon_slave_0_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal audio_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal audio_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal audio_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal audio_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal audio_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal audio_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal audio_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal audio_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal audio_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal audio_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal audio_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal audio_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal audio_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal audio_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal audio_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_byteenable_audio_avalon_slave_0_segment_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_byteenable_audio_avalon_slave_0_segment_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_audio_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_audio_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_byteenable_audio_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_data_master_granted_audio_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_audio_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_audio_avalon_slave_0 :  STD_LOGIC;
                signal shifted_address_to_audio_avalon_slave_0_from_cpu_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_audio_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT audio_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  audio_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_audio_avalon_slave_0);
  internal_cpu_data_master_requests_audio_avalon_slave_0 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(20 DOWNTO 1) & A_ToStdLogicVector(std_logic'('0'))) = std_logic_vector'("000000000000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_write;
  --audio_avalon_slave_0_arb_share_counter set values, which is an e_mux
  audio_avalon_slave_0_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_audio_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001")), 2);
  --audio_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  audio_avalon_slave_0_non_bursting_master_requests <= internal_cpu_data_master_requests_audio_avalon_slave_0;
  --audio_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  audio_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --audio_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  audio_avalon_slave_0_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(audio_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (audio_avalon_slave_0_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(audio_avalon_slave_0_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (audio_avalon_slave_0_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --audio_avalon_slave_0_allgrants all slave grants, which is an e_mux
  audio_avalon_slave_0_allgrants <= audio_avalon_slave_0_grant_vector;
  --audio_avalon_slave_0_end_xfer assignment, which is an e_assign
  audio_avalon_slave_0_end_xfer <= NOT ((audio_avalon_slave_0_waits_for_read OR audio_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_audio_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_audio_avalon_slave_0 <= audio_avalon_slave_0_end_xfer AND (((NOT audio_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --audio_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  audio_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_audio_avalon_slave_0 AND audio_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_audio_avalon_slave_0 AND NOT audio_avalon_slave_0_non_bursting_master_requests));
  --audio_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      audio_avalon_slave_0_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(audio_avalon_slave_0_arb_counter_enable) = '1' then 
        audio_avalon_slave_0_arb_share_counter <= audio_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --audio_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      audio_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((audio_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_audio_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_audio_avalon_slave_0 AND NOT audio_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        audio_avalon_slave_0_slavearbiterlockenable <= or_reduce(audio_avalon_slave_0_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master audio/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= audio_avalon_slave_0_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --audio_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  audio_avalon_slave_0_slavearbiterlockenable2 <= or_reduce(audio_avalon_slave_0_arb_share_counter_next_value);
  --cpu/data_master audio/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= audio_avalon_slave_0_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --audio_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  audio_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_audio_avalon_slave_0 <= internal_cpu_data_master_requests_audio_avalon_slave_0 AND NOT (((((NOT cpu_data_master_waitrequest OR cpu_data_master_no_byte_enables_and_last_term) OR NOT(or_reduce(internal_cpu_data_master_byteenable_audio_avalon_slave_0)))) AND cpu_data_master_write));
  --audio_avalon_slave_0_writedata mux, which is an e_mux
  audio_avalon_slave_0_writedata <= cpu_data_master_dbs_write_16;
  --master is always granted when requested
  internal_cpu_data_master_granted_audio_avalon_slave_0 <= internal_cpu_data_master_qualified_request_audio_avalon_slave_0;
  --cpu/data_master saved-grant audio/avalon_slave_0, which is an e_assign
  cpu_data_master_saved_grant_audio_avalon_slave_0 <= internal_cpu_data_master_requests_audio_avalon_slave_0;
  --allow new arb cycle for audio/avalon_slave_0, which is an e_assign
  audio_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  audio_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  audio_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --audio_avalon_slave_0_reset_n assignment, which is an e_assign
  audio_avalon_slave_0_reset_n <= reset_n;
  audio_avalon_slave_0_chipselect <= internal_cpu_data_master_granted_audio_avalon_slave_0;
  --audio_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  audio_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(audio_avalon_slave_0_begins_xfer) = '1'), audio_avalon_slave_0_unreg_firsttransfer, audio_avalon_slave_0_reg_firsttransfer);
  --audio_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  audio_avalon_slave_0_unreg_firsttransfer <= NOT ((audio_avalon_slave_0_slavearbiterlockenable AND audio_avalon_slave_0_any_continuerequest));
  --audio_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      audio_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(audio_avalon_slave_0_begins_xfer) = '1' then 
        audio_avalon_slave_0_reg_firsttransfer <= audio_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --audio_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  audio_avalon_slave_0_beginbursttransfer_internal <= audio_avalon_slave_0_begins_xfer;
  --audio_avalon_slave_0_write assignment, which is an e_mux
  audio_avalon_slave_0_write <= internal_cpu_data_master_granted_audio_avalon_slave_0 AND cpu_data_master_write;
  shifted_address_to_audio_avalon_slave_0_from_cpu_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 21);
  --d1_audio_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_audio_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_audio_avalon_slave_0_end_xfer <= audio_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  --audio_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  audio_avalon_slave_0_waits_for_read <= audio_avalon_slave_0_in_a_read_cycle AND audio_avalon_slave_0_begins_xfer;
  --audio_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  audio_avalon_slave_0_in_a_read_cycle <= internal_cpu_data_master_granted_audio_avalon_slave_0 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= audio_avalon_slave_0_in_a_read_cycle;
  --audio_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  audio_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(audio_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --audio_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  audio_avalon_slave_0_in_a_write_cycle <= internal_cpu_data_master_granted_audio_avalon_slave_0 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= audio_avalon_slave_0_in_a_write_cycle;
  wait_for_audio_avalon_slave_0_counter <= std_logic'('0');
  (cpu_data_master_byteenable_audio_avalon_slave_0_segment_1(1), cpu_data_master_byteenable_audio_avalon_slave_0_segment_1(0), cpu_data_master_byteenable_audio_avalon_slave_0_segment_0(1), cpu_data_master_byteenable_audio_avalon_slave_0_segment_0(0)) <= cpu_data_master_byteenable;
  internal_cpu_data_master_byteenable_audio_avalon_slave_0 <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_dbs_address(1)))) = std_logic_vector'("00000000000000000000000000000000"))), cpu_data_master_byteenable_audio_avalon_slave_0_segment_0, cpu_data_master_byteenable_audio_avalon_slave_0_segment_1);
  --vhdl renameroo for output signals
  cpu_data_master_byteenable_audio_avalon_slave_0 <= internal_cpu_data_master_byteenable_audio_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_granted_audio_avalon_slave_0 <= internal_cpu_data_master_granted_audio_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_audio_avalon_slave_0 <= internal_cpu_data_master_qualified_request_audio_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_requests_audio_avalon_slave_0 <= internal_cpu_data_master_requests_audio_avalon_slave_0;
--synthesis translate_off
    --audio/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_jtag_debug_module_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                 signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_reset : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                 signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of cpu_jtag_debug_module_arbitrator : entity is FALSE;
end entity cpu_jtag_debug_module_arbitrator;


architecture europa of cpu_jtag_debug_module_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_jtag_debug_module_allgrants :  STD_LOGIC;
                signal cpu_jtag_debug_module_allow_new_arb_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_bursting_master_saved_grant :  STD_LOGIC;
                signal cpu_jtag_debug_module_any_continuerequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_counter_enable :  STD_LOGIC;
                signal cpu_jtag_debug_module_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_arbitration_holdoff_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_beginbursttransfer_internal :  STD_LOGIC;
                signal cpu_jtag_debug_module_begins_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_in_a_read_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_in_a_write_cycle :  STD_LOGIC;
                signal cpu_jtag_debug_module_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_non_bursting_master_requests :  STD_LOGIC;
                signal cpu_jtag_debug_module_reg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_jtag_debug_module_slavearbiterlockenable :  STD_LOGIC;
                signal cpu_jtag_debug_module_slavearbiterlockenable2 :  STD_LOGIC;
                signal cpu_jtag_debug_module_unreg_firsttransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_read :  STD_LOGIC;
                signal cpu_jtag_debug_module_waits_for_write :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_cpu_jtag_debug_module :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal internal_cpu_jtag_debug_module_reset_n :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module :  STD_LOGIC;
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_cpu_jtag_debug_module_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT cpu_jtag_debug_module_end_xfer;
      end if;
    end if;

  end process;

  cpu_jtag_debug_module_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_cpu_jtag_debug_module OR internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module));
  --assign cpu_jtag_debug_module_readdata_from_sa = cpu_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_readdata_from_sa <= cpu_jtag_debug_module_readdata;
  internal_cpu_data_master_requests_cpu_jtag_debug_module <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(20 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("100000000100000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --cpu_jtag_debug_module_arb_share_counter set values, which is an e_mux
  cpu_jtag_debug_module_arb_share_set_values <= std_logic_vector'("01");
  --cpu_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  cpu_jtag_debug_module_non_bursting_master_requests <= ((internal_cpu_data_master_requests_cpu_jtag_debug_module OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module) OR internal_cpu_data_master_requests_cpu_jtag_debug_module) OR internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  cpu_jtag_debug_module_any_bursting_master_saved_grant <= std_logic'('0');
  --cpu_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  cpu_jtag_debug_module_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_jtag_debug_module_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(cpu_jtag_debug_module_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (cpu_jtag_debug_module_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --cpu_jtag_debug_module_allgrants all slave grants, which is an e_mux
  cpu_jtag_debug_module_allgrants <= ((or_reduce(cpu_jtag_debug_module_grant_vector) OR or_reduce(cpu_jtag_debug_module_grant_vector)) OR or_reduce(cpu_jtag_debug_module_grant_vector)) OR or_reduce(cpu_jtag_debug_module_grant_vector);
  --cpu_jtag_debug_module_end_xfer assignment, which is an e_assign
  cpu_jtag_debug_module_end_xfer <= NOT ((cpu_jtag_debug_module_waits_for_read OR cpu_jtag_debug_module_waits_for_write));
  --end_xfer_arb_share_counter_term_cpu_jtag_debug_module arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_cpu_jtag_debug_module <= cpu_jtag_debug_module_end_xfer AND (((NOT cpu_jtag_debug_module_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --cpu_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  cpu_jtag_debug_module_arb_counter_enable <= ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND cpu_jtag_debug_module_allgrants)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests));
  --cpu_jtag_debug_module_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_arb_counter_enable) = '1' then 
        cpu_jtag_debug_module_arb_share_counter <= cpu_jtag_debug_module_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(cpu_jtag_debug_module_master_qreq_vector) AND end_xfer_arb_share_counter_term_cpu_jtag_debug_module)) OR ((end_xfer_arb_share_counter_term_cpu_jtag_debug_module AND NOT cpu_jtag_debug_module_non_bursting_master_requests)))) = '1' then 
        cpu_jtag_debug_module_slavearbiterlockenable <= or_reduce(cpu_jtag_debug_module_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --cpu_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  cpu_jtag_debug_module_slavearbiterlockenable2 <= or_reduce(cpu_jtag_debug_module_arb_share_counter_next_value);
  --cpu/data_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= cpu_jtag_debug_module_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master cpu/jtag_debug_module arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= cpu_jtag_debug_module_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module))))));
      end if;
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  cpu_jtag_debug_module_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module AND NOT (((((NOT cpu_data_master_waitrequest) AND cpu_data_master_write)) OR cpu_instruction_master_arbiterlock));
  --cpu_jtag_debug_module_writedata mux, which is an e_mux
  cpu_jtag_debug_module_writedata <= cpu_data_master_writedata;
  --mux cpu_jtag_debug_module_debugaccess, which is an e_mux
  cpu_jtag_debug_module_debugaccess <= cpu_data_master_debugaccess;
  internal_cpu_instruction_master_requests_cpu_jtag_debug_module <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(20 DOWNTO 11) & std_logic_vector'("00000000000")) = std_logic_vector'("100000000100000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted cpu/jtag_debug_module last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_cpu_jtag_debug_module) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_cpu_jtag_debug_module))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module))))));
      end if;
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_cpu_jtag_debug_module AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module AND NOT (cpu_data_master_arbiterlock);
  --allow new arb cycle for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --cpu/instruction_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_instruction_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(0);
  --cpu/instruction_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_instruction_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(0) AND internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --cpu/data_master assignment into master qualified-requests vector for cpu/jtag_debug_module, which is an e_assign
  cpu_jtag_debug_module_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --cpu/data_master grant cpu/jtag_debug_module, which is an e_assign
  internal_cpu_data_master_granted_cpu_jtag_debug_module <= cpu_jtag_debug_module_grant_vector(1);
  --cpu/data_master saved-grant cpu/jtag_debug_module, which is an e_assign
  cpu_data_master_saved_grant_cpu_jtag_debug_module <= cpu_jtag_debug_module_arb_winner(1) AND internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --cpu/jtag_debug_module chosen-master double-vector, which is an e_assign
  cpu_jtag_debug_module_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((cpu_jtag_debug_module_master_qreq_vector & cpu_jtag_debug_module_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT cpu_jtag_debug_module_master_qreq_vector & NOT cpu_jtag_debug_module_master_qreq_vector))) + (std_logic_vector'("000") & (cpu_jtag_debug_module_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  cpu_jtag_debug_module_arb_winner <= A_WE_StdLogicVector((std_logic'(((cpu_jtag_debug_module_allow_new_arb_cycle AND or_reduce(cpu_jtag_debug_module_grant_vector)))) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
  --saved cpu_jtag_debug_module_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_allow_new_arb_cycle) = '1' then 
        cpu_jtag_debug_module_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1'), cpu_jtag_debug_module_grant_vector, cpu_jtag_debug_module_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  cpu_jtag_debug_module_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(1) OR cpu_jtag_debug_module_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((cpu_jtag_debug_module_chosen_master_double_vector(0) OR cpu_jtag_debug_module_chosen_master_double_vector(2)))));
  --cpu/jtag_debug_module chosen master rotated left, which is an e_assign
  cpu_jtag_debug_module_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(cpu_jtag_debug_module_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --cpu/jtag_debug_module's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(cpu_jtag_debug_module_grant_vector)) = '1' then 
        cpu_jtag_debug_module_arb_addend <= A_WE_StdLogicVector((std_logic'(cpu_jtag_debug_module_end_xfer) = '1'), cpu_jtag_debug_module_chosen_master_rot_left, cpu_jtag_debug_module_grant_vector);
      end if;
    end if;

  end process;

  cpu_jtag_debug_module_begintransfer <= cpu_jtag_debug_module_begins_xfer;
  --assign lhs ~cpu_jtag_debug_module_reset of type reset_n to cpu_jtag_debug_module_reset_n, which is an e_assign
  cpu_jtag_debug_module_reset <= NOT internal_cpu_jtag_debug_module_reset_n;
  --cpu_jtag_debug_module_reset_n assignment, which is an e_assign
  internal_cpu_jtag_debug_module_reset_n <= reset_n;
  --assign cpu_jtag_debug_module_resetrequest_from_sa = cpu_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  cpu_jtag_debug_module_resetrequest_from_sa <= cpu_jtag_debug_module_resetrequest;
  cpu_jtag_debug_module_chipselect <= internal_cpu_data_master_granted_cpu_jtag_debug_module OR internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --cpu_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_firsttransfer <= A_WE_StdLogic((std_logic'(cpu_jtag_debug_module_begins_xfer) = '1'), cpu_jtag_debug_module_unreg_firsttransfer, cpu_jtag_debug_module_reg_firsttransfer);
  --cpu_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  cpu_jtag_debug_module_unreg_firsttransfer <= NOT ((cpu_jtag_debug_module_slavearbiterlockenable AND cpu_jtag_debug_module_any_continuerequest));
  --cpu_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      cpu_jtag_debug_module_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(cpu_jtag_debug_module_begins_xfer) = '1' then 
        cpu_jtag_debug_module_reg_firsttransfer <= cpu_jtag_debug_module_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  cpu_jtag_debug_module_beginbursttransfer_internal <= cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  cpu_jtag_debug_module_arbitration_holdoff_internal <= cpu_jtag_debug_module_begins_xfer AND cpu_jtag_debug_module_firsttransfer;
  --cpu_jtag_debug_module_write assignment, which is an e_mux
  cpu_jtag_debug_module_write <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --cpu_jtag_debug_module_address mux, which is an e_mux
  cpu_jtag_debug_module_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010"))), (A_SRL(shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000010")))), 9);
  shifted_address_to_cpu_jtag_debug_module_from_cpu_instruction_master <= cpu_instruction_master_address_to_slave;
  --d1_cpu_jtag_debug_module_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_cpu_jtag_debug_module_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_cpu_jtag_debug_module_end_xfer <= cpu_jtag_debug_module_end_xfer;
      end if;
    end if;

  end process;

  --cpu_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_read <= cpu_jtag_debug_module_in_a_read_cycle AND cpu_jtag_debug_module_begins_xfer;
  --cpu_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_read_cycle <= ((internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_cpu_jtag_debug_module AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= cpu_jtag_debug_module_in_a_read_cycle;
  --cpu_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  cpu_jtag_debug_module_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --cpu_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  cpu_jtag_debug_module_in_a_write_cycle <= internal_cpu_data_master_granted_cpu_jtag_debug_module AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= cpu_jtag_debug_module_in_a_write_cycle;
  wait_for_cpu_jtag_debug_module_counter <= std_logic'('0');
  --cpu_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  cpu_jtag_debug_module_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_cpu_jtag_debug_module)) = '1'), (std_logic_vector'("0000000000000000000000000000") & (cpu_data_master_byteenable)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 4);
  --vhdl renameroo for output signals
  cpu_data_master_granted_cpu_jtag_debug_module <= internal_cpu_data_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_data_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_data_master_requests_cpu_jtag_debug_module <= internal_cpu_data_master_requests_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_cpu_jtag_debug_module <= internal_cpu_instruction_master_granted_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_cpu_jtag_debug_module <= internal_cpu_instruction_master_qualified_request_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_cpu_jtag_debug_module <= internal_cpu_instruction_master_requests_cpu_jtag_debug_module;
  --vhdl renameroo for output signals
  cpu_jtag_debug_module_reset_n <= internal_cpu_jtag_debug_module_reset_n;
--synthesis translate_off
    --cpu/jtag_debug_module enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line, now);
          write(write_line, string'(": "));
          write(write_line, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line.all);
          deallocate (write_line);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line1 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_cpu_jtag_debug_module))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_cpu_jtag_debug_module))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line1, now);
          write(write_line1, string'(": "));
          write(write_line1, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line1.all);
          deallocate (write_line1);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity cpu_data_master_arbitrator is 
        port (
              -- inputs:
                 signal DM9000A_avalonS_irq_from_sa : IN STD_LOGIC;
                 signal DM9000A_avalonS_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal DM9000A_avalonS_wait_counter_eq_0 : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_byteenable_audio_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_byteenable_raster_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_byteenable_sram_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_debugaccess : IN STD_LOGIC;
                 signal cpu_data_master_granted_DM9000A_avalonS : IN STD_LOGIC;
                 signal cpu_data_master_granted_audio_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_granted_ps2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_granted_raster_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_DM9000A_avalonS : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_audio_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_ps2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_raster_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_DM9000A_avalonS : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_audio_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_ps2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_raster_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_requests_DM9000A_avalonS : IN STD_LOGIC;
                 signal cpu_data_master_requests_audio_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                 signal cpu_data_master_requests_ps2_s1 : IN STD_LOGIC;
                 signal cpu_data_master_requests_raster_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_DM9000A_avalonS_end_xfer : IN STD_LOGIC;
                 signal d1_audio_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                 signal d1_ps2_s1_end_xfer : IN STD_LOGIC;
                 signal d1_raster_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                 signal ps2_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal raster_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                 signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_data_master_waitrequest : OUT STD_LOGIC
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of cpu_data_master_arbitrator : entity is FALSE;
end entity cpu_data_master_arbitrator;


architecture europa of cpu_data_master_arbitrator is
                signal cpu_data_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_run :  STD_LOGIC;
                signal dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal internal_cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal internal_cpu_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal internal_cpu_data_master_waitrequest :  STD_LOGIC;
                signal last_dbs_term_and_run :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal p1_registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;
                signal registered_cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((((((((((((((((((std_logic_vector'("00000000000000000000000000000001") AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_DM9000A_avalonS OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_DM9000A_avalonS OR NOT cpu_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_DM9000A_avalonS_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_audio_avalon_slave_0 OR (((cpu_data_master_write AND NOT(or_reduce(cpu_data_master_byteenable_audio_avalon_slave_0))) AND internal_cpu_data_master_dbs_address(1)))) OR NOT cpu_data_master_requests_audio_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_audio_avalon_slave_0 OR NOT cpu_data_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_audio_avalon_slave_0 OR NOT cpu_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_cpu_jtag_debug_module OR NOT cpu_data_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave OR NOT ((cpu_data_master_read OR cpu_data_master_write)))))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT jtag_uart_avalon_jtag_slave_waitrequest_from_sa)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_read OR cpu_data_master_write)))))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_ps2_s1 OR NOT cpu_data_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_ps2_s1 OR NOT cpu_data_master_write)))) OR ((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")));
  --cascaded wait assignment, which is an e_assign
  cpu_data_master_run <= r_0 AND r_1;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic(((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_raster_avalon_slave_0 OR (((cpu_data_master_write AND NOT(or_reduce(cpu_data_master_byteenable_raster_avalon_slave_0))) AND internal_cpu_data_master_dbs_address(1)))) OR NOT cpu_data_master_requests_raster_avalon_slave_0))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_raster_avalon_slave_0 OR NOT cpu_data_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_raster_avalon_slave_0 OR NOT cpu_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((cpu_data_master_qualified_request_sram_avalon_slave_0 OR (((cpu_data_master_write AND NOT(or_reduce(cpu_data_master_byteenable_sram_avalon_slave_0))) AND internal_cpu_data_master_dbs_address(1)))) OR NOT cpu_data_master_requests_sram_avalon_slave_0)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_granted_sram_avalon_slave_0 OR NOT cpu_data_master_qualified_request_sram_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_data_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_read)))))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_data_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_data_master_write)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_write)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_data_master_address_to_slave <= cpu_data_master_address(20 DOWNTO 0);
  --cpu/data_master readdata mux, which is an e_mux
  cpu_data_master_readdata <= ((((((A_REP(NOT cpu_data_master_requests_DM9000A_avalonS, 32) OR (std_logic_vector'("0000000000000000") & (DM9000A_avalonS_readdata_from_sa)))) AND ((A_REP(NOT cpu_data_master_requests_cpu_jtag_debug_module, 32) OR cpu_jtag_debug_module_readdata_from_sa))) AND ((A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR registered_cpu_data_master_readdata))) AND ((A_REP(NOT cpu_data_master_requests_ps2_s1, 32) OR (std_logic_vector'("000000000000000000000000") & (ps2_s1_readdata_from_sa))))) AND ((A_REP(NOT cpu_data_master_requests_raster_avalon_slave_0, 32) OR Std_Logic_Vector'(raster_avalon_slave_0_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)))) AND ((A_REP(NOT cpu_data_master_requests_sram_avalon_slave_0, 32) OR Std_Logic_Vector'(sram_avalon_slave_0_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)));
  --actual waitrequest port, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT std_logic_vector'("00000000000000000000000000000000"));
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        internal_cpu_data_master_waitrequest <= Vector_To_Std_Logic(NOT (A_WE_StdLogicVector((std_logic'((NOT ((cpu_data_master_read OR cpu_data_master_write)))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_data_master_run AND internal_cpu_data_master_waitrequest))))))));
      end if;
    end if;

  end process;

  --irq assign, which is an e_assign
  cpu_data_master_irq <= Std_Logic_Vector'(A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(std_logic'('0')) & A_ToStdLogicVector(DM9000A_avalonS_irq_from_sa) & A_ToStdLogicVector(jtag_uart_avalon_jtag_slave_irq_from_sa));
  --no_byte_enables_and_last_term, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_no_byte_enables_and_last_term <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        internal_cpu_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
      end if;
    end if;

  end process;

  --compute the last dbs term, which is an e_mux
  last_dbs_term_and_run <= A_WE_StdLogic((std_logic'((cpu_data_master_requests_audio_avalon_slave_0)) = '1'), (((to_std_logic(((internal_cpu_data_master_dbs_address = std_logic_vector'("10")))) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_audio_avalon_slave_0)))), A_WE_StdLogic((std_logic'((cpu_data_master_requests_raster_avalon_slave_0)) = '1'), (((to_std_logic(((internal_cpu_data_master_dbs_address = std_logic_vector'("10")))) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_raster_avalon_slave_0)))), (((to_std_logic(((internal_cpu_data_master_dbs_address = std_logic_vector'("10")))) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_sram_avalon_slave_0))))));
  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic((((((((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((((NOT internal_cpu_data_master_no_byte_enables_and_last_term) AND cpu_data_master_requests_audio_avalon_slave_0) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_audio_avalon_slave_0))))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_data_master_granted_audio_avalon_slave_0 AND cpu_data_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_audio_avalon_slave_0_end_xfer)))))) OR ((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_data_master_granted_audio_avalon_slave_0 AND cpu_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((((NOT internal_cpu_data_master_no_byte_enables_and_last_term) AND cpu_data_master_requests_raster_avalon_slave_0) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_raster_avalon_slave_0)))))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_data_master_granted_raster_avalon_slave_0 AND cpu_data_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_raster_avalon_slave_0_end_xfer)))))) OR ((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_data_master_granted_raster_avalon_slave_0 AND cpu_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((((((NOT internal_cpu_data_master_no_byte_enables_and_last_term) AND cpu_data_master_requests_sram_avalon_slave_0) AND cpu_data_master_write) AND NOT(or_reduce(cpu_data_master_byteenable_sram_avalon_slave_0)))))))) OR (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_data_master_granted_sram_avalon_slave_0 AND cpu_data_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sram_avalon_slave_0_end_xfer)))))) OR ((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_data_master_granted_sram_avalon_slave_0 AND cpu_data_master_write)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")))));
  --mux write dbs 1, which is an e_mux
  cpu_data_master_dbs_write_16 <= A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_dbs_address(1))) = '1'), cpu_data_master_writedata(31 DOWNTO 16), A_WE_StdLogicVector((std_logic'((NOT (internal_cpu_data_master_dbs_address(1)))) = '1'), cpu_data_master_writedata(15 DOWNTO 0), A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_dbs_address(1))) = '1'), cpu_data_master_writedata(31 DOWNTO 16), A_WE_StdLogicVector((std_logic'((NOT (internal_cpu_data_master_dbs_address(1)))) = '1'), cpu_data_master_writedata(15 DOWNTO 0), A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_dbs_address(1))) = '1'), cpu_data_master_writedata(31 DOWNTO 16), cpu_data_master_writedata(15 DOWNTO 0))))));
  --dbs count increment, which is an e_mux
  cpu_data_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_data_master_requests_audio_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((cpu_data_master_requests_raster_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((cpu_data_master_requests_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")))), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_data_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_data_master_dbs_address)) + (std_logic_vector'("0") & (cpu_data_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= ((pre_dbs_count_enable AND (NOT (((cpu_data_master_requests_audio_avalon_slave_0 AND NOT internal_cpu_data_master_waitrequest) AND cpu_data_master_write)))) AND (NOT (((cpu_data_master_requests_raster_avalon_slave_0 AND NOT internal_cpu_data_master_waitrequest) AND cpu_data_master_write)))) AND (NOT (((cpu_data_master_requests_sram_avalon_slave_0 AND NOT internal_cpu_data_master_waitrequest) AND cpu_data_master_write)));
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_data_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_data_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --unpredictable registered wait state incoming data, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      registered_cpu_data_master_readdata <= std_logic_vector'("00000000000000000000000000000000");
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        registered_cpu_data_master_readdata <= p1_registered_cpu_data_master_readdata;
      end if;
    end if;

  end process;

  --registered readdata mux, which is an e_mux
  p1_registered_cpu_data_master_readdata <= A_REP(NOT cpu_data_master_requests_jtag_uart_avalon_jtag_slave, 32) OR jtag_uart_avalon_jtag_slave_readdata_from_sa;
  --input to dbs-16 stored 0, which is an e_mux
  p1_dbs_16_reg_segment_0 <= A_WE_StdLogicVector((std_logic'((cpu_data_master_requests_raster_avalon_slave_0)) = '1'), raster_avalon_slave_0_readdata_from_sa, sram_avalon_slave_0_readdata_from_sa);
  --dbs register for dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_data_master_dbs_address(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
      end if;
    end if;

  end process;

  --vhdl renameroo for output signals
  cpu_data_master_address_to_slave <= internal_cpu_data_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_data_master_dbs_address <= internal_cpu_data_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_data_master_no_byte_enables_and_last_term <= internal_cpu_data_master_no_byte_enables_and_last_term;
  --vhdl renameroo for output signals
  cpu_data_master_waitrequest <= internal_cpu_data_master_waitrequest;

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity cpu_instruction_master_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                 signal cpu_instruction_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                 signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                 signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of cpu_instruction_master_arbitrator : entity is FALSE;
end entity cpu_instruction_master_arbitrator;


architecture europa of cpu_instruction_master_arbitrator is
                signal active_and_waiting_last_time :  STD_LOGIC;
                signal cpu_instruction_master_address_last_time :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_instruction_master_dbs_increment :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_instruction_master_read_last_time :  STD_LOGIC;
                signal cpu_instruction_master_run :  STD_LOGIC;
                signal dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal dbs_count_enable :  STD_LOGIC;
                signal dbs_counter_overflow :  STD_LOGIC;
                signal internal_cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal internal_cpu_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal next_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal p1_dbs_16_reg_segment_0 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal pre_dbs_count_enable :  STD_LOGIC;
                signal r_0 :  STD_LOGIC;
                signal r_1 :  STD_LOGIC;

begin

  --r_0 master_run cascaded wait assignment, which is an e_assign
  r_0 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_requests_cpu_jtag_debug_module)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_cpu_jtag_debug_module OR NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_cpu_jtag_debug_module OR NOT cpu_instruction_master_read)))) OR (((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_cpu_jtag_debug_module_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))));
  --cascaded wait assignment, which is an e_assign
  cpu_instruction_master_run <= r_0 AND r_1;
  --r_1 master_run cascaded wait assignment, which is an e_assign
  r_1 <= Vector_To_Std_Logic((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_instruction_master_requests_sram_avalon_slave_0)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(((cpu_instruction_master_granted_sram_avalon_slave_0 OR NOT cpu_instruction_master_qualified_request_sram_avalon_slave_0)))))) AND (((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((NOT cpu_instruction_master_qualified_request_sram_avalon_slave_0 OR NOT cpu_instruction_master_read)))) OR ((((std_logic_vector'("00000000000000000000000000000001") AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sram_avalon_slave_0_end_xfer)))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_instruction_master_dbs_address(1)))))) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_read)))))))));
  --optimize select-logic by passing only those address bits which matter.
  internal_cpu_instruction_master_address_to_slave <= cpu_instruction_master_address(20 DOWNTO 0);
  --cpu/instruction_master readdata mux, which is an e_mux
  cpu_instruction_master_readdata <= ((A_REP(NOT cpu_instruction_master_requests_cpu_jtag_debug_module, 32) OR cpu_jtag_debug_module_readdata_from_sa)) AND ((A_REP(NOT cpu_instruction_master_requests_sram_avalon_slave_0, 32) OR Std_Logic_Vector'(sram_avalon_slave_0_readdata_from_sa(15 DOWNTO 0) & dbs_16_reg_segment_0)));
  --actual waitrequest port, which is an e_assign
  internal_cpu_instruction_master_waitrequest <= NOT cpu_instruction_master_run;
  --input to dbs-16 stored 0, which is an e_mux
  p1_dbs_16_reg_segment_0 <= sram_avalon_slave_0_readdata_from_sa;
  --dbs register for dbs-16 segment 0, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      dbs_16_reg_segment_0 <= std_logic_vector'("0000000000000000");
    elsif clk'event and clk = '1' then
      if std_logic'((dbs_count_enable AND to_std_logic((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((internal_cpu_instruction_master_dbs_address(1))))) = std_logic_vector'("00000000000000000000000000000000")))))) = '1' then 
        dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
      end if;
    end if;

  end process;

  --dbs count increment, which is an e_mux
  cpu_instruction_master_dbs_increment <= A_EXT (A_WE_StdLogicVector((std_logic'((cpu_instruction_master_requests_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000000")), 2);
  --dbs counter overflow, which is an e_assign
  dbs_counter_overflow <= internal_cpu_instruction_master_dbs_address(1) AND NOT((next_dbs_address(1)));
  --next master address, which is an e_assign
  next_dbs_address <= A_EXT (((std_logic_vector'("0") & (internal_cpu_instruction_master_dbs_address)) + (std_logic_vector'("0") & (cpu_instruction_master_dbs_increment))), 2);
  --dbs count enable, which is an e_mux
  dbs_count_enable <= pre_dbs_count_enable;
  --dbs counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      internal_cpu_instruction_master_dbs_address <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(dbs_count_enable) = '1' then 
        internal_cpu_instruction_master_dbs_address <= next_dbs_address;
      end if;
    end if;

  end process;

  --pre dbs count enable, which is an e_mux
  pre_dbs_count_enable <= Vector_To_Std_Logic(((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR((cpu_instruction_master_granted_sram_avalon_slave_0 AND cpu_instruction_master_read)))) AND std_logic_vector'("00000000000000000000000000000001")) AND std_logic_vector'("00000000000000000000000000000001")) AND (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT d1_sram_avalon_slave_0_end_xfer)))));
  --vhdl renameroo for output signals
  cpu_instruction_master_address_to_slave <= internal_cpu_instruction_master_address_to_slave;
  --vhdl renameroo for output signals
  cpu_instruction_master_dbs_address <= internal_cpu_instruction_master_dbs_address;
  --vhdl renameroo for output signals
  cpu_instruction_master_waitrequest <= internal_cpu_instruction_master_waitrequest;
--synthesis translate_off
    --cpu_instruction_master_address check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_address_last_time <= std_logic_vector'("000000000000000000000");
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          cpu_instruction_master_address_last_time <= cpu_instruction_master_address;
        end if;
      end if;

    end process;

    --cpu/instruction_master waited last time, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        active_and_waiting_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          active_and_waiting_last_time <= internal_cpu_instruction_master_waitrequest AND (cpu_instruction_master_read);
        end if;
      end if;

    end process;

    --cpu_instruction_master_address matches last port_name, which is an e_process
    process (active_and_waiting_last_time, cpu_instruction_master_address, cpu_instruction_master_address_last_time)
    VARIABLE write_line2 : line;
    begin
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((cpu_instruction_master_address /= cpu_instruction_master_address_last_time))))) = '1' then 
          write(write_line2, now);
          write(write_line2, string'(": "));
          write(write_line2, string'("cpu_instruction_master_address did not heed wait!!!"));
          write(output, write_line2.all);
          deallocate (write_line2);
          assert false report "VHDL STOP" severity failure;
        end if;

    end process;

    --cpu_instruction_master_read check against wait, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        cpu_instruction_master_read_last_time <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          cpu_instruction_master_read_last_time <= cpu_instruction_master_read;
        end if;
      end if;

    end process;

    --cpu_instruction_master_read matches last port_name, which is an e_process
    process (active_and_waiting_last_time, cpu_instruction_master_read, cpu_instruction_master_read_last_time)
    VARIABLE write_line3 : line;
    begin
        if std_logic'((active_and_waiting_last_time AND to_std_logic(((std_logic'(cpu_instruction_master_read) /= std_logic'(cpu_instruction_master_read_last_time)))))) = '1' then 
          write(write_line3, now);
          write(write_line3, string'(": "));
          write(write_line3, string'("cpu_instruction_master_read did not heed wait!!!"));
          write(output, write_line3.all);
          deallocate (write_line3);
          assert false report "VHDL STOP" severity failure;
        end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity jtag_uart_avalon_jtag_slave_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                 signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                 signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                 signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of jtag_uart_avalon_jtag_slave_arbitrator : entity is FALSE;
end entity jtag_uart_avalon_jtag_slave_arbitrator;


architecture europa of jtag_uart_avalon_jtag_slave_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allgrants :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_allow_new_arb_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_any_continuerequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_counter_enable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_beginbursttransfer_internal :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_begins_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_grant_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_read_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_in_a_write_cycle :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_master_qreq_vector :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_non_bursting_master_requests :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_unreg_firsttransfer :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_read :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_jtag_uart_avalon_jtag_slave_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT jtag_uart_avalon_jtag_slave_end_xfer;
      end if;
    end if;

  end process;

  jtag_uart_avalon_jtag_slave_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave);
  --assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readdata_from_sa <= jtag_uart_avalon_jtag_slave_readdata;
  internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(20 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("100000001001000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_dataavailable_from_sa <= jtag_uart_avalon_jtag_slave_dataavailable;
  --assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_readyfordata_from_sa <= jtag_uart_avalon_jtag_slave_readyfordata;
  --assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= jtag_uart_avalon_jtag_slave_waitrequest;
  --jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  jtag_uart_avalon_jtag_slave_arb_share_set_values <= std_logic_vector'("01");
  --jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_non_bursting_master_requests <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant <= std_logic'('0');
  --jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(jtag_uart_avalon_jtag_slave_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_avalon_jtag_slave_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(jtag_uart_avalon_jtag_slave_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (jtag_uart_avalon_jtag_slave_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  jtag_uart_avalon_jtag_slave_allgrants <= jtag_uart_avalon_jtag_slave_grant_vector;
  --jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_end_xfer <= NOT ((jtag_uart_avalon_jtag_slave_waits_for_read OR jtag_uart_avalon_jtag_slave_waits_for_write));
  --end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave <= jtag_uart_avalon_jtag_slave_end_xfer AND (((NOT jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  jtag_uart_avalon_jtag_slave_arb_counter_enable <= ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND jtag_uart_avalon_jtag_slave_allgrants)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests));
  --jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_arb_counter_enable) = '1' then 
        jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((jtag_uart_avalon_jtag_slave_master_qreq_vector AND end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave)) OR ((end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave AND NOT jtag_uart_avalon_jtag_slave_non_bursting_master_requests)))) = '1' then 
        jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= or_reduce(jtag_uart_avalon_jtag_slave_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 <= or_reduce(jtag_uart_avalon_jtag_slave_arb_share_counter_next_value);
  --cpu/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  jtag_uart_avalon_jtag_slave_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave AND NOT ((((cpu_data_master_read AND (NOT cpu_data_master_waitrequest))) OR (((NOT cpu_data_master_waitrequest) AND cpu_data_master_write))));
  --jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_writedata <= cpu_data_master_writedata;
  --master is always granted when requested
  internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --cpu/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  cpu_data_master_saved_grant_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  jtag_uart_avalon_jtag_slave_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  jtag_uart_avalon_jtag_slave_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  jtag_uart_avalon_jtag_slave_master_qreq_vector <= std_logic'('1');
  --jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_reset_n <= reset_n;
  jtag_uart_avalon_jtag_slave_chipselect <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_firsttransfer <= A_WE_StdLogic((std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1'), jtag_uart_avalon_jtag_slave_unreg_firsttransfer, jtag_uart_avalon_jtag_slave_reg_firsttransfer);
  --jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  jtag_uart_avalon_jtag_slave_unreg_firsttransfer <= NOT ((jtag_uart_avalon_jtag_slave_slavearbiterlockenable AND jtag_uart_avalon_jtag_slave_any_continuerequest));
  --jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      jtag_uart_avalon_jtag_slave_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(jtag_uart_avalon_jtag_slave_begins_xfer) = '1' then 
        jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  jtag_uart_avalon_jtag_slave_beginbursttransfer_internal <= jtag_uart_avalon_jtag_slave_begins_xfer;
  --~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_read_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read));
  --~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  jtag_uart_avalon_jtag_slave_write_n <= NOT ((internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write));
  shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  jtag_uart_avalon_jtag_slave_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_jtag_uart_avalon_jtag_slave_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_jtag_uart_avalon_jtag_slave_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
      end if;
    end if;

  end process;

  --jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_read <= jtag_uart_avalon_jtag_slave_in_a_read_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_read_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  --jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  jtag_uart_avalon_jtag_slave_waits_for_write <= jtag_uart_avalon_jtag_slave_in_a_write_cycle AND internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  --jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  jtag_uart_avalon_jtag_slave_in_a_write_cycle <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wait_for_jtag_uart_avalon_jtag_slave_counter <= std_logic'('0');
  --assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  jtag_uart_avalon_jtag_slave_irq_from_sa <= jtag_uart_avalon_jtag_slave_irq;
  --vhdl renameroo for output signals
  cpu_data_master_granted_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_granted_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  cpu_data_master_requests_jtag_uart_avalon_jtag_slave <= internal_cpu_data_master_requests_jtag_uart_avalon_jtag_slave;
  --vhdl renameroo for output signals
  jtag_uart_avalon_jtag_slave_waitrequest_from_sa <= internal_jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
--synthesis translate_off
    --jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ps2_s1_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal ps2_s1_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_granted_ps2_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_ps2_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_ps2_s1 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_ps2_s1 : OUT STD_LOGIC;
                 signal d1_ps2_s1_end_xfer : OUT STD_LOGIC;
                 signal ps2_s1_address : OUT STD_LOGIC;
                 signal ps2_s1_chipselect : OUT STD_LOGIC;
                 signal ps2_s1_read : OUT STD_LOGIC;
                 signal ps2_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal ps2_s1_reset : OUT STD_LOGIC
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of ps2_s1_arbitrator : entity is FALSE;
end entity ps2_s1_arbitrator;


architecture europa of ps2_s1_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_ps2_s1 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_ps2_s1 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_granted_ps2_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_ps2_s1 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_ps2_s1 :  STD_LOGIC;
                signal ps2_s1_allgrants :  STD_LOGIC;
                signal ps2_s1_allow_new_arb_cycle :  STD_LOGIC;
                signal ps2_s1_any_bursting_master_saved_grant :  STD_LOGIC;
                signal ps2_s1_any_continuerequest :  STD_LOGIC;
                signal ps2_s1_arb_counter_enable :  STD_LOGIC;
                signal ps2_s1_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ps2_s1_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ps2_s1_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal ps2_s1_beginbursttransfer_internal :  STD_LOGIC;
                signal ps2_s1_begins_xfer :  STD_LOGIC;
                signal ps2_s1_end_xfer :  STD_LOGIC;
                signal ps2_s1_firsttransfer :  STD_LOGIC;
                signal ps2_s1_grant_vector :  STD_LOGIC;
                signal ps2_s1_in_a_read_cycle :  STD_LOGIC;
                signal ps2_s1_in_a_write_cycle :  STD_LOGIC;
                signal ps2_s1_master_qreq_vector :  STD_LOGIC;
                signal ps2_s1_non_bursting_master_requests :  STD_LOGIC;
                signal ps2_s1_reg_firsttransfer :  STD_LOGIC;
                signal ps2_s1_slavearbiterlockenable :  STD_LOGIC;
                signal ps2_s1_slavearbiterlockenable2 :  STD_LOGIC;
                signal ps2_s1_unreg_firsttransfer :  STD_LOGIC;
                signal ps2_s1_waits_for_read :  STD_LOGIC;
                signal ps2_s1_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_ps2_s1_from_cpu_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_ps2_s1_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT ps2_s1_end_xfer;
      end if;
    end if;

  end process;

  ps2_s1_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_ps2_s1);
  --assign ps2_s1_readdata_from_sa = ps2_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  ps2_s1_readdata_from_sa <= ps2_s1_readdata;
  internal_cpu_data_master_requests_ps2_s1 <= ((to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(20 DOWNTO 3) & std_logic_vector'("000")) = std_logic_vector'("100000001001000001000")))) AND ((cpu_data_master_read OR cpu_data_master_write)))) AND cpu_data_master_read;
  --ps2_s1_arb_share_counter set values, which is an e_mux
  ps2_s1_arb_share_set_values <= std_logic_vector'("01");
  --ps2_s1_non_bursting_master_requests mux, which is an e_mux
  ps2_s1_non_bursting_master_requests <= internal_cpu_data_master_requests_ps2_s1;
  --ps2_s1_any_bursting_master_saved_grant mux, which is an e_mux
  ps2_s1_any_bursting_master_saved_grant <= std_logic'('0');
  --ps2_s1_arb_share_counter_next_value assignment, which is an e_assign
  ps2_s1_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(ps2_s1_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (ps2_s1_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(ps2_s1_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (ps2_s1_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --ps2_s1_allgrants all slave grants, which is an e_mux
  ps2_s1_allgrants <= ps2_s1_grant_vector;
  --ps2_s1_end_xfer assignment, which is an e_assign
  ps2_s1_end_xfer <= NOT ((ps2_s1_waits_for_read OR ps2_s1_waits_for_write));
  --end_xfer_arb_share_counter_term_ps2_s1 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_ps2_s1 <= ps2_s1_end_xfer AND (((NOT ps2_s1_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --ps2_s1_arb_share_counter arbitration counter enable, which is an e_assign
  ps2_s1_arb_counter_enable <= ((end_xfer_arb_share_counter_term_ps2_s1 AND ps2_s1_allgrants)) OR ((end_xfer_arb_share_counter_term_ps2_s1 AND NOT ps2_s1_non_bursting_master_requests));
  --ps2_s1_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ps2_s1_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(ps2_s1_arb_counter_enable) = '1' then 
        ps2_s1_arb_share_counter <= ps2_s1_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --ps2_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ps2_s1_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((ps2_s1_master_qreq_vector AND end_xfer_arb_share_counter_term_ps2_s1)) OR ((end_xfer_arb_share_counter_term_ps2_s1 AND NOT ps2_s1_non_bursting_master_requests)))) = '1' then 
        ps2_s1_slavearbiterlockenable <= or_reduce(ps2_s1_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master ps2/s1 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= ps2_s1_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --ps2_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  ps2_s1_slavearbiterlockenable2 <= or_reduce(ps2_s1_arb_share_counter_next_value);
  --cpu/data_master ps2/s1 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= ps2_s1_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --ps2_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  ps2_s1_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_ps2_s1 <= internal_cpu_data_master_requests_ps2_s1;
  --master is always granted when requested
  internal_cpu_data_master_granted_ps2_s1 <= internal_cpu_data_master_qualified_request_ps2_s1;
  --cpu/data_master saved-grant ps2/s1, which is an e_assign
  cpu_data_master_saved_grant_ps2_s1 <= internal_cpu_data_master_requests_ps2_s1;
  --allow new arb cycle for ps2/s1, which is an e_assign
  ps2_s1_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  ps2_s1_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  ps2_s1_master_qreq_vector <= std_logic'('1');
  --~ps2_s1_reset assignment, which is an e_assign
  ps2_s1_reset <= NOT reset_n;
  ps2_s1_chipselect <= internal_cpu_data_master_granted_ps2_s1;
  --ps2_s1_firsttransfer first transaction, which is an e_assign
  ps2_s1_firsttransfer <= A_WE_StdLogic((std_logic'(ps2_s1_begins_xfer) = '1'), ps2_s1_unreg_firsttransfer, ps2_s1_reg_firsttransfer);
  --ps2_s1_unreg_firsttransfer first transaction, which is an e_assign
  ps2_s1_unreg_firsttransfer <= NOT ((ps2_s1_slavearbiterlockenable AND ps2_s1_any_continuerequest));
  --ps2_s1_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      ps2_s1_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(ps2_s1_begins_xfer) = '1' then 
        ps2_s1_reg_firsttransfer <= ps2_s1_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --ps2_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  ps2_s1_beginbursttransfer_internal <= ps2_s1_begins_xfer;
  --ps2_s1_read assignment, which is an e_mux
  ps2_s1_read <= internal_cpu_data_master_granted_ps2_s1 AND cpu_data_master_read;
  shifted_address_to_ps2_s1_from_cpu_data_master <= cpu_data_master_address_to_slave;
  --ps2_s1_address mux, which is an e_mux
  ps2_s1_address <= Vector_To_Std_Logic(A_SRL(shifted_address_to_ps2_s1_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000010")));
  --d1_ps2_s1_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_ps2_s1_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_ps2_s1_end_xfer <= ps2_s1_end_xfer;
      end if;
    end if;

  end process;

  --ps2_s1_waits_for_read in a cycle, which is an e_mux
  ps2_s1_waits_for_read <= ps2_s1_in_a_read_cycle AND ps2_s1_begins_xfer;
  --ps2_s1_in_a_read_cycle assignment, which is an e_assign
  ps2_s1_in_a_read_cycle <= internal_cpu_data_master_granted_ps2_s1 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= ps2_s1_in_a_read_cycle;
  --ps2_s1_waits_for_write in a cycle, which is an e_mux
  ps2_s1_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(ps2_s1_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --ps2_s1_in_a_write_cycle assignment, which is an e_assign
  ps2_s1_in_a_write_cycle <= internal_cpu_data_master_granted_ps2_s1 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= ps2_s1_in_a_write_cycle;
  wait_for_ps2_s1_counter <= std_logic'('0');
  --vhdl renameroo for output signals
  cpu_data_master_granted_ps2_s1 <= internal_cpu_data_master_granted_ps2_s1;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_ps2_s1 <= internal_cpu_data_master_qualified_request_ps2_s1;
  --vhdl renameroo for output signals
  cpu_data_master_requests_ps2_s1 <= internal_cpu_data_master_requests_ps2_s1;
--synthesis translate_off
    --ps2/s1 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity raster_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal raster_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal cpu_data_master_byteenable_raster_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_granted_raster_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_raster_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_raster_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_raster_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_raster_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal raster_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                 signal raster_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal raster_avalon_slave_0_read : OUT STD_LOGIC;
                 signal raster_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal raster_avalon_slave_0_reset : OUT STD_LOGIC;
                 signal raster_avalon_slave_0_write : OUT STD_LOGIC;
                 signal raster_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of raster_avalon_slave_0_arbitrator : entity is FALSE;
end entity raster_avalon_slave_0_arbitrator;


architecture europa of raster_avalon_slave_0_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_byteenable_raster_avalon_slave_0_segment_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_byteenable_raster_avalon_slave_0_segment_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_raster_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_raster_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_byteenable_raster_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_data_master_granted_raster_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_raster_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_raster_avalon_slave_0 :  STD_LOGIC;
                signal raster_avalon_slave_0_allgrants :  STD_LOGIC;
                signal raster_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal raster_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal raster_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal raster_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal raster_avalon_slave_0_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal raster_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal raster_avalon_slave_0_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal raster_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal raster_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal raster_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal raster_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal raster_avalon_slave_0_grant_vector :  STD_LOGIC;
                signal raster_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal raster_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal raster_avalon_slave_0_master_qreq_vector :  STD_LOGIC;
                signal raster_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal raster_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal raster_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal raster_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal raster_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal raster_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal raster_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal shifted_address_to_raster_avalon_slave_0_from_cpu_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal wait_for_raster_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT raster_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  raster_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND (internal_cpu_data_master_qualified_request_raster_avalon_slave_0);
  --assign raster_avalon_slave_0_readdata_from_sa = raster_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  raster_avalon_slave_0_readdata_from_sa <= raster_avalon_slave_0_readdata;
  internal_cpu_data_master_requests_raster_avalon_slave_0 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(20 DOWNTO 9) & std_logic_vector'("000000000")) = std_logic_vector'("100000001000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --raster_avalon_slave_0_arb_share_counter set values, which is an e_mux
  raster_avalon_slave_0_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_raster_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001")), 2);
  --raster_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  raster_avalon_slave_0_non_bursting_master_requests <= internal_cpu_data_master_requests_raster_avalon_slave_0;
  --raster_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  raster_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --raster_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  raster_avalon_slave_0_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(raster_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (raster_avalon_slave_0_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(raster_avalon_slave_0_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (raster_avalon_slave_0_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --raster_avalon_slave_0_allgrants all slave grants, which is an e_mux
  raster_avalon_slave_0_allgrants <= raster_avalon_slave_0_grant_vector;
  --raster_avalon_slave_0_end_xfer assignment, which is an e_assign
  raster_avalon_slave_0_end_xfer <= NOT ((raster_avalon_slave_0_waits_for_read OR raster_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_raster_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_raster_avalon_slave_0 <= raster_avalon_slave_0_end_xfer AND (((NOT raster_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --raster_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  raster_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_raster_avalon_slave_0 AND raster_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_raster_avalon_slave_0 AND NOT raster_avalon_slave_0_non_bursting_master_requests));
  --raster_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      raster_avalon_slave_0_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(raster_avalon_slave_0_arb_counter_enable) = '1' then 
        raster_avalon_slave_0_arb_share_counter <= raster_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --raster_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      raster_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((raster_avalon_slave_0_master_qreq_vector AND end_xfer_arb_share_counter_term_raster_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_raster_avalon_slave_0 AND NOT raster_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        raster_avalon_slave_0_slavearbiterlockenable <= or_reduce(raster_avalon_slave_0_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master raster/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= raster_avalon_slave_0_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --raster_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  raster_avalon_slave_0_slavearbiterlockenable2 <= or_reduce(raster_avalon_slave_0_arb_share_counter_next_value);
  --cpu/data_master raster/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= raster_avalon_slave_0_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --raster_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_assign
  raster_avalon_slave_0_any_continuerequest <= std_logic'('1');
  --cpu_data_master_continuerequest continued request, which is an e_assign
  cpu_data_master_continuerequest <= std_logic'('1');
  internal_cpu_data_master_qualified_request_raster_avalon_slave_0 <= internal_cpu_data_master_requests_raster_avalon_slave_0 AND NOT (((((NOT cpu_data_master_waitrequest OR cpu_data_master_no_byte_enables_and_last_term) OR NOT(or_reduce(internal_cpu_data_master_byteenable_raster_avalon_slave_0)))) AND cpu_data_master_write));
  --raster_avalon_slave_0_writedata mux, which is an e_mux
  raster_avalon_slave_0_writedata <= cpu_data_master_dbs_write_16;
  --master is always granted when requested
  internal_cpu_data_master_granted_raster_avalon_slave_0 <= internal_cpu_data_master_qualified_request_raster_avalon_slave_0;
  --cpu/data_master saved-grant raster/avalon_slave_0, which is an e_assign
  cpu_data_master_saved_grant_raster_avalon_slave_0 <= internal_cpu_data_master_requests_raster_avalon_slave_0;
  --allow new arb cycle for raster/avalon_slave_0, which is an e_assign
  raster_avalon_slave_0_allow_new_arb_cycle <= std_logic'('1');
  --placeholder chosen master
  raster_avalon_slave_0_grant_vector <= std_logic'('1');
  --placeholder vector of master qualified-requests
  raster_avalon_slave_0_master_qreq_vector <= std_logic'('1');
  --~raster_avalon_slave_0_reset assignment, which is an e_assign
  raster_avalon_slave_0_reset <= NOT reset_n;
  raster_avalon_slave_0_chipselect <= internal_cpu_data_master_granted_raster_avalon_slave_0;
  --raster_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  raster_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(raster_avalon_slave_0_begins_xfer) = '1'), raster_avalon_slave_0_unreg_firsttransfer, raster_avalon_slave_0_reg_firsttransfer);
  --raster_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  raster_avalon_slave_0_unreg_firsttransfer <= NOT ((raster_avalon_slave_0_slavearbiterlockenable AND raster_avalon_slave_0_any_continuerequest));
  --raster_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      raster_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(raster_avalon_slave_0_begins_xfer) = '1' then 
        raster_avalon_slave_0_reg_firsttransfer <= raster_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --raster_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  raster_avalon_slave_0_beginbursttransfer_internal <= raster_avalon_slave_0_begins_xfer;
  --raster_avalon_slave_0_read assignment, which is an e_mux
  raster_avalon_slave_0_read <= internal_cpu_data_master_granted_raster_avalon_slave_0 AND cpu_data_master_read;
  --raster_avalon_slave_0_write assignment, which is an e_mux
  raster_avalon_slave_0_write <= internal_cpu_data_master_granted_raster_avalon_slave_0 AND cpu_data_master_write;
  shifted_address_to_raster_avalon_slave_0_from_cpu_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 21);
  --raster_avalon_slave_0_address mux, which is an e_mux
  raster_avalon_slave_0_address <= A_EXT (A_SRL(shifted_address_to_raster_avalon_slave_0_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000001")), 8);
  --d1_raster_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_raster_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_raster_avalon_slave_0_end_xfer <= raster_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  --raster_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  raster_avalon_slave_0_waits_for_read <= raster_avalon_slave_0_in_a_read_cycle AND raster_avalon_slave_0_begins_xfer;
  --raster_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  raster_avalon_slave_0_in_a_read_cycle <= internal_cpu_data_master_granted_raster_avalon_slave_0 AND cpu_data_master_read;
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= raster_avalon_slave_0_in_a_read_cycle;
  --raster_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  raster_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(raster_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --raster_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  raster_avalon_slave_0_in_a_write_cycle <= internal_cpu_data_master_granted_raster_avalon_slave_0 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= raster_avalon_slave_0_in_a_write_cycle;
  wait_for_raster_avalon_slave_0_counter <= std_logic'('0');
  (cpu_data_master_byteenable_raster_avalon_slave_0_segment_1(1), cpu_data_master_byteenable_raster_avalon_slave_0_segment_1(0), cpu_data_master_byteenable_raster_avalon_slave_0_segment_0(1), cpu_data_master_byteenable_raster_avalon_slave_0_segment_0(0)) <= cpu_data_master_byteenable;
  internal_cpu_data_master_byteenable_raster_avalon_slave_0 <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_dbs_address(1)))) = std_logic_vector'("00000000000000000000000000000000"))), cpu_data_master_byteenable_raster_avalon_slave_0_segment_0, cpu_data_master_byteenable_raster_avalon_slave_0_segment_1);
  --vhdl renameroo for output signals
  cpu_data_master_byteenable_raster_avalon_slave_0 <= internal_cpu_data_master_byteenable_raster_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_granted_raster_avalon_slave_0 <= internal_cpu_data_master_granted_raster_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_raster_avalon_slave_0 <= internal_cpu_data_master_qualified_request_raster_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_requests_raster_avalon_slave_0 <= internal_cpu_data_master_requests_raster_avalon_slave_0;
--synthesis translate_off
    --raster/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library std;
use std.textio.all;

entity sram_avalon_slave_0_arbitrator is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                 signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                 signal cpu_data_master_read : IN STD_LOGIC;
                 signal cpu_data_master_waitrequest : IN STD_LOGIC;
                 signal cpu_data_master_write : IN STD_LOGIC;
                 signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                 signal cpu_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_instruction_master_read : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;
                 signal sram_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal cpu_data_master_byteenable_sram_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal cpu_data_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_data_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_instruction_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_instruction_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_instruction_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal cpu_instruction_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                 signal d1_sram_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal sram_avalon_slave_0_byteenable : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                 signal sram_avalon_slave_0_chipselect : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_read : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal sram_avalon_slave_0_write : OUT STD_LOGIC;
                 signal sram_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
              );
attribute auto_dissolve : boolean;
attribute auto_dissolve of sram_avalon_slave_0_arbitrator : entity is FALSE;
end entity sram_avalon_slave_0_arbitrator;


architecture europa of sram_avalon_slave_0_arbitrator is
                signal cpu_data_master_arbiterlock :  STD_LOGIC;
                signal cpu_data_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_data_master_byteenable_sram_avalon_slave_0_segment_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_byteenable_sram_avalon_slave_0_segment_1 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_continuerequest :  STD_LOGIC;
                signal cpu_data_master_saved_grant_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock :  STD_LOGIC;
                signal cpu_instruction_master_arbiterlock2 :  STD_LOGIC;
                signal cpu_instruction_master_continuerequest :  STD_LOGIC;
                signal cpu_instruction_master_saved_grant_sram_avalon_slave_0 :  STD_LOGIC;
                signal d1_reasons_to_wait :  STD_LOGIC;
                signal enable_nonzero_assertions :  STD_LOGIC;
                signal end_xfer_arb_share_counter_term_sram_avalon_slave_0 :  STD_LOGIC;
                signal in_a_read_cycle :  STD_LOGIC;
                signal in_a_write_cycle :  STD_LOGIC;
                signal internal_cpu_data_master_byteenable_sram_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal internal_cpu_data_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_data_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_instruction_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_instruction_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal internal_cpu_instruction_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal last_cycle_cpu_data_master_granted_slave_sram_avalon_slave_0 :  STD_LOGIC;
                signal last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave_0 :  STD_LOGIC;
                signal shifted_address_to_sram_avalon_slave_0_from_cpu_data_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal shifted_address_to_sram_avalon_slave_0_from_cpu_instruction_master :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal sram_avalon_slave_0_allgrants :  STD_LOGIC;
                signal sram_avalon_slave_0_allow_new_arb_cycle :  STD_LOGIC;
                signal sram_avalon_slave_0_any_bursting_master_saved_grant :  STD_LOGIC;
                signal sram_avalon_slave_0_any_continuerequest :  STD_LOGIC;
                signal sram_avalon_slave_0_arb_addend :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_arb_counter_enable :  STD_LOGIC;
                signal sram_avalon_slave_0_arb_share_counter :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_arb_share_counter_next_value :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_arb_share_set_values :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_arb_winner :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_arbitration_holdoff_internal :  STD_LOGIC;
                signal sram_avalon_slave_0_beginbursttransfer_internal :  STD_LOGIC;
                signal sram_avalon_slave_0_begins_xfer :  STD_LOGIC;
                signal sram_avalon_slave_0_chosen_master_double_vector :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal sram_avalon_slave_0_chosen_master_rot_left :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal sram_avalon_slave_0_firsttransfer :  STD_LOGIC;
                signal sram_avalon_slave_0_grant_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_in_a_read_cycle :  STD_LOGIC;
                signal sram_avalon_slave_0_in_a_write_cycle :  STD_LOGIC;
                signal sram_avalon_slave_0_master_qreq_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_non_bursting_master_requests :  STD_LOGIC;
                signal sram_avalon_slave_0_reg_firsttransfer :  STD_LOGIC;
                signal sram_avalon_slave_0_saved_chosen_master_vector :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_slavearbiterlockenable :  STD_LOGIC;
                signal sram_avalon_slave_0_slavearbiterlockenable2 :  STD_LOGIC;
                signal sram_avalon_slave_0_unreg_firsttransfer :  STD_LOGIC;
                signal sram_avalon_slave_0_waits_for_read :  STD_LOGIC;
                signal sram_avalon_slave_0_waits_for_write :  STD_LOGIC;
                signal wait_for_sram_avalon_slave_0_counter :  STD_LOGIC;

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_reasons_to_wait <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_reasons_to_wait <= NOT sram_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  sram_avalon_slave_0_begins_xfer <= NOT d1_reasons_to_wait AND ((internal_cpu_data_master_qualified_request_sram_avalon_slave_0 OR internal_cpu_instruction_master_qualified_request_sram_avalon_slave_0));
  --assign sram_avalon_slave_0_readdata_from_sa = sram_avalon_slave_0_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  sram_avalon_slave_0_readdata_from_sa <= sram_avalon_slave_0_readdata;
  internal_cpu_data_master_requests_sram_avalon_slave_0 <= to_std_logic(((Std_Logic_Vector'(cpu_data_master_address_to_slave(20 DOWNTO 19) & std_logic_vector'("0000000000000000000")) = std_logic_vector'("010000000000000000000")))) AND ((cpu_data_master_read OR cpu_data_master_write));
  --sram_avalon_slave_0_arb_share_counter set values, which is an e_mux
  sram_avalon_slave_0_arb_share_set_values <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_instruction_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), A_WE_StdLogicVector((std_logic'((internal_cpu_instruction_master_granted_sram_avalon_slave_0)) = '1'), std_logic_vector'("00000000000000000000000000000010"), std_logic_vector'("00000000000000000000000000000001"))))), 2);
  --sram_avalon_slave_0_non_bursting_master_requests mux, which is an e_mux
  sram_avalon_slave_0_non_bursting_master_requests <= ((internal_cpu_data_master_requests_sram_avalon_slave_0 OR internal_cpu_instruction_master_requests_sram_avalon_slave_0) OR internal_cpu_data_master_requests_sram_avalon_slave_0) OR internal_cpu_instruction_master_requests_sram_avalon_slave_0;
  --sram_avalon_slave_0_any_bursting_master_saved_grant mux, which is an e_mux
  sram_avalon_slave_0_any_bursting_master_saved_grant <= std_logic'('0');
  --sram_avalon_slave_0_arb_share_counter_next_value assignment, which is an e_assign
  sram_avalon_slave_0_arb_share_counter_next_value <= A_EXT (A_WE_StdLogicVector((std_logic'(sram_avalon_slave_0_firsttransfer) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sram_avalon_slave_0_arb_share_set_values)) - std_logic_vector'("000000000000000000000000000000001"))), A_WE_StdLogicVector((std_logic'(or_reduce(sram_avalon_slave_0_arb_share_counter)) = '1'), (((std_logic_vector'("0000000000000000000000000000000") & (sram_avalon_slave_0_arb_share_counter)) - std_logic_vector'("000000000000000000000000000000001"))), std_logic_vector'("000000000000000000000000000000000"))), 2);
  --sram_avalon_slave_0_allgrants all slave grants, which is an e_mux
  sram_avalon_slave_0_allgrants <= ((or_reduce(sram_avalon_slave_0_grant_vector) OR or_reduce(sram_avalon_slave_0_grant_vector)) OR or_reduce(sram_avalon_slave_0_grant_vector)) OR or_reduce(sram_avalon_slave_0_grant_vector);
  --sram_avalon_slave_0_end_xfer assignment, which is an e_assign
  sram_avalon_slave_0_end_xfer <= NOT ((sram_avalon_slave_0_waits_for_read OR sram_avalon_slave_0_waits_for_write));
  --end_xfer_arb_share_counter_term_sram_avalon_slave_0 arb share counter enable term, which is an e_assign
  end_xfer_arb_share_counter_term_sram_avalon_slave_0 <= sram_avalon_slave_0_end_xfer AND (((NOT sram_avalon_slave_0_any_bursting_master_saved_grant OR in_a_read_cycle) OR in_a_write_cycle));
  --sram_avalon_slave_0_arb_share_counter arbitration counter enable, which is an e_assign
  sram_avalon_slave_0_arb_counter_enable <= ((end_xfer_arb_share_counter_term_sram_avalon_slave_0 AND sram_avalon_slave_0_allgrants)) OR ((end_xfer_arb_share_counter_term_sram_avalon_slave_0 AND NOT sram_avalon_slave_0_non_bursting_master_requests));
  --sram_avalon_slave_0_arb_share_counter counter, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_arb_share_counter <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sram_avalon_slave_0_arb_counter_enable) = '1' then 
        sram_avalon_slave_0_arb_share_counter <= sram_avalon_slave_0_arb_share_counter_next_value;
      end if;
    end if;

  end process;

  --sram_avalon_slave_0_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_slavearbiterlockenable <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if std_logic'((((or_reduce(sram_avalon_slave_0_master_qreq_vector) AND end_xfer_arb_share_counter_term_sram_avalon_slave_0)) OR ((end_xfer_arb_share_counter_term_sram_avalon_slave_0 AND NOT sram_avalon_slave_0_non_bursting_master_requests)))) = '1' then 
        sram_avalon_slave_0_slavearbiterlockenable <= or_reduce(sram_avalon_slave_0_arb_share_counter_next_value);
      end if;
    end if;

  end process;

  --cpu/data_master sram/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_data_master_arbiterlock <= sram_avalon_slave_0_slavearbiterlockenable AND cpu_data_master_continuerequest;
  --sram_avalon_slave_0_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  sram_avalon_slave_0_slavearbiterlockenable2 <= or_reduce(sram_avalon_slave_0_arb_share_counter_next_value);
  --cpu/data_master sram/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_data_master_arbiterlock2 <= sram_avalon_slave_0_slavearbiterlockenable2 AND cpu_data_master_continuerequest;
  --cpu/instruction_master sram/avalon_slave_0 arbiterlock, which is an e_assign
  cpu_instruction_master_arbiterlock <= sram_avalon_slave_0_slavearbiterlockenable AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master sram/avalon_slave_0 arbiterlock2, which is an e_assign
  cpu_instruction_master_arbiterlock2 <= sram_avalon_slave_0_slavearbiterlockenable2 AND cpu_instruction_master_continuerequest;
  --cpu/instruction_master granted sram/avalon_slave_0 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_instruction_master_saved_grant_sram_avalon_slave_0) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sram_avalon_slave_0_arbitration_holdoff_internal OR NOT internal_cpu_instruction_master_requests_sram_avalon_slave_0))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave_0))))));
      end if;
    end if;

  end process;

  --cpu_instruction_master_continuerequest continued request, which is an e_mux
  cpu_instruction_master_continuerequest <= last_cycle_cpu_instruction_master_granted_slave_sram_avalon_slave_0 AND internal_cpu_instruction_master_requests_sram_avalon_slave_0;
  --sram_avalon_slave_0_any_continuerequest at least one master continues requesting, which is an e_mux
  sram_avalon_slave_0_any_continuerequest <= cpu_instruction_master_continuerequest OR cpu_data_master_continuerequest;
  internal_cpu_data_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_data_master_requests_sram_avalon_slave_0 AND NOT (((((((NOT cpu_data_master_waitrequest OR cpu_data_master_no_byte_enables_and_last_term) OR NOT(or_reduce(internal_cpu_data_master_byteenable_sram_avalon_slave_0)))) AND cpu_data_master_write)) OR cpu_instruction_master_arbiterlock));
  --sram_avalon_slave_0_writedata mux, which is an e_mux
  sram_avalon_slave_0_writedata <= cpu_data_master_dbs_write_16;
  internal_cpu_instruction_master_requests_sram_avalon_slave_0 <= ((to_std_logic(((Std_Logic_Vector'(cpu_instruction_master_address_to_slave(20 DOWNTO 19) & std_logic_vector'("0000000000000000000")) = std_logic_vector'("010000000000000000000")))) AND (cpu_instruction_master_read))) AND cpu_instruction_master_read;
  --cpu/data_master granted sram/avalon_slave_0 last time, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      last_cycle_cpu_data_master_granted_slave_sram_avalon_slave_0 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        last_cycle_cpu_data_master_granted_slave_sram_avalon_slave_0 <= Vector_To_Std_Logic(A_WE_StdLogicVector((std_logic'(cpu_data_master_saved_grant_sram_avalon_slave_0) = '1'), std_logic_vector'("00000000000000000000000000000001"), A_WE_StdLogicVector((std_logic'(((sram_avalon_slave_0_arbitration_holdoff_internal OR NOT internal_cpu_data_master_requests_sram_avalon_slave_0))) = '1'), std_logic_vector'("00000000000000000000000000000000"), (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(last_cycle_cpu_data_master_granted_slave_sram_avalon_slave_0))))));
      end if;
    end if;

  end process;

  --cpu_data_master_continuerequest continued request, which is an e_mux
  cpu_data_master_continuerequest <= last_cycle_cpu_data_master_granted_slave_sram_avalon_slave_0 AND internal_cpu_data_master_requests_sram_avalon_slave_0;
  internal_cpu_instruction_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_instruction_master_requests_sram_avalon_slave_0 AND NOT (cpu_data_master_arbiterlock);
  --allow new arb cycle for sram/avalon_slave_0, which is an e_assign
  sram_avalon_slave_0_allow_new_arb_cycle <= NOT cpu_data_master_arbiterlock AND NOT cpu_instruction_master_arbiterlock;
  --cpu/instruction_master assignment into master qualified-requests vector for sram/avalon_slave_0, which is an e_assign
  sram_avalon_slave_0_master_qreq_vector(0) <= internal_cpu_instruction_master_qualified_request_sram_avalon_slave_0;
  --cpu/instruction_master grant sram/avalon_slave_0, which is an e_assign
  internal_cpu_instruction_master_granted_sram_avalon_slave_0 <= sram_avalon_slave_0_grant_vector(0);
  --cpu/instruction_master saved-grant sram/avalon_slave_0, which is an e_assign
  cpu_instruction_master_saved_grant_sram_avalon_slave_0 <= sram_avalon_slave_0_arb_winner(0) AND internal_cpu_instruction_master_requests_sram_avalon_slave_0;
  --cpu/data_master assignment into master qualified-requests vector for sram/avalon_slave_0, which is an e_assign
  sram_avalon_slave_0_master_qreq_vector(1) <= internal_cpu_data_master_qualified_request_sram_avalon_slave_0;
  --cpu/data_master grant sram/avalon_slave_0, which is an e_assign
  internal_cpu_data_master_granted_sram_avalon_slave_0 <= sram_avalon_slave_0_grant_vector(1);
  --cpu/data_master saved-grant sram/avalon_slave_0, which is an e_assign
  cpu_data_master_saved_grant_sram_avalon_slave_0 <= sram_avalon_slave_0_arb_winner(1) AND internal_cpu_data_master_requests_sram_avalon_slave_0;
  --sram/avalon_slave_0 chosen-master double-vector, which is an e_assign
  sram_avalon_slave_0_chosen_master_double_vector <= A_EXT (((std_logic_vector'("0") & ((sram_avalon_slave_0_master_qreq_vector & sram_avalon_slave_0_master_qreq_vector))) AND (((std_logic_vector'("0") & (Std_Logic_Vector'(NOT sram_avalon_slave_0_master_qreq_vector & NOT sram_avalon_slave_0_master_qreq_vector))) + (std_logic_vector'("000") & (sram_avalon_slave_0_arb_addend))))), 4);
  --stable onehot encoding of arb winner
  sram_avalon_slave_0_arb_winner <= A_WE_StdLogicVector((std_logic'(((sram_avalon_slave_0_allow_new_arb_cycle AND or_reduce(sram_avalon_slave_0_grant_vector)))) = '1'), sram_avalon_slave_0_grant_vector, sram_avalon_slave_0_saved_chosen_master_vector);
  --saved sram_avalon_slave_0_grant_vector, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_saved_chosen_master_vector <= std_logic_vector'("00");
    elsif clk'event and clk = '1' then
      if std_logic'(sram_avalon_slave_0_allow_new_arb_cycle) = '1' then 
        sram_avalon_slave_0_saved_chosen_master_vector <= A_WE_StdLogicVector((std_logic'(or_reduce(sram_avalon_slave_0_grant_vector)) = '1'), sram_avalon_slave_0_grant_vector, sram_avalon_slave_0_saved_chosen_master_vector);
      end if;
    end if;

  end process;

  --onehot encoding of chosen master
  sram_avalon_slave_0_grant_vector <= Std_Logic_Vector'(A_ToStdLogicVector(((sram_avalon_slave_0_chosen_master_double_vector(1) OR sram_avalon_slave_0_chosen_master_double_vector(3)))) & A_ToStdLogicVector(((sram_avalon_slave_0_chosen_master_double_vector(0) OR sram_avalon_slave_0_chosen_master_double_vector(2)))));
  --sram/avalon_slave_0 chosen master rotated left, which is an e_assign
  sram_avalon_slave_0_chosen_master_rot_left <= A_EXT (A_WE_StdLogicVector((((A_SLL(sram_avalon_slave_0_arb_winner,std_logic_vector'("00000000000000000000000000000001")))) /= std_logic_vector'("00")), (std_logic_vector'("000000000000000000000000000000") & ((A_SLL(sram_avalon_slave_0_arb_winner,std_logic_vector'("00000000000000000000000000000001"))))), std_logic_vector'("00000000000000000000000000000001")), 2);
  --sram/avalon_slave_0's addend for next-master-grant
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_arb_addend <= std_logic_vector'("01");
    elsif clk'event and clk = '1' then
      if std_logic'(or_reduce(sram_avalon_slave_0_grant_vector)) = '1' then 
        sram_avalon_slave_0_arb_addend <= A_WE_StdLogicVector((std_logic'(sram_avalon_slave_0_end_xfer) = '1'), sram_avalon_slave_0_chosen_master_rot_left, sram_avalon_slave_0_grant_vector);
      end if;
    end if;

  end process;

  sram_avalon_slave_0_chipselect <= internal_cpu_data_master_granted_sram_avalon_slave_0 OR internal_cpu_instruction_master_granted_sram_avalon_slave_0;
  --sram_avalon_slave_0_firsttransfer first transaction, which is an e_assign
  sram_avalon_slave_0_firsttransfer <= A_WE_StdLogic((std_logic'(sram_avalon_slave_0_begins_xfer) = '1'), sram_avalon_slave_0_unreg_firsttransfer, sram_avalon_slave_0_reg_firsttransfer);
  --sram_avalon_slave_0_unreg_firsttransfer first transaction, which is an e_assign
  sram_avalon_slave_0_unreg_firsttransfer <= NOT ((sram_avalon_slave_0_slavearbiterlockenable AND sram_avalon_slave_0_any_continuerequest));
  --sram_avalon_slave_0_reg_firsttransfer first transaction, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      sram_avalon_slave_0_reg_firsttransfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if std_logic'(sram_avalon_slave_0_begins_xfer) = '1' then 
        sram_avalon_slave_0_reg_firsttransfer <= sram_avalon_slave_0_unreg_firsttransfer;
      end if;
    end if;

  end process;

  --sram_avalon_slave_0_beginbursttransfer_internal begin burst transfer, which is an e_assign
  sram_avalon_slave_0_beginbursttransfer_internal <= sram_avalon_slave_0_begins_xfer;
  --sram_avalon_slave_0_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  sram_avalon_slave_0_arbitration_holdoff_internal <= sram_avalon_slave_0_begins_xfer AND sram_avalon_slave_0_firsttransfer;
  --sram_avalon_slave_0_read assignment, which is an e_mux
  sram_avalon_slave_0_read <= ((internal_cpu_data_master_granted_sram_avalon_slave_0 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_sram_avalon_slave_0 AND cpu_instruction_master_read));
  --sram_avalon_slave_0_write assignment, which is an e_mux
  sram_avalon_slave_0_write <= internal_cpu_data_master_granted_sram_avalon_slave_0 AND cpu_data_master_write;
  shifted_address_to_sram_avalon_slave_0_from_cpu_data_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_data_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_data_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 21);
  --sram_avalon_slave_0_address mux, which is an e_mux
  sram_avalon_slave_0_address <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sram_avalon_slave_0)) = '1'), (A_SRL(shifted_address_to_sram_avalon_slave_0_from_cpu_data_master,std_logic_vector'("00000000000000000000000000000001"))), (A_SRL(shifted_address_to_sram_avalon_slave_0_from_cpu_instruction_master,std_logic_vector'("00000000000000000000000000000001")))), 18);
  shifted_address_to_sram_avalon_slave_0_from_cpu_instruction_master <= A_EXT (Std_Logic_Vector'(A_SRL(cpu_instruction_master_address_to_slave,std_logic_vector'("00000000000000000000000000000010")) & A_ToStdLogicVector(cpu_instruction_master_dbs_address(1)) & A_ToStdLogicVector(std_logic'('0'))), 21);
  --d1_sram_avalon_slave_0_end_xfer register, which is an e_register
  process (clk, reset_n)
  begin
    if reset_n = '0' then
      d1_sram_avalon_slave_0_end_xfer <= std_logic'('1');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        d1_sram_avalon_slave_0_end_xfer <= sram_avalon_slave_0_end_xfer;
      end if;
    end if;

  end process;

  --sram_avalon_slave_0_waits_for_read in a cycle, which is an e_mux
  sram_avalon_slave_0_waits_for_read <= sram_avalon_slave_0_in_a_read_cycle AND sram_avalon_slave_0_begins_xfer;
  --sram_avalon_slave_0_in_a_read_cycle assignment, which is an e_assign
  sram_avalon_slave_0_in_a_read_cycle <= ((internal_cpu_data_master_granted_sram_avalon_slave_0 AND cpu_data_master_read)) OR ((internal_cpu_instruction_master_granted_sram_avalon_slave_0 AND cpu_instruction_master_read));
  --in_a_read_cycle assignment, which is an e_mux
  in_a_read_cycle <= sram_avalon_slave_0_in_a_read_cycle;
  --sram_avalon_slave_0_waits_for_write in a cycle, which is an e_mux
  sram_avalon_slave_0_waits_for_write <= Vector_To_Std_Logic(((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(sram_avalon_slave_0_in_a_write_cycle))) AND std_logic_vector'("00000000000000000000000000000000")));
  --sram_avalon_slave_0_in_a_write_cycle assignment, which is an e_assign
  sram_avalon_slave_0_in_a_write_cycle <= internal_cpu_data_master_granted_sram_avalon_slave_0 AND cpu_data_master_write;
  --in_a_write_cycle assignment, which is an e_mux
  in_a_write_cycle <= sram_avalon_slave_0_in_a_write_cycle;
  wait_for_sram_avalon_slave_0_counter <= std_logic'('0');
  --sram_avalon_slave_0_byteenable byte enable port mux, which is an e_mux
  sram_avalon_slave_0_byteenable <= A_EXT (A_WE_StdLogicVector((std_logic'((internal_cpu_data_master_granted_sram_avalon_slave_0)) = '1'), (std_logic_vector'("000000000000000000000000000000") & (internal_cpu_data_master_byteenable_sram_avalon_slave_0)), -SIGNED(std_logic_vector'("00000000000000000000000000000001"))), 2);
  (cpu_data_master_byteenable_sram_avalon_slave_0_segment_1(1), cpu_data_master_byteenable_sram_avalon_slave_0_segment_1(0), cpu_data_master_byteenable_sram_avalon_slave_0_segment_0(1), cpu_data_master_byteenable_sram_avalon_slave_0_segment_0(0)) <= cpu_data_master_byteenable;
  internal_cpu_data_master_byteenable_sram_avalon_slave_0 <= A_WE_StdLogicVector((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_data_master_dbs_address(1)))) = std_logic_vector'("00000000000000000000000000000000"))), cpu_data_master_byteenable_sram_avalon_slave_0_segment_0, cpu_data_master_byteenable_sram_avalon_slave_0_segment_1);
  --vhdl renameroo for output signals
  cpu_data_master_byteenable_sram_avalon_slave_0 <= internal_cpu_data_master_byteenable_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_granted_sram_avalon_slave_0 <= internal_cpu_data_master_granted_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_data_master_qualified_request_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_data_master_requests_sram_avalon_slave_0 <= internal_cpu_data_master_requests_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_instruction_master_granted_sram_avalon_slave_0 <= internal_cpu_instruction_master_granted_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_instruction_master_qualified_request_sram_avalon_slave_0 <= internal_cpu_instruction_master_qualified_request_sram_avalon_slave_0;
  --vhdl renameroo for output signals
  cpu_instruction_master_requests_sram_avalon_slave_0 <= internal_cpu_instruction_master_requests_sram_avalon_slave_0;
--synthesis translate_off
    --sram/avalon_slave_0 enable non-zero assertions, which is an e_register
    process (clk, reset_n)
    begin
      if reset_n = '0' then
        enable_nonzero_assertions <= std_logic'('0');
      elsif clk'event and clk = '1' then
        if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
          enable_nonzero_assertions <= std_logic'('1');
        end if;
      end if;

    end process;

    --grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line4 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_data_master_granted_sram_avalon_slave_0))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(internal_cpu_instruction_master_granted_sram_avalon_slave_0))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line4, now);
          write(write_line4, string'(": "));
          write(write_line4, string'("> 1 of grant signals are active simultaneously"));
          write(output, write_line4.all);
          deallocate (write_line4);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

    --saved_grant signals are active simultaneously, which is an e_process
    process (clk)
    VARIABLE write_line5 : line;
    begin
      if clk'event and clk = '1' then
        if (std_logic_vector'("000000000000000000000000000000") & (((std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_data_master_saved_grant_sram_avalon_slave_0))) + (std_logic_vector'("0") & (A_TOSTDLOGICVECTOR(cpu_instruction_master_saved_grant_sram_avalon_slave_0))))))>std_logic_vector'("00000000000000000000000000000001") then 
          write(write_line5, now);
          write(write_line5, string'(": "));
          write(write_line5, string'("> 1 of saved_grant signals are active simultaneously"));
          write(output, write_line5.all);
          deallocate (write_line5);
          assert false report "VHDL STOP" severity failure;
        end if;
      end if;

    end process;

--synthesis translate_on

end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity nios_system_reset_clk_domain_synch_module is 
        port (
              -- inputs:
                 signal clk : IN STD_LOGIC;
                 signal data_in : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- outputs:
                 signal data_out : OUT STD_LOGIC
              );
end entity nios_system_reset_clk_domain_synch_module;


architecture europa of nios_system_reset_clk_domain_synch_module is
                signal data_in_d1 :  STD_LOGIC;
attribute ALTERA_ATTRIBUTE : string;
attribute ALTERA_ATTRIBUTE of data_in_d1 : signal is "MAX_DELAY=100ns ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";
attribute ALTERA_ATTRIBUTE of data_out : signal is "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101";

begin

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_in_d1 <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        data_in_d1 <= data_in;
      end if;
    end if;

  end process;

  process (clk, reset_n)
  begin
    if reset_n = '0' then
      data_out <= std_logic'('0');
    elsif clk'event and clk = '1' then
      if (std_logic_vector'("00000000000000000000000000000001")) /= std_logic_vector'("00000000000000000000000000000000") then 
        data_out <= data_in_d1;
      end if;
    end if;

  end process;


end europa;



-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity nios_system is 
        port (
              -- 1) global signals:
                 signal clk : IN STD_LOGIC;
                 signal reset_n : IN STD_LOGIC;

              -- the_DM9000A
                 signal ENET_CMD_from_the_DM9000A : OUT STD_LOGIC;
                 signal ENET_CS_N_from_the_DM9000A : OUT STD_LOGIC;
                 signal ENET_DATA_to_and_from_the_DM9000A : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal ENET_INT_to_the_DM9000A : IN STD_LOGIC;
                 signal ENET_RD_N_from_the_DM9000A : OUT STD_LOGIC;
                 signal ENET_RST_N_from_the_DM9000A : OUT STD_LOGIC;
                 signal ENET_WR_N_from_the_DM9000A : OUT STD_LOGIC;

              -- the_audio
                 signal AUD_ADCDAT_to_the_audio : IN STD_LOGIC;
                 signal AUD_ADCLRCK_from_the_audio : OUT STD_LOGIC;
                 signal AUD_BCLK_to_and_from_the_audio : INOUT STD_LOGIC;
                 signal AUD_DACDAT_from_the_audio : OUT STD_LOGIC;
                 signal AUD_DACLRCK_from_the_audio : OUT STD_LOGIC;
                 signal audio_request_from_the_audio : OUT STD_LOGIC;
                 signal data_to_the_audio : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal test_mode_to_the_audio : IN STD_LOGIC;

              -- the_ps2
                 signal PS2_Clk_to_the_ps2 : IN STD_LOGIC;
                 signal PS2_Data_to_the_ps2 : IN STD_LOGIC;

              -- the_raster
                 signal VGA_BLANK_from_the_raster : OUT STD_LOGIC;
                 signal VGA_B_from_the_raster : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal VGA_CLK_from_the_raster : OUT STD_LOGIC;
                 signal VGA_G_from_the_raster : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal VGA_HS_from_the_raster : OUT STD_LOGIC;
                 signal VGA_R_from_the_raster : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                 signal VGA_SYNC_from_the_raster : OUT STD_LOGIC;
                 signal VGA_VS_from_the_raster : OUT STD_LOGIC;

              -- the_sram
                 signal SRAM_ADDR_from_the_sram : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                 signal SRAM_CE_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_DQ_to_and_from_the_sram : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal SRAM_LB_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_OE_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_UB_N_from_the_sram : OUT STD_LOGIC;
                 signal SRAM_WE_N_from_the_sram : OUT STD_LOGIC
              );
end entity nios_system;


architecture europa of nios_system is
component DM9000A_avalonS_arbitrator is 
           port (
                 -- inputs:
                    signal DM9000A_avalonS_irq : IN STD_LOGIC;
                    signal DM9000A_avalonS_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal DM9000A_avalonS_address : OUT STD_LOGIC;
                    signal DM9000A_avalonS_chipselect_n : OUT STD_LOGIC;
                    signal DM9000A_avalonS_irq_from_sa : OUT STD_LOGIC;
                    signal DM9000A_avalonS_read_n : OUT STD_LOGIC;
                    signal DM9000A_avalonS_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal DM9000A_avalonS_reset_n : OUT STD_LOGIC;
                    signal DM9000A_avalonS_wait_counter_eq_0 : OUT STD_LOGIC;
                    signal DM9000A_avalonS_write_n : OUT STD_LOGIC;
                    signal DM9000A_avalonS_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_granted_DM9000A_avalonS : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_DM9000A_avalonS : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_DM9000A_avalonS : OUT STD_LOGIC;
                    signal cpu_data_master_requests_DM9000A_avalonS : OUT STD_LOGIC;
                    signal d1_DM9000A_avalonS_end_xfer : OUT STD_LOGIC
                 );
end component DM9000A_avalonS_arbitrator;

component DM9000A is 
           port (
                 -- inputs:
                    signal ENET_INT : IN STD_LOGIC;
                    signal iCMD : IN STD_LOGIC;
                    signal iCS_N : IN STD_LOGIC;
                    signal iDATA : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal iRD_N : IN STD_LOGIC;
                    signal iRST_N : IN STD_LOGIC;
                    signal iWR_N : IN STD_LOGIC;

                 -- outputs:
                    signal ENET_CMD : OUT STD_LOGIC;
                    signal ENET_CS_N : OUT STD_LOGIC;
                    signal ENET_DATA : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal ENET_RD_N : OUT STD_LOGIC;
                    signal ENET_RST_N : OUT STD_LOGIC;
                    signal ENET_WR_N : OUT STD_LOGIC;
                    signal oDATA : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal oINT : OUT STD_LOGIC
                 );
end component DM9000A;

component audio_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal audio_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal audio_avalon_slave_0_reset_n : OUT STD_LOGIC;
                    signal audio_avalon_slave_0_write : OUT STD_LOGIC;
                    signal audio_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_byteenable_audio_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_granted_audio_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_audio_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_audio_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_audio_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_audio_avalon_slave_0_end_xfer : OUT STD_LOGIC
                 );
end component audio_avalon_slave_0_arbitrator;

component audio is 
           port (
                 -- inputs:
                    signal AUD_ADCDAT : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal test_mode : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal AUD_ADCLRCK : OUT STD_LOGIC;
                    signal AUD_BCLK : INOUT STD_LOGIC;
                    signal AUD_DACDAT : OUT STD_LOGIC;
                    signal AUD_DACLRCK : OUT STD_LOGIC;
                    signal audio_request : OUT STD_LOGIC
                 );
end component audio;

component cpu_jtag_debug_module_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_resetrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_address : OUT STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal cpu_jtag_debug_module_begintransfer : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_jtag_debug_module_chipselect : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_debugaccess : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_reset : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_reset_n : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_resetrequest_from_sa : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_write : OUT STD_LOGIC;
                    signal cpu_jtag_debug_module_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : OUT STD_LOGIC
                 );
end component cpu_jtag_debug_module_arbitrator;

component cpu_data_master_arbitrator is 
           port (
                 -- inputs:
                    signal DM9000A_avalonS_irq_from_sa : IN STD_LOGIC;
                    signal DM9000A_avalonS_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal DM9000A_avalonS_wait_counter_eq_0 : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_byteenable_audio_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_byteenable_raster_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_byteenable_sram_avalon_slave_0 : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_debugaccess : IN STD_LOGIC;
                    signal cpu_data_master_granted_DM9000A_avalonS : IN STD_LOGIC;
                    signal cpu_data_master_granted_audio_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_granted_ps2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_granted_raster_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_DM9000A_avalonS : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_audio_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_ps2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_raster_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_DM9000A_avalonS : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_audio_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_ps2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_raster_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_requests_DM9000A_avalonS : IN STD_LOGIC;
                    signal cpu_data_master_requests_audio_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : IN STD_LOGIC;
                    signal cpu_data_master_requests_ps2_s1 : IN STD_LOGIC;
                    signal cpu_data_master_requests_raster_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_DM9000A_avalonS_end_xfer : IN STD_LOGIC;
                    signal d1_audio_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : IN STD_LOGIC;
                    signal d1_ps2_s1_end_xfer : IN STD_LOGIC;
                    signal d1_raster_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : IN STD_LOGIC;
                    signal ps2_s1_readdata_from_sa : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal raster_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_data_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_dbs_write_16 : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_irq : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_no_byte_enables_and_last_term : OUT STD_LOGIC;
                    signal cpu_data_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_data_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_data_master_arbitrator;

component cpu_instruction_master_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_instruction_master_address : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_instruction_master_granted_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_granted_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_cpu_jtag_debug_module : IN STD_LOGIC;
                    signal cpu_instruction_master_requests_sram_avalon_slave_0 : IN STD_LOGIC;
                    signal cpu_jtag_debug_module_readdata_from_sa : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d1_cpu_jtag_debug_module_end_xfer : IN STD_LOGIC;
                    signal d1_sram_avalon_slave_0_end_xfer : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sram_avalon_slave_0_readdata_from_sa : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_instruction_master_address_to_slave : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_instruction_master_dbs_address : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_instruction_master_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal cpu_instruction_master_waitrequest : OUT STD_LOGIC
                 );
end component cpu_instruction_master_arbitrator;

component cpu is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal d_irq : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal d_waitrequest : IN STD_LOGIC;
                    signal i_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_waitrequest : IN STD_LOGIC;
                    signal jtag_debug_module_address : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
                    signal jtag_debug_module_begintransfer : IN STD_LOGIC;
                    signal jtag_debug_module_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal jtag_debug_module_clk : IN STD_LOGIC;
                    signal jtag_debug_module_debugaccess : IN STD_LOGIC;
                    signal jtag_debug_module_reset : IN STD_LOGIC;
                    signal jtag_debug_module_select : IN STD_LOGIC;
                    signal jtag_debug_module_write : IN STD_LOGIC;
                    signal jtag_debug_module_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal d_address : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal d_byteenable : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal d_read : OUT STD_LOGIC;
                    signal d_write : OUT STD_LOGIC;
                    signal d_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal i_address : OUT STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal i_read : OUT STD_LOGIC;
                    signal jtag_debug_module_debugaccess_to_roms : OUT STD_LOGIC;
                    signal jtag_debug_module_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_debug_module_resetrequest : OUT STD_LOGIC
                 );
end component cpu;

component jtag_uart_avalon_jtag_slave_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_data_master_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_dataavailable : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata : IN STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave : OUT STD_LOGIC;
                    signal d1_jtag_uart_avalon_jtag_slave_end_xfer : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_address : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_chipselect : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_irq_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_read_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_readdata_from_sa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_reset_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_write_n : OUT STD_LOGIC;
                    signal jtag_uart_avalon_jtag_slave_writedata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
                 );
end component jtag_uart_avalon_jtag_slave_arbitrator;

component jtag_uart is 
           port (
                 -- inputs:
                    signal av_address : IN STD_LOGIC;
                    signal av_chipselect : IN STD_LOGIC;
                    signal av_read_n : IN STD_LOGIC;
                    signal av_write_n : IN STD_LOGIC;
                    signal av_writedata : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal clk : IN STD_LOGIC;
                    signal rst_n : IN STD_LOGIC;

                 -- outputs:
                    signal av_irq : OUT STD_LOGIC;
                    signal av_readdata : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
                    signal av_waitrequest : OUT STD_LOGIC;
                    signal dataavailable : OUT STD_LOGIC;
                    signal readyfordata : OUT STD_LOGIC
                 );
end component jtag_uart;

component ps2_s1_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal ps2_s1_readdata : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_granted_ps2_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_ps2_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_ps2_s1 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_ps2_s1 : OUT STD_LOGIC;
                    signal d1_ps2_s1_end_xfer : OUT STD_LOGIC;
                    signal ps2_s1_address : OUT STD_LOGIC;
                    signal ps2_s1_chipselect : OUT STD_LOGIC;
                    signal ps2_s1_read : OUT STD_LOGIC;
                    signal ps2_s1_readdata_from_sa : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal ps2_s1_reset : OUT STD_LOGIC
                 );
end component ps2_s1_arbitrator;

component ps2 is 
           port (
                 -- inputs:
                    signal PS2_Clk : IN STD_LOGIC;
                    signal PS2_Data : IN STD_LOGIC;
                    signal avs_s1_address : IN STD_LOGIC;
                    signal avs_s1_chipselect : IN STD_LOGIC;
                    signal avs_s1_clk : IN STD_LOGIC;
                    signal avs_s1_read : IN STD_LOGIC;
                    signal avs_s1_reset : IN STD_LOGIC;

                 -- outputs:
                    signal avs_s1_readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component ps2;

component raster_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal raster_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal cpu_data_master_byteenable_raster_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_granted_raster_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_raster_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_raster_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_raster_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_raster_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal raster_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal raster_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal raster_avalon_slave_0_read : OUT STD_LOGIC;
                    signal raster_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal raster_avalon_slave_0_reset : OUT STD_LOGIC;
                    signal raster_avalon_slave_0_write : OUT STD_LOGIC;
                    signal raster_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component raster_avalon_slave_0_arbitrator;

component raster is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal reset : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal VGA_B : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_BLANK : OUT STD_LOGIC;
                    signal VGA_CLK : OUT STD_LOGIC;
                    signal VGA_G : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_HS : OUT STD_LOGIC;
                    signal VGA_R : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_SYNC : OUT STD_LOGIC;
                    signal VGA_VS : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component raster;

component sram_avalon_slave_0_arbitrator is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal cpu_data_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_data_master_byteenable : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
                    signal cpu_data_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_dbs_write_16 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal cpu_data_master_no_byte_enables_and_last_term : IN STD_LOGIC;
                    signal cpu_data_master_read : IN STD_LOGIC;
                    signal cpu_data_master_waitrequest : IN STD_LOGIC;
                    signal cpu_data_master_write : IN STD_LOGIC;
                    signal cpu_instruction_master_address_to_slave : IN STD_LOGIC_VECTOR (20 DOWNTO 0);
                    signal cpu_instruction_master_dbs_address : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_instruction_master_read : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;
                    signal sram_avalon_slave_0_readdata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal cpu_data_master_byteenable_sram_avalon_slave_0 : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal cpu_data_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_data_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_instruction_master_granted_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_instruction_master_qualified_request_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_instruction_master_read_data_valid_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal cpu_instruction_master_requests_sram_avalon_slave_0 : OUT STD_LOGIC;
                    signal d1_sram_avalon_slave_0_end_xfer : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_address : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal sram_avalon_slave_0_byteenable : OUT STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal sram_avalon_slave_0_chipselect : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_read : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_readdata_from_sa : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal sram_avalon_slave_0_write : OUT STD_LOGIC;
                    signal sram_avalon_slave_0_writedata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sram_avalon_slave_0_arbitrator;

component sram is 
           port (
                 -- inputs:
                    signal address : IN STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal byteenable : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
                    signal chipselect : IN STD_LOGIC;
                    signal read : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal SRAM_ADDR : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal SRAM_CE_N : OUT STD_LOGIC;
                    signal SRAM_DQ : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal SRAM_LB_N : OUT STD_LOGIC;
                    signal SRAM_OE_N : OUT STD_LOGIC;
                    signal SRAM_UB_N : OUT STD_LOGIC;
                    signal SRAM_WE_N : OUT STD_LOGIC;
                    signal readdata : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
                 );
end component sram;

component nios_system_reset_clk_domain_synch_module is 
           port (
                 -- inputs:
                    signal clk : IN STD_LOGIC;
                    signal data_in : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- outputs:
                    signal data_out : OUT STD_LOGIC
                 );
end component nios_system_reset_clk_domain_synch_module;

                signal DM9000A_avalonS_address :  STD_LOGIC;
                signal DM9000A_avalonS_chipselect_n :  STD_LOGIC;
                signal DM9000A_avalonS_irq :  STD_LOGIC;
                signal DM9000A_avalonS_irq_from_sa :  STD_LOGIC;
                signal DM9000A_avalonS_read_n :  STD_LOGIC;
                signal DM9000A_avalonS_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal DM9000A_avalonS_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal DM9000A_avalonS_reset_n :  STD_LOGIC;
                signal DM9000A_avalonS_wait_counter_eq_0 :  STD_LOGIC;
                signal DM9000A_avalonS_write_n :  STD_LOGIC;
                signal DM9000A_avalonS_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal audio_avalon_slave_0_chipselect :  STD_LOGIC;
                signal audio_avalon_slave_0_reset_n :  STD_LOGIC;
                signal audio_avalon_slave_0_write :  STD_LOGIC;
                signal audio_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal clk_reset_n :  STD_LOGIC;
                signal cpu_data_master_address :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_data_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_data_master_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_data_master_byteenable_audio_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_byteenable_raster_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_byteenable_sram_avalon_slave_0 :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_data_master_dbs_write_16 :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal cpu_data_master_debugaccess :  STD_LOGIC;
                signal cpu_data_master_granted_DM9000A_avalonS :  STD_LOGIC;
                signal cpu_data_master_granted_audio_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_granted_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_granted_ps2_s1 :  STD_LOGIC;
                signal cpu_data_master_granted_raster_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_irq :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_no_byte_enables_and_last_term :  STD_LOGIC;
                signal cpu_data_master_qualified_request_DM9000A_avalonS :  STD_LOGIC;
                signal cpu_data_master_qualified_request_audio_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_qualified_request_ps2_s1 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_raster_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_read :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_DM9000A_avalonS :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_audio_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_ps2_s1 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_raster_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_read_data_valid_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_data_master_requests_DM9000A_avalonS :  STD_LOGIC;
                signal cpu_data_master_requests_audio_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_data_master_requests_jtag_uart_avalon_jtag_slave :  STD_LOGIC;
                signal cpu_data_master_requests_ps2_s1 :  STD_LOGIC;
                signal cpu_data_master_requests_raster_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_data_master_waitrequest :  STD_LOGIC;
                signal cpu_data_master_write :  STD_LOGIC;
                signal cpu_data_master_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_address :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_instruction_master_address_to_slave :  STD_LOGIC_VECTOR (20 DOWNTO 0);
                signal cpu_instruction_master_dbs_address :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal cpu_instruction_master_granted_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_granted_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_qualified_request_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_instruction_master_read :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_read_data_valid_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_instruction_master_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_instruction_master_requests_cpu_jtag_debug_module :  STD_LOGIC;
                signal cpu_instruction_master_requests_sram_avalon_slave_0 :  STD_LOGIC;
                signal cpu_instruction_master_waitrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_address :  STD_LOGIC_VECTOR (8 DOWNTO 0);
                signal cpu_jtag_debug_module_begintransfer :  STD_LOGIC;
                signal cpu_jtag_debug_module_byteenable :  STD_LOGIC_VECTOR (3 DOWNTO 0);
                signal cpu_jtag_debug_module_chipselect :  STD_LOGIC;
                signal cpu_jtag_debug_module_debugaccess :  STD_LOGIC;
                signal cpu_jtag_debug_module_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal cpu_jtag_debug_module_reset :  STD_LOGIC;
                signal cpu_jtag_debug_module_reset_n :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest :  STD_LOGIC;
                signal cpu_jtag_debug_module_resetrequest_from_sa :  STD_LOGIC;
                signal cpu_jtag_debug_module_write :  STD_LOGIC;
                signal cpu_jtag_debug_module_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal d1_DM9000A_avalonS_end_xfer :  STD_LOGIC;
                signal d1_audio_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_cpu_jtag_debug_module_end_xfer :  STD_LOGIC;
                signal d1_jtag_uart_avalon_jtag_slave_end_xfer :  STD_LOGIC;
                signal d1_ps2_s1_end_xfer :  STD_LOGIC;
                signal d1_raster_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal d1_sram_avalon_slave_0_end_xfer :  STD_LOGIC;
                signal internal_AUD_ADCLRCK_from_the_audio :  STD_LOGIC;
                signal internal_AUD_DACDAT_from_the_audio :  STD_LOGIC;
                signal internal_AUD_DACLRCK_from_the_audio :  STD_LOGIC;
                signal internal_ENET_CMD_from_the_DM9000A :  STD_LOGIC;
                signal internal_ENET_CS_N_from_the_DM9000A :  STD_LOGIC;
                signal internal_ENET_RD_N_from_the_DM9000A :  STD_LOGIC;
                signal internal_ENET_RST_N_from_the_DM9000A :  STD_LOGIC;
                signal internal_ENET_WR_N_from_the_DM9000A :  STD_LOGIC;
                signal internal_SRAM_ADDR_from_the_sram :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal internal_SRAM_CE_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_LB_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_OE_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_UB_N_from_the_sram :  STD_LOGIC;
                signal internal_SRAM_WE_N_from_the_sram :  STD_LOGIC;
                signal internal_VGA_BLANK_from_the_raster :  STD_LOGIC;
                signal internal_VGA_B_from_the_raster :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal internal_VGA_CLK_from_the_raster :  STD_LOGIC;
                signal internal_VGA_G_from_the_raster :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal internal_VGA_HS_from_the_raster :  STD_LOGIC;
                signal internal_VGA_R_from_the_raster :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal internal_VGA_SYNC_from_the_raster :  STD_LOGIC;
                signal internal_VGA_VS_from_the_raster :  STD_LOGIC;
                signal internal_audio_request_from_the_audio :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_address :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_chipselect :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_irq_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_read_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readdata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readdata_from_sa :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_readyfordata :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_reset_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_waitrequest_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_write_n :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_writedata :  STD_LOGIC_VECTOR (31 DOWNTO 0);
                signal module_input :  STD_LOGIC;
                signal ps2_s1_address :  STD_LOGIC;
                signal ps2_s1_chipselect :  STD_LOGIC;
                signal ps2_s1_read :  STD_LOGIC;
                signal ps2_s1_readdata :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ps2_s1_readdata_from_sa :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal ps2_s1_reset :  STD_LOGIC;
                signal raster_avalon_slave_0_address :  STD_LOGIC_VECTOR (7 DOWNTO 0);
                signal raster_avalon_slave_0_chipselect :  STD_LOGIC;
                signal raster_avalon_slave_0_read :  STD_LOGIC;
                signal raster_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal raster_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal raster_avalon_slave_0_reset :  STD_LOGIC;
                signal raster_avalon_slave_0_write :  STD_LOGIC;
                signal raster_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal reset_n_sources :  STD_LOGIC;
                signal sram_avalon_slave_0_address :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal sram_avalon_slave_0_byteenable :  STD_LOGIC_VECTOR (1 DOWNTO 0);
                signal sram_avalon_slave_0_chipselect :  STD_LOGIC;
                signal sram_avalon_slave_0_read :  STD_LOGIC;
                signal sram_avalon_slave_0_readdata :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sram_avalon_slave_0_readdata_from_sa :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal sram_avalon_slave_0_write :  STD_LOGIC;
                signal sram_avalon_slave_0_writedata :  STD_LOGIC_VECTOR (15 DOWNTO 0);

begin

  --the_DM9000A_avalonS, which is an e_instance
  the_DM9000A_avalonS : DM9000A_avalonS_arbitrator
    port map(
      DM9000A_avalonS_address => DM9000A_avalonS_address,
      DM9000A_avalonS_chipselect_n => DM9000A_avalonS_chipselect_n,
      DM9000A_avalonS_irq_from_sa => DM9000A_avalonS_irq_from_sa,
      DM9000A_avalonS_read_n => DM9000A_avalonS_read_n,
      DM9000A_avalonS_readdata_from_sa => DM9000A_avalonS_readdata_from_sa,
      DM9000A_avalonS_reset_n => DM9000A_avalonS_reset_n,
      DM9000A_avalonS_wait_counter_eq_0 => DM9000A_avalonS_wait_counter_eq_0,
      DM9000A_avalonS_write_n => DM9000A_avalonS_write_n,
      DM9000A_avalonS_writedata => DM9000A_avalonS_writedata,
      cpu_data_master_granted_DM9000A_avalonS => cpu_data_master_granted_DM9000A_avalonS,
      cpu_data_master_qualified_request_DM9000A_avalonS => cpu_data_master_qualified_request_DM9000A_avalonS,
      cpu_data_master_read_data_valid_DM9000A_avalonS => cpu_data_master_read_data_valid_DM9000A_avalonS,
      cpu_data_master_requests_DM9000A_avalonS => cpu_data_master_requests_DM9000A_avalonS,
      d1_DM9000A_avalonS_end_xfer => d1_DM9000A_avalonS_end_xfer,
      DM9000A_avalonS_irq => DM9000A_avalonS_irq,
      DM9000A_avalonS_readdata => DM9000A_avalonS_readdata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      reset_n => clk_reset_n
    );


  --the_DM9000A, which is an e_ptf_instance
  the_DM9000A : DM9000A
    port map(
      ENET_CMD => internal_ENET_CMD_from_the_DM9000A,
      ENET_CS_N => internal_ENET_CS_N_from_the_DM9000A,
      ENET_DATA => ENET_DATA_to_and_from_the_DM9000A,
      ENET_RD_N => internal_ENET_RD_N_from_the_DM9000A,
      ENET_RST_N => internal_ENET_RST_N_from_the_DM9000A,
      ENET_WR_N => internal_ENET_WR_N_from_the_DM9000A,
      oDATA => DM9000A_avalonS_readdata,
      oINT => DM9000A_avalonS_irq,
      ENET_INT => ENET_INT_to_the_DM9000A,
      iCMD => DM9000A_avalonS_address,
      iCS_N => DM9000A_avalonS_chipselect_n,
      iDATA => DM9000A_avalonS_writedata,
      iRD_N => DM9000A_avalonS_read_n,
      iRST_N => DM9000A_avalonS_reset_n,
      iWR_N => DM9000A_avalonS_write_n
    );


  --the_audio_avalon_slave_0, which is an e_instance
  the_audio_avalon_slave_0 : audio_avalon_slave_0_arbitrator
    port map(
      audio_avalon_slave_0_chipselect => audio_avalon_slave_0_chipselect,
      audio_avalon_slave_0_reset_n => audio_avalon_slave_0_reset_n,
      audio_avalon_slave_0_write => audio_avalon_slave_0_write,
      audio_avalon_slave_0_writedata => audio_avalon_slave_0_writedata,
      cpu_data_master_byteenable_audio_avalon_slave_0 => cpu_data_master_byteenable_audio_avalon_slave_0,
      cpu_data_master_granted_audio_avalon_slave_0 => cpu_data_master_granted_audio_avalon_slave_0,
      cpu_data_master_qualified_request_audio_avalon_slave_0 => cpu_data_master_qualified_request_audio_avalon_slave_0,
      cpu_data_master_read_data_valid_audio_avalon_slave_0 => cpu_data_master_read_data_valid_audio_avalon_slave_0,
      cpu_data_master_requests_audio_avalon_slave_0 => cpu_data_master_requests_audio_avalon_slave_0,
      d1_audio_avalon_slave_0_end_xfer => d1_audio_avalon_slave_0_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_dbs_address => cpu_data_master_dbs_address,
      cpu_data_master_dbs_write_16 => cpu_data_master_dbs_write_16,
      cpu_data_master_no_byte_enables_and_last_term => cpu_data_master_no_byte_enables_and_last_term,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      reset_n => clk_reset_n
    );


  --the_audio, which is an e_ptf_instance
  the_audio : audio
    port map(
      AUD_ADCLRCK => internal_AUD_ADCLRCK_from_the_audio,
      AUD_BCLK => AUD_BCLK_to_and_from_the_audio,
      AUD_DACDAT => internal_AUD_DACDAT_from_the_audio,
      AUD_DACLRCK => internal_AUD_DACLRCK_from_the_audio,
      audio_request => internal_audio_request_from_the_audio,
      AUD_ADCDAT => AUD_ADCDAT_to_the_audio,
      chipselect => audio_avalon_slave_0_chipselect,
      clk => clk,
      data => data_to_the_audio,
      reset_n => audio_avalon_slave_0_reset_n,
      test_mode => test_mode_to_the_audio,
      write => audio_avalon_slave_0_write,
      writedata => audio_avalon_slave_0_writedata
    );


  --the_cpu_jtag_debug_module, which is an e_instance
  the_cpu_jtag_debug_module : cpu_jtag_debug_module_arbitrator
    port map(
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_jtag_debug_module_address => cpu_jtag_debug_module_address,
      cpu_jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      cpu_jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      cpu_jtag_debug_module_chipselect => cpu_jtag_debug_module_chipselect,
      cpu_jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      cpu_jtag_debug_module_reset => cpu_jtag_debug_module_reset,
      cpu_jtag_debug_module_reset_n => cpu_jtag_debug_module_reset_n,
      cpu_jtag_debug_module_resetrequest_from_sa => cpu_jtag_debug_module_resetrequest_from_sa,
      cpu_jtag_debug_module_write => cpu_jtag_debug_module_write,
      cpu_jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_debugaccess => cpu_data_master_debugaccess,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      cpu_jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      reset_n => clk_reset_n
    );


  --the_cpu_data_master, which is an e_instance
  the_cpu_data_master : cpu_data_master_arbitrator
    port map(
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_dbs_address => cpu_data_master_dbs_address,
      cpu_data_master_dbs_write_16 => cpu_data_master_dbs_write_16,
      cpu_data_master_irq => cpu_data_master_irq,
      cpu_data_master_no_byte_enables_and_last_term => cpu_data_master_no_byte_enables_and_last_term,
      cpu_data_master_readdata => cpu_data_master_readdata,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      DM9000A_avalonS_irq_from_sa => DM9000A_avalonS_irq_from_sa,
      DM9000A_avalonS_readdata_from_sa => DM9000A_avalonS_readdata_from_sa,
      DM9000A_avalonS_wait_counter_eq_0 => DM9000A_avalonS_wait_counter_eq_0,
      clk => clk,
      cpu_data_master_address => cpu_data_master_address,
      cpu_data_master_byteenable_audio_avalon_slave_0 => cpu_data_master_byteenable_audio_avalon_slave_0,
      cpu_data_master_byteenable_raster_avalon_slave_0 => cpu_data_master_byteenable_raster_avalon_slave_0,
      cpu_data_master_byteenable_sram_avalon_slave_0 => cpu_data_master_byteenable_sram_avalon_slave_0,
      cpu_data_master_debugaccess => cpu_data_master_debugaccess,
      cpu_data_master_granted_DM9000A_avalonS => cpu_data_master_granted_DM9000A_avalonS,
      cpu_data_master_granted_audio_avalon_slave_0 => cpu_data_master_granted_audio_avalon_slave_0,
      cpu_data_master_granted_cpu_jtag_debug_module => cpu_data_master_granted_cpu_jtag_debug_module,
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_granted_ps2_s1 => cpu_data_master_granted_ps2_s1,
      cpu_data_master_granted_raster_avalon_slave_0 => cpu_data_master_granted_raster_avalon_slave_0,
      cpu_data_master_granted_sram_avalon_slave_0 => cpu_data_master_granted_sram_avalon_slave_0,
      cpu_data_master_qualified_request_DM9000A_avalonS => cpu_data_master_qualified_request_DM9000A_avalonS,
      cpu_data_master_qualified_request_audio_avalon_slave_0 => cpu_data_master_qualified_request_audio_avalon_slave_0,
      cpu_data_master_qualified_request_cpu_jtag_debug_module => cpu_data_master_qualified_request_cpu_jtag_debug_module,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_ps2_s1 => cpu_data_master_qualified_request_ps2_s1,
      cpu_data_master_qualified_request_raster_avalon_slave_0 => cpu_data_master_qualified_request_raster_avalon_slave_0,
      cpu_data_master_qualified_request_sram_avalon_slave_0 => cpu_data_master_qualified_request_sram_avalon_slave_0,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_read_data_valid_DM9000A_avalonS => cpu_data_master_read_data_valid_DM9000A_avalonS,
      cpu_data_master_read_data_valid_audio_avalon_slave_0 => cpu_data_master_read_data_valid_audio_avalon_slave_0,
      cpu_data_master_read_data_valid_cpu_jtag_debug_module => cpu_data_master_read_data_valid_cpu_jtag_debug_module,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_ps2_s1 => cpu_data_master_read_data_valid_ps2_s1,
      cpu_data_master_read_data_valid_raster_avalon_slave_0 => cpu_data_master_read_data_valid_raster_avalon_slave_0,
      cpu_data_master_read_data_valid_sram_avalon_slave_0 => cpu_data_master_read_data_valid_sram_avalon_slave_0,
      cpu_data_master_requests_DM9000A_avalonS => cpu_data_master_requests_DM9000A_avalonS,
      cpu_data_master_requests_audio_avalon_slave_0 => cpu_data_master_requests_audio_avalon_slave_0,
      cpu_data_master_requests_cpu_jtag_debug_module => cpu_data_master_requests_cpu_jtag_debug_module,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_ps2_s1 => cpu_data_master_requests_ps2_s1,
      cpu_data_master_requests_raster_avalon_slave_0 => cpu_data_master_requests_raster_avalon_slave_0,
      cpu_data_master_requests_sram_avalon_slave_0 => cpu_data_master_requests_sram_avalon_slave_0,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_DM9000A_avalonS_end_xfer => d1_DM9000A_avalonS_end_xfer,
      d1_audio_avalon_slave_0_end_xfer => d1_audio_avalon_slave_0_end_xfer,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      d1_ps2_s1_end_xfer => d1_ps2_s1_end_xfer,
      d1_raster_avalon_slave_0_end_xfer => d1_raster_avalon_slave_0_end_xfer,
      d1_sram_avalon_slave_0_end_xfer => d1_sram_avalon_slave_0_end_xfer,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      ps2_s1_readdata_from_sa => ps2_s1_readdata_from_sa,
      raster_avalon_slave_0_readdata_from_sa => raster_avalon_slave_0_readdata_from_sa,
      reset_n => clk_reset_n,
      sram_avalon_slave_0_readdata_from_sa => sram_avalon_slave_0_readdata_from_sa
    );


  --the_cpu_instruction_master, which is an e_instance
  the_cpu_instruction_master : cpu_instruction_master_arbitrator
    port map(
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_dbs_address => cpu_instruction_master_dbs_address,
      cpu_instruction_master_readdata => cpu_instruction_master_readdata,
      cpu_instruction_master_waitrequest => cpu_instruction_master_waitrequest,
      clk => clk,
      cpu_instruction_master_address => cpu_instruction_master_address,
      cpu_instruction_master_granted_cpu_jtag_debug_module => cpu_instruction_master_granted_cpu_jtag_debug_module,
      cpu_instruction_master_granted_sram_avalon_slave_0 => cpu_instruction_master_granted_sram_avalon_slave_0,
      cpu_instruction_master_qualified_request_cpu_jtag_debug_module => cpu_instruction_master_qualified_request_cpu_jtag_debug_module,
      cpu_instruction_master_qualified_request_sram_avalon_slave_0 => cpu_instruction_master_qualified_request_sram_avalon_slave_0,
      cpu_instruction_master_read => cpu_instruction_master_read,
      cpu_instruction_master_read_data_valid_cpu_jtag_debug_module => cpu_instruction_master_read_data_valid_cpu_jtag_debug_module,
      cpu_instruction_master_read_data_valid_sram_avalon_slave_0 => cpu_instruction_master_read_data_valid_sram_avalon_slave_0,
      cpu_instruction_master_requests_cpu_jtag_debug_module => cpu_instruction_master_requests_cpu_jtag_debug_module,
      cpu_instruction_master_requests_sram_avalon_slave_0 => cpu_instruction_master_requests_sram_avalon_slave_0,
      cpu_jtag_debug_module_readdata_from_sa => cpu_jtag_debug_module_readdata_from_sa,
      d1_cpu_jtag_debug_module_end_xfer => d1_cpu_jtag_debug_module_end_xfer,
      d1_sram_avalon_slave_0_end_xfer => d1_sram_avalon_slave_0_end_xfer,
      reset_n => clk_reset_n,
      sram_avalon_slave_0_readdata_from_sa => sram_avalon_slave_0_readdata_from_sa
    );


  --the_cpu, which is an e_ptf_instance
  the_cpu : cpu
    port map(
      d_address => cpu_data_master_address,
      d_byteenable => cpu_data_master_byteenable,
      d_read => cpu_data_master_read,
      d_write => cpu_data_master_write,
      d_writedata => cpu_data_master_writedata,
      i_address => cpu_instruction_master_address,
      i_read => cpu_instruction_master_read,
      jtag_debug_module_debugaccess_to_roms => cpu_data_master_debugaccess,
      jtag_debug_module_readdata => cpu_jtag_debug_module_readdata,
      jtag_debug_module_resetrequest => cpu_jtag_debug_module_resetrequest,
      clk => clk,
      d_irq => cpu_data_master_irq,
      d_readdata => cpu_data_master_readdata,
      d_waitrequest => cpu_data_master_waitrequest,
      i_readdata => cpu_instruction_master_readdata,
      i_waitrequest => cpu_instruction_master_waitrequest,
      jtag_debug_module_address => cpu_jtag_debug_module_address,
      jtag_debug_module_begintransfer => cpu_jtag_debug_module_begintransfer,
      jtag_debug_module_byteenable => cpu_jtag_debug_module_byteenable,
      jtag_debug_module_clk => clk,
      jtag_debug_module_debugaccess => cpu_jtag_debug_module_debugaccess,
      jtag_debug_module_reset => cpu_jtag_debug_module_reset,
      jtag_debug_module_select => cpu_jtag_debug_module_chipselect,
      jtag_debug_module_write => cpu_jtag_debug_module_write,
      jtag_debug_module_writedata => cpu_jtag_debug_module_writedata,
      reset_n => cpu_jtag_debug_module_reset_n
    );


  --the_jtag_uart_avalon_jtag_slave, which is an e_instance
  the_jtag_uart_avalon_jtag_slave : jtag_uart_avalon_jtag_slave_arbitrator
    port map(
      cpu_data_master_granted_jtag_uart_avalon_jtag_slave => cpu_data_master_granted_jtag_uart_avalon_jtag_slave,
      cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave => cpu_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
      cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave => cpu_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
      cpu_data_master_requests_jtag_uart_avalon_jtag_slave => cpu_data_master_requests_jtag_uart_avalon_jtag_slave,
      d1_jtag_uart_avalon_jtag_slave_end_xfer => d1_jtag_uart_avalon_jtag_slave_end_xfer,
      jtag_uart_avalon_jtag_slave_address => jtag_uart_avalon_jtag_slave_address,
      jtag_uart_avalon_jtag_slave_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      jtag_uart_avalon_jtag_slave_dataavailable_from_sa => jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
      jtag_uart_avalon_jtag_slave_irq_from_sa => jtag_uart_avalon_jtag_slave_irq_from_sa,
      jtag_uart_avalon_jtag_slave_read_n => jtag_uart_avalon_jtag_slave_read_n,
      jtag_uart_avalon_jtag_slave_readdata_from_sa => jtag_uart_avalon_jtag_slave_readdata_from_sa,
      jtag_uart_avalon_jtag_slave_readyfordata_from_sa => jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
      jtag_uart_avalon_jtag_slave_reset_n => jtag_uart_avalon_jtag_slave_reset_n,
      jtag_uart_avalon_jtag_slave_waitrequest_from_sa => jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
      jtag_uart_avalon_jtag_slave_write_n => jtag_uart_avalon_jtag_slave_write_n,
      jtag_uart_avalon_jtag_slave_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_data_master_writedata => cpu_data_master_writedata,
      jtag_uart_avalon_jtag_slave_dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      jtag_uart_avalon_jtag_slave_irq => jtag_uart_avalon_jtag_slave_irq,
      jtag_uart_avalon_jtag_slave_readdata => jtag_uart_avalon_jtag_slave_readdata,
      jtag_uart_avalon_jtag_slave_readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      jtag_uart_avalon_jtag_slave_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      reset_n => clk_reset_n
    );


  --the_jtag_uart, which is an e_ptf_instance
  the_jtag_uart : jtag_uart
    port map(
      av_irq => jtag_uart_avalon_jtag_slave_irq,
      av_readdata => jtag_uart_avalon_jtag_slave_readdata,
      av_waitrequest => jtag_uart_avalon_jtag_slave_waitrequest,
      dataavailable => jtag_uart_avalon_jtag_slave_dataavailable,
      readyfordata => jtag_uart_avalon_jtag_slave_readyfordata,
      av_address => jtag_uart_avalon_jtag_slave_address,
      av_chipselect => jtag_uart_avalon_jtag_slave_chipselect,
      av_read_n => jtag_uart_avalon_jtag_slave_read_n,
      av_write_n => jtag_uart_avalon_jtag_slave_write_n,
      av_writedata => jtag_uart_avalon_jtag_slave_writedata,
      clk => clk,
      rst_n => jtag_uart_avalon_jtag_slave_reset_n
    );


  --the_ps2_s1, which is an e_instance
  the_ps2_s1 : ps2_s1_arbitrator
    port map(
      cpu_data_master_granted_ps2_s1 => cpu_data_master_granted_ps2_s1,
      cpu_data_master_qualified_request_ps2_s1 => cpu_data_master_qualified_request_ps2_s1,
      cpu_data_master_read_data_valid_ps2_s1 => cpu_data_master_read_data_valid_ps2_s1,
      cpu_data_master_requests_ps2_s1 => cpu_data_master_requests_ps2_s1,
      d1_ps2_s1_end_xfer => d1_ps2_s1_end_xfer,
      ps2_s1_address => ps2_s1_address,
      ps2_s1_chipselect => ps2_s1_chipselect,
      ps2_s1_read => ps2_s1_read,
      ps2_s1_readdata_from_sa => ps2_s1_readdata_from_sa,
      ps2_s1_reset => ps2_s1_reset,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_write => cpu_data_master_write,
      ps2_s1_readdata => ps2_s1_readdata,
      reset_n => clk_reset_n
    );


  --the_ps2, which is an e_ptf_instance
  the_ps2 : ps2
    port map(
      avs_s1_readdata => ps2_s1_readdata,
      PS2_Clk => PS2_Clk_to_the_ps2,
      PS2_Data => PS2_Data_to_the_ps2,
      avs_s1_address => ps2_s1_address,
      avs_s1_chipselect => ps2_s1_chipselect,
      avs_s1_clk => clk,
      avs_s1_read => ps2_s1_read,
      avs_s1_reset => ps2_s1_reset
    );


  --the_raster_avalon_slave_0, which is an e_instance
  the_raster_avalon_slave_0 : raster_avalon_slave_0_arbitrator
    port map(
      cpu_data_master_byteenable_raster_avalon_slave_0 => cpu_data_master_byteenable_raster_avalon_slave_0,
      cpu_data_master_granted_raster_avalon_slave_0 => cpu_data_master_granted_raster_avalon_slave_0,
      cpu_data_master_qualified_request_raster_avalon_slave_0 => cpu_data_master_qualified_request_raster_avalon_slave_0,
      cpu_data_master_read_data_valid_raster_avalon_slave_0 => cpu_data_master_read_data_valid_raster_avalon_slave_0,
      cpu_data_master_requests_raster_avalon_slave_0 => cpu_data_master_requests_raster_avalon_slave_0,
      d1_raster_avalon_slave_0_end_xfer => d1_raster_avalon_slave_0_end_xfer,
      raster_avalon_slave_0_address => raster_avalon_slave_0_address,
      raster_avalon_slave_0_chipselect => raster_avalon_slave_0_chipselect,
      raster_avalon_slave_0_read => raster_avalon_slave_0_read,
      raster_avalon_slave_0_readdata_from_sa => raster_avalon_slave_0_readdata_from_sa,
      raster_avalon_slave_0_reset => raster_avalon_slave_0_reset,
      raster_avalon_slave_0_write => raster_avalon_slave_0_write,
      raster_avalon_slave_0_writedata => raster_avalon_slave_0_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_dbs_address => cpu_data_master_dbs_address,
      cpu_data_master_dbs_write_16 => cpu_data_master_dbs_write_16,
      cpu_data_master_no_byte_enables_and_last_term => cpu_data_master_no_byte_enables_and_last_term,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      raster_avalon_slave_0_readdata => raster_avalon_slave_0_readdata,
      reset_n => clk_reset_n
    );


  --the_raster, which is an e_ptf_instance
  the_raster : raster
    port map(
      VGA_B => internal_VGA_B_from_the_raster,
      VGA_BLANK => internal_VGA_BLANK_from_the_raster,
      VGA_CLK => internal_VGA_CLK_from_the_raster,
      VGA_G => internal_VGA_G_from_the_raster,
      VGA_HS => internal_VGA_HS_from_the_raster,
      VGA_R => internal_VGA_R_from_the_raster,
      VGA_SYNC => internal_VGA_SYNC_from_the_raster,
      VGA_VS => internal_VGA_VS_from_the_raster,
      readdata => raster_avalon_slave_0_readdata,
      address => raster_avalon_slave_0_address,
      chipselect => raster_avalon_slave_0_chipselect,
      clk => clk,
      read => raster_avalon_slave_0_read,
      reset => raster_avalon_slave_0_reset,
      write => raster_avalon_slave_0_write,
      writedata => raster_avalon_slave_0_writedata
    );


  --the_sram_avalon_slave_0, which is an e_instance
  the_sram_avalon_slave_0 : sram_avalon_slave_0_arbitrator
    port map(
      cpu_data_master_byteenable_sram_avalon_slave_0 => cpu_data_master_byteenable_sram_avalon_slave_0,
      cpu_data_master_granted_sram_avalon_slave_0 => cpu_data_master_granted_sram_avalon_slave_0,
      cpu_data_master_qualified_request_sram_avalon_slave_0 => cpu_data_master_qualified_request_sram_avalon_slave_0,
      cpu_data_master_read_data_valid_sram_avalon_slave_0 => cpu_data_master_read_data_valid_sram_avalon_slave_0,
      cpu_data_master_requests_sram_avalon_slave_0 => cpu_data_master_requests_sram_avalon_slave_0,
      cpu_instruction_master_granted_sram_avalon_slave_0 => cpu_instruction_master_granted_sram_avalon_slave_0,
      cpu_instruction_master_qualified_request_sram_avalon_slave_0 => cpu_instruction_master_qualified_request_sram_avalon_slave_0,
      cpu_instruction_master_read_data_valid_sram_avalon_slave_0 => cpu_instruction_master_read_data_valid_sram_avalon_slave_0,
      cpu_instruction_master_requests_sram_avalon_slave_0 => cpu_instruction_master_requests_sram_avalon_slave_0,
      d1_sram_avalon_slave_0_end_xfer => d1_sram_avalon_slave_0_end_xfer,
      sram_avalon_slave_0_address => sram_avalon_slave_0_address,
      sram_avalon_slave_0_byteenable => sram_avalon_slave_0_byteenable,
      sram_avalon_slave_0_chipselect => sram_avalon_slave_0_chipselect,
      sram_avalon_slave_0_read => sram_avalon_slave_0_read,
      sram_avalon_slave_0_readdata_from_sa => sram_avalon_slave_0_readdata_from_sa,
      sram_avalon_slave_0_write => sram_avalon_slave_0_write,
      sram_avalon_slave_0_writedata => sram_avalon_slave_0_writedata,
      clk => clk,
      cpu_data_master_address_to_slave => cpu_data_master_address_to_slave,
      cpu_data_master_byteenable => cpu_data_master_byteenable,
      cpu_data_master_dbs_address => cpu_data_master_dbs_address,
      cpu_data_master_dbs_write_16 => cpu_data_master_dbs_write_16,
      cpu_data_master_no_byte_enables_and_last_term => cpu_data_master_no_byte_enables_and_last_term,
      cpu_data_master_read => cpu_data_master_read,
      cpu_data_master_waitrequest => cpu_data_master_waitrequest,
      cpu_data_master_write => cpu_data_master_write,
      cpu_instruction_master_address_to_slave => cpu_instruction_master_address_to_slave,
      cpu_instruction_master_dbs_address => cpu_instruction_master_dbs_address,
      cpu_instruction_master_read => cpu_instruction_master_read,
      reset_n => clk_reset_n,
      sram_avalon_slave_0_readdata => sram_avalon_slave_0_readdata
    );


  --the_sram, which is an e_ptf_instance
  the_sram : sram
    port map(
      SRAM_ADDR => internal_SRAM_ADDR_from_the_sram,
      SRAM_CE_N => internal_SRAM_CE_N_from_the_sram,
      SRAM_DQ => SRAM_DQ_to_and_from_the_sram,
      SRAM_LB_N => internal_SRAM_LB_N_from_the_sram,
      SRAM_OE_N => internal_SRAM_OE_N_from_the_sram,
      SRAM_UB_N => internal_SRAM_UB_N_from_the_sram,
      SRAM_WE_N => internal_SRAM_WE_N_from_the_sram,
      readdata => sram_avalon_slave_0_readdata,
      address => sram_avalon_slave_0_address,
      byteenable => sram_avalon_slave_0_byteenable,
      chipselect => sram_avalon_slave_0_chipselect,
      read => sram_avalon_slave_0_read,
      write => sram_avalon_slave_0_write,
      writedata => sram_avalon_slave_0_writedata
    );


  --reset is asserted asynchronously and deasserted synchronously
  nios_system_reset_clk_domain_synch : nios_system_reset_clk_domain_synch_module
    port map(
      data_out => clk_reset_n,
      clk => clk,
      data_in => module_input,
      reset_n => reset_n_sources
    );

  module_input <= std_logic'('1');

  --reset sources mux, which is an e_mux
  reset_n_sources <= Vector_To_Std_Logic(NOT (((((std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(NOT reset_n))) OR std_logic_vector'("00000000000000000000000000000000")) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa)))) OR (std_logic_vector'("0000000000000000000000000000000") & (A_TOSTDLOGICVECTOR(cpu_jtag_debug_module_resetrequest_from_sa))))));
  --vhdl renameroo for output signals
  AUD_ADCLRCK_from_the_audio <= internal_AUD_ADCLRCK_from_the_audio;
  --vhdl renameroo for output signals
  AUD_DACDAT_from_the_audio <= internal_AUD_DACDAT_from_the_audio;
  --vhdl renameroo for output signals
  AUD_DACLRCK_from_the_audio <= internal_AUD_DACLRCK_from_the_audio;
  --vhdl renameroo for output signals
  ENET_CMD_from_the_DM9000A <= internal_ENET_CMD_from_the_DM9000A;
  --vhdl renameroo for output signals
  ENET_CS_N_from_the_DM9000A <= internal_ENET_CS_N_from_the_DM9000A;
  --vhdl renameroo for output signals
  ENET_RD_N_from_the_DM9000A <= internal_ENET_RD_N_from_the_DM9000A;
  --vhdl renameroo for output signals
  ENET_RST_N_from_the_DM9000A <= internal_ENET_RST_N_from_the_DM9000A;
  --vhdl renameroo for output signals
  ENET_WR_N_from_the_DM9000A <= internal_ENET_WR_N_from_the_DM9000A;
  --vhdl renameroo for output signals
  SRAM_ADDR_from_the_sram <= internal_SRAM_ADDR_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_CE_N_from_the_sram <= internal_SRAM_CE_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_LB_N_from_the_sram <= internal_SRAM_LB_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_OE_N_from_the_sram <= internal_SRAM_OE_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_UB_N_from_the_sram <= internal_SRAM_UB_N_from_the_sram;
  --vhdl renameroo for output signals
  SRAM_WE_N_from_the_sram <= internal_SRAM_WE_N_from_the_sram;
  --vhdl renameroo for output signals
  VGA_BLANK_from_the_raster <= internal_VGA_BLANK_from_the_raster;
  --vhdl renameroo for output signals
  VGA_B_from_the_raster <= internal_VGA_B_from_the_raster;
  --vhdl renameroo for output signals
  VGA_CLK_from_the_raster <= internal_VGA_CLK_from_the_raster;
  --vhdl renameroo for output signals
  VGA_G_from_the_raster <= internal_VGA_G_from_the_raster;
  --vhdl renameroo for output signals
  VGA_HS_from_the_raster <= internal_VGA_HS_from_the_raster;
  --vhdl renameroo for output signals
  VGA_R_from_the_raster <= internal_VGA_R_from_the_raster;
  --vhdl renameroo for output signals
  VGA_SYNC_from_the_raster <= internal_VGA_SYNC_from_the_raster;
  --vhdl renameroo for output signals
  VGA_VS_from_the_raster <= internal_VGA_VS_from_the_raster;
  --vhdl renameroo for output signals
  audio_request_from_the_audio <= internal_audio_request_from_the_audio;

end europa;


--synthesis translate_off

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;



-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your libraries here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>

entity test_bench is 
end entity test_bench;


architecture europa of test_bench is
component nios_system is 
           port (
                 -- 1) global signals:
                    signal clk : IN STD_LOGIC;
                    signal reset_n : IN STD_LOGIC;

                 -- the_DM9000A
                    signal ENET_CMD_from_the_DM9000A : OUT STD_LOGIC;
                    signal ENET_CS_N_from_the_DM9000A : OUT STD_LOGIC;
                    signal ENET_DATA_to_and_from_the_DM9000A : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal ENET_INT_to_the_DM9000A : IN STD_LOGIC;
                    signal ENET_RD_N_from_the_DM9000A : OUT STD_LOGIC;
                    signal ENET_RST_N_from_the_DM9000A : OUT STD_LOGIC;
                    signal ENET_WR_N_from_the_DM9000A : OUT STD_LOGIC;

                 -- the_audio
                    signal AUD_ADCDAT_to_the_audio : IN STD_LOGIC;
                    signal AUD_ADCLRCK_from_the_audio : OUT STD_LOGIC;
                    signal AUD_BCLK_to_and_from_the_audio : INOUT STD_LOGIC;
                    signal AUD_DACDAT_from_the_audio : OUT STD_LOGIC;
                    signal AUD_DACLRCK_from_the_audio : OUT STD_LOGIC;
                    signal audio_request_from_the_audio : OUT STD_LOGIC;
                    signal data_to_the_audio : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal test_mode_to_the_audio : IN STD_LOGIC;

                 -- the_ps2
                    signal PS2_Clk_to_the_ps2 : IN STD_LOGIC;
                    signal PS2_Data_to_the_ps2 : IN STD_LOGIC;

                 -- the_raster
                    signal VGA_BLANK_from_the_raster : OUT STD_LOGIC;
                    signal VGA_B_from_the_raster : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_CLK_from_the_raster : OUT STD_LOGIC;
                    signal VGA_G_from_the_raster : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_HS_from_the_raster : OUT STD_LOGIC;
                    signal VGA_R_from_the_raster : OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
                    signal VGA_SYNC_from_the_raster : OUT STD_LOGIC;
                    signal VGA_VS_from_the_raster : OUT STD_LOGIC;

                 -- the_sram
                    signal SRAM_ADDR_from_the_sram : OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
                    signal SRAM_CE_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_DQ_to_and_from_the_sram : INOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal SRAM_LB_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_OE_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_UB_N_from_the_sram : OUT STD_LOGIC;
                    signal SRAM_WE_N_from_the_sram : OUT STD_LOGIC
                 );
end component nios_system;

                signal AUD_ADCDAT_to_the_audio :  STD_LOGIC;
                signal AUD_ADCLRCK_from_the_audio :  STD_LOGIC;
                signal AUD_BCLK_to_and_from_the_audio :  STD_LOGIC;
                signal AUD_DACDAT_from_the_audio :  STD_LOGIC;
                signal AUD_DACLRCK_from_the_audio :  STD_LOGIC;
                signal ENET_CMD_from_the_DM9000A :  STD_LOGIC;
                signal ENET_CS_N_from_the_DM9000A :  STD_LOGIC;
                signal ENET_DATA_to_and_from_the_DM9000A :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal ENET_INT_to_the_DM9000A :  STD_LOGIC;
                signal ENET_RD_N_from_the_DM9000A :  STD_LOGIC;
                signal ENET_RST_N_from_the_DM9000A :  STD_LOGIC;
                signal ENET_WR_N_from_the_DM9000A :  STD_LOGIC;
                signal PS2_Clk_to_the_ps2 :  STD_LOGIC;
                signal PS2_Data_to_the_ps2 :  STD_LOGIC;
                signal SRAM_ADDR_from_the_sram :  STD_LOGIC_VECTOR (17 DOWNTO 0);
                signal SRAM_CE_N_from_the_sram :  STD_LOGIC;
                signal SRAM_DQ_to_and_from_the_sram :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal SRAM_LB_N_from_the_sram :  STD_LOGIC;
                signal SRAM_OE_N_from_the_sram :  STD_LOGIC;
                signal SRAM_UB_N_from_the_sram :  STD_LOGIC;
                signal SRAM_WE_N_from_the_sram :  STD_LOGIC;
                signal VGA_BLANK_from_the_raster :  STD_LOGIC;
                signal VGA_B_from_the_raster :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal VGA_CLK_from_the_raster :  STD_LOGIC;
                signal VGA_G_from_the_raster :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal VGA_HS_from_the_raster :  STD_LOGIC;
                signal VGA_R_from_the_raster :  STD_LOGIC_VECTOR (9 DOWNTO 0);
                signal VGA_SYNC_from_the_raster :  STD_LOGIC;
                signal VGA_VS_from_the_raster :  STD_LOGIC;
                signal audio_request_from_the_audio :  STD_LOGIC;
                signal clk :  STD_LOGIC;
                signal data_to_the_audio :  STD_LOGIC_VECTOR (15 DOWNTO 0);
                signal jtag_uart_avalon_jtag_slave_dataavailable_from_sa :  STD_LOGIC;
                signal jtag_uart_avalon_jtag_slave_readyfordata_from_sa :  STD_LOGIC;
                signal reset_n :  STD_LOGIC;
                signal test_mode_to_the_audio :  STD_LOGIC;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add your component and signal declaration here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


begin

  --Set us up the Dut
  DUT : nios_system
    port map(
      AUD_ADCLRCK_from_the_audio => AUD_ADCLRCK_from_the_audio,
      AUD_BCLK_to_and_from_the_audio => AUD_BCLK_to_and_from_the_audio,
      AUD_DACDAT_from_the_audio => AUD_DACDAT_from_the_audio,
      AUD_DACLRCK_from_the_audio => AUD_DACLRCK_from_the_audio,
      ENET_CMD_from_the_DM9000A => ENET_CMD_from_the_DM9000A,
      ENET_CS_N_from_the_DM9000A => ENET_CS_N_from_the_DM9000A,
      ENET_DATA_to_and_from_the_DM9000A => ENET_DATA_to_and_from_the_DM9000A,
      ENET_RD_N_from_the_DM9000A => ENET_RD_N_from_the_DM9000A,
      ENET_RST_N_from_the_DM9000A => ENET_RST_N_from_the_DM9000A,
      ENET_WR_N_from_the_DM9000A => ENET_WR_N_from_the_DM9000A,
      SRAM_ADDR_from_the_sram => SRAM_ADDR_from_the_sram,
      SRAM_CE_N_from_the_sram => SRAM_CE_N_from_the_sram,
      SRAM_DQ_to_and_from_the_sram => SRAM_DQ_to_and_from_the_sram,
      SRAM_LB_N_from_the_sram => SRAM_LB_N_from_the_sram,
      SRAM_OE_N_from_the_sram => SRAM_OE_N_from_the_sram,
      SRAM_UB_N_from_the_sram => SRAM_UB_N_from_the_sram,
      SRAM_WE_N_from_the_sram => SRAM_WE_N_from_the_sram,
      VGA_BLANK_from_the_raster => VGA_BLANK_from_the_raster,
      VGA_B_from_the_raster => VGA_B_from_the_raster,
      VGA_CLK_from_the_raster => VGA_CLK_from_the_raster,
      VGA_G_from_the_raster => VGA_G_from_the_raster,
      VGA_HS_from_the_raster => VGA_HS_from_the_raster,
      VGA_R_from_the_raster => VGA_R_from_the_raster,
      VGA_SYNC_from_the_raster => VGA_SYNC_from_the_raster,
      VGA_VS_from_the_raster => VGA_VS_from_the_raster,
      audio_request_from_the_audio => audio_request_from_the_audio,
      AUD_ADCDAT_to_the_audio => AUD_ADCDAT_to_the_audio,
      ENET_INT_to_the_DM9000A => ENET_INT_to_the_DM9000A,
      PS2_Clk_to_the_ps2 => PS2_Clk_to_the_ps2,
      PS2_Data_to_the_ps2 => PS2_Data_to_the_ps2,
      clk => clk,
      data_to_the_audio => data_to_the_audio,
      reset_n => reset_n,
      test_mode_to_the_audio => test_mode_to_the_audio
    );


  process
  begin
    clk <= '0';
    loop
       wait for 10 ns;
       clk <= not clk;
    end loop;
  end process;
  PROCESS
    BEGIN
       reset_n <= '0';
       wait for 200 ns;
       reset_n <= '1'; 
    WAIT;
  END PROCESS;


-- <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
--add additional architecture here
-- AND HERE WILL BE PRESERVED </ALTERA_NOTE>


end europa;



--synthesis translate_on
