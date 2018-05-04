clear all
set more off
use "C:\Users\ap11o\Documents\RESEARCH\FINANCE\dta\sisfin_data.dta" 


************************************************************
************ IDENTIFICACIÓN MICROCREDITOS 2222******************
************************************************************

** microcredo vivienda (construccion) y micro productivo

	capture drop tc1013
	gen tc1013 = (int_rate>10 & int_rate<13) 
	replace tc1013=0 if (sector>1 & sector<5) | sector==6 | (sector>8 & sector <10)| sector==11  | sector >12  
gen hola = .
	** micro comercio o servicios
	capture drop tc2022
	gen tc2022 = (int_rate>19.5 & int_rate<=22.5)
	replace tc2022  = 0 if sector<8 | sector==9 | sector==10| sector ==11 | sector>12 & sector<15 | sector>15

	
	capture drop monto_i
	gen monto_i = cred_monto
	replace monto_i= monto_i*(real(tc)) if tip_planpagos==2



	capture drop aux_micro
	gen aux_micro =  1 if tc1013 ==1 | tc1517 ==1 | tc2022 == 1
	replace aux_micro = 0 if aux_micro==.
	replace aux_micro= 0 if cred_monto<45000 | mplazo<40

	* 5 6 7 8 10 12 15 

	capture drop microcred
	gen microcred = .
	*microviv
	capture drop microviv
	gen microviv = 1 if aux_micro==1 & (sector ==7| sector==12) & (tc1013==1|tc1517==1)
	*microprod
	capture drop microprod
	gen microprod = 1 if aux_micro==1 & (sector== 1 | sector== 5) & (tc1013==1|tc1517==1)
	*microservycom
	capture drop microservycom
	gen microservycom = 1 if aux_micro==1 & (sector == 8 | sector>9) & (tc1013==1|tc2022==1)
	replace microservycom =. if microviv==1 &  microservycom==1
	********************************************************************************

	replace microcred = 1 if microviv==1
	replace microcred = 2 if microprod ==1
	replace microcred = 3 if microservycom ==1

	label define microcred  1 "micro vivienda", modify
	label define microcred  2 "micro produtivo", modify
	label define microcred  3 "micro servicios y comerciio", modify
	label values microcred microcred 



	************************************************************
	************ IDENTIFICACIÓN CREDITOS DE  ******************
	****************** VIVIENDA SOCIAL *************************
	************************************************************


	capture drop vsocial
	gen vsocial = 1 if cuenta_cont == 13130 | cuenta_cont == 13131 | cuenta_cont == 13330 | cuenta_cont == 13331 | cuenta_cont == 13430 
	replace vsocial = 0 if vsocial == . 






