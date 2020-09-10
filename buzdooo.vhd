Library IEEE;

Use IEEE.std_logic_1164.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_Std.all;

Entity ebuzdolabi is
port(s: in std_logic ;
     sm: in std_logic_vector(1 downto 0);
     et: in std_logic_vector(1 downto 0);
     sv: in std_logic_vector(1 downto 0);
     fet,fsv,fsm,csv,csm,cet:out std_logic;
	 eet,esv,esm:out std_logic;
	 fansm,fansv,fanet:out std_logic);
end ebuzdolabi;

Architecture behv of ebuzdolabi is
Type TDRMLR is (BSL, AZ, ORT, FZL);
signal SMsmd : TDRMLR := ORT ;
signal ETsmd : TDRMLR := BSL ;
signal SVsmd : TDRMLR := BSL ;

--signal ism, iet,isv : integer := 0 ;
signal syc : integer := 0 ;
signal syc2,sn : integer := 0 ;

signal tsv1 : integer := 0 ;
signal tsv2 : integer := 0;

signal tsm1 : integer := 0 ;
signal tsm2 : integer := 0 ;

signal tet1 : integer := 0 ;
signal tet2 : integer := 0 ;

signal chk : std_logic := '0' ;

Type Runtime IS ARRAY(0 TO 3 ) of INTEGER range 1 to 10 ;

Constant a_arraysv: Runtime:=( 1,2,3,4);                     
Constant a_arraysm: Runtime:=( 2,2,3,5);
Constant a_arrayet: Runtime:=( 2,4,5,7);

--array sýrasý sv,sm,et
Begin

Ptime:
process(s)
Begin
	if rising_edge(s) then
		tsv2 <= a_arraysv(to_integer(unsigned(sv)));
--to_integer(unsigned(input_4))
		tsm1 <= tsv2  ;  -- +1
		tsm2 <= tsv2 + a_arraysm(to_integer(unsigned(sm)));

		tet1 <= tsm2  ;  -- +1
		tet2 <= tsm2 + a_arrayet(to_integer(unsigned(et)));
		
	end if;
End process;

--		tsv2 <= a_arraysv(to_integer(unsigned(sv)), 0);
----to_integer(unsigned(input_4))
--		tsm1 <= tsv2 + 1 ;  -- +1
--		tsm2 <= tsv2 + a_arraysm(to_integer(unsigned(sm)), 1);
--
--		tet1 <= tsm2 + 1 ;  -- +1
--		tet2 <= tsm2 + a_arrayet(to_integer(unsigned(et)), 2);

Psayac:
process(s)
Begin
	if rising_edge(s) then
		syc <= syc + 1;
     	if syc = 50000000 then
		--if syc = 10000 then
			chk <= not chk;
			syc <= 0;
			sn <= sn + 1;
		end if;
		if sn = 20 then
			sn <= 0;
		end if;
	end if;
End process;

clsSV:
process(sn)
Begin
     IF(sn >= tsv1 and sn < tsv2)  then --buzdolabý bosken calistirilan sure
			csv <= '1';
			fansv <= '1';
		 Else
			csv <= '0';
			fansv<= '0';		  
		end if;
End process ;	

PSEBZE_MEYVE:
process(chk)
Begin
IF rising_edge(chk) THEN
CASE SMsmd is
	 when BSL =>
	   IF(sm = "00")  then
			fsm <= '0';   -- bu bos oldgnu gostersýn
			esm <= '0';
		Elsif (sm = "01") then
			fsm <= '1';
			esm <= '0';
			SMsmd <= AZ;			
	   Elsif (sm = "10") then
			fsm <= '1';
		    esm <= '0';
			SMsmd <= ORT;
	   Elsif (sm = "11") then
			fsm <= '1';
			esm <= '0';
			SMsmd <= FZL;	   
	    END IF;
	When AZ =>
        IF(sm = "00")  then 
			fsm <= '0';
			esm <= '0';
			SMsmd <= BSL;
		 Elsif (sm = "01") then
			fsm <= '1';
			esm <= '0';
			SMsmd <= ORT;			
		 Elsif (sm = "10") then
			fsm <= '1';
			esm <= '0';
			SMsmd <= FZL;
	 	 Elsif (sm = "11") then
		    fsm <= '1';
			esm <= '1';
			SMsmd <= FZL;
		  END IF;
	When ORT=> 
		IF(sm="00")  then 
			fsm <= '0';
			esm <='0';
			SMsmd <= AZ;
		 Elsif (sm="01") then
			fsm <= '1';
			esm <='0';
			SMsmd <= FZL;			
		 Elsif (sm="10") then
			fsm <= '1';
			esm <='0';
			SMsmd <= FZL;
	 	 Elsif (sm="11") then
		    fsm <= '1';
			esm <= '0';
			SMsmd <= FZL;
		  END IF;
      When FZL=> 
		IF(sm="00")  then 
			fsm <= '0';
			esm <='0';
			SMsmd <= ORT;
		 Elsif (sm="01") then
			fsm <= '1';
			esm <='0';
			SMsmd <= FZL;			
		 Elsif (sm="10") then
			fsm <= '1';
			esm <='0';
			SMsmd <= FZL;
	 	 Elsif (sm="11") then
			fsm <= '1';
			esm <= '1';
			SMsmd <= FZL;
		  END IF;   		  
	END CASE;
	END IF;
End process;

cls_SM:
process(sn)
Begin
--IF falling_edge(sn) THEN
   IF(sn >= tsm1 and sn < tsm2)  then --buzdolabý bosken calistirilan sure
		csm <= '1';
		fansm <= '1';
	Else
		csm <= '0';
		fansm <= '0';
	end if; 
--END IF;
End process ;

pET:
process(chk)
Begin
IF rising_edge(chk) THEN
CASE ETsmd is
	when BSL =>
	   IF(et="00")  then
			fet<= '0';   -- bu bos oldgnu gostersýn
			eet <='0';
	   Elsif (et="01") then
			fet <= '1';
			eet <='0';
			ETsmd <= AZ;
	   Elsif (et="10") then
			fet <= '1';
		    eet <='0';
			ETsmd <= ORT;
	   Elsif (et="11") then
			fet <= '1';
			eet <='0';
			ETsmd <= FZL;	   
	   END IF;   
	When AZ =>
        IF(et="00")  then 
			fet <= '0';
			eet <='0';
			ETsmd <= BSL;
		 Elsif (et="01") then
			fet <= '1';
			eet <='0';
			ETsmd <= ORT;			
		 Elsif (et="10") then
			fet <= '1';
			eet <='0';
			ETsmd <= FZL;
	 	 Elsif (et="11") then
		    fet <= '1';
			eet <= '1';
			ETsmd <= FZL;
	 END IF;
	When ORT=> 
		IF(et="00")  then 
			fet <= '0';
			eet <='0';
			ETsmd <= AZ;
		 Elsif (et="01") then
			fet <= '1';
			eet <='0';
			ETsmd <= FZL;			
		 Elsif (et="10") then
			fet <= '1';
			eet <='0';
			ETsmd <= FZL;
	 	 Elsif (et="11") then
		    fet <= '1';
			eet <= '1';
			ETsmd <= FZL;
		  END IF;
    When FZL=> 
		IF(et="00")  then 
			fet <= '0';
			eet <='0';
			ETsmd <= ORT;
		 Elsif (et="01") then
			fet <= '1';
			eet <='0';
			ETsmd <= FZL;			
		 Elsif (et="10") then
			fet <= '1';
			eet <= '0';
			ETsmd <= FZL;
	 	 Elsif (et="11") then
		    fet <= '1';
			eet <= '1';
			ETsmd <= FZL;
		  END IF;
	END CASE;
	END IF;
End process;

clsET:
process(sn)
Begin
	IF(sn >= tet1 and sn < tet2)  then --buzdolabý bosken calistirilan sure
		cet <= '1';
		fanet <= '1';
	Else
		cet <= '0';
		fanet <= '0';
	end if;
End process ;
  
PSIVI:
process(chk)
Begin
IF rising_edge(chk) THEN
CASE SVsmd is
	when BSL =>
	   IF(sv="00")  then
			fsv <= '0';   -- bu bos oldugnu gostersin
			esv <='0';
	   Elsif (sv="01") then
			fsv <= '1';
			esv <='0';
			SVsmd <= AZ;
	   Elsif (sv="10") then
			fsv <= '1';
		    esv <='0';
			SVsmd <= ORT;
	   Elsif (sv="11") then
			fsv <= '1';
			esv <='1';
			SVsmd <= FZL;	   
	    END IF;
	When AZ =>
        IF(sv="00")  then 
			fsv <= '0';
			esv <='0';
			SVsmd <= BSL;
		 Elsif (sv="01") then
			fsv <= '1';
			esv <='0';
			SVsmd <= ORT;			
		 Elsif (sv="10") then
			fsv <= '1';
			esv <='0';
			SVsmd <= FZL;
	 	 Elsif (sv="11") then
			fsv <= '1';
			esv <= '1';
			SVsmd <= FZL;
		  END IF;
	When ORT=> 
		IF(sv="00")  then 
			fsv <= '0';
			esv <='0';
			SVsmd <= AZ;
		 Elsif (sv="01") then
			fsv <= '1';
			esv <='0';
			SVsmd <= FZL;			
		 Elsif (sv="10") then
			fsv <= '1';
			esv <='0';
			SVsmd <= FZL;
	 	 Elsif (sv="11") then
		    fsv <= '1';
			esv <= '1';
			SVsmd <= FZL;
		  END IF;
    When FZL=> 
		IF(sv="00")  then 
			fsv <= '0';
			esv <='0';
			SVsmd <= ORT;
		 Elsif (sv="01") then
			fsv <= '1';
			esv <='0';
			SVsmd <= FZL;			
		 Elsif (sv="10") then
			fsv <= '1';
			esv <='0';
			SVsmd <= FZL;
	 	 Elsif (sv="11") then
		    fsv <= '1';
			esv <= '1';
			SVsmd <= FZL;
		  END IF;
	END CASE;
	END IF;
End process ;

--clsSV:
--process(sn)
--Begin
--     IF(sn >= tsv1 and sn < tsv2)  then --buzdolabý bosken calistirilan sure
--			csv <= '1';
--          
--    Else
--			csv <= '0';
--				  
--	end if;
--End process ;	

END BEHV;
