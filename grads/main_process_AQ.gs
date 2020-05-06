function drawemep(args)
*
LastAnalStr = subwrd(args,1)
ncFnm = subwrd(args,2)
outDir = subwrd(args,3)
hroff = subwrd(args,4)
mpdset = subwrd(args,5)



drawScr_1subst = "draw_1subst_nc4.gs"

substNm = "PM_FRP_m_17"
factor = "1e9"
massUnit = "ugPM"
*scale_legend = "100 lin 0"
scale_legend = "10.0 log 0"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "CO_gas"
factor = "28e6"
massUnit = "ugCO"
*scale_legend = "100 lin 0"
scale_legend = "1 log 8"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

* say 'main_process_apta.gs called with ncFnm='ncFnm'  outDir='outDir'  hroff' 'mpdset='hroff
substNm = "O3_gas"
factor = "48e6"
massUnit = "ugO3"
scale_legend = "20.0 lin 0"
colour = 'def_lowgrey' 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "BLH"
factor = "1.0"
massUnit = "m" 
scale_legend = "100.0 log 0"
colour = 'def_lowgrey'
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

*
*       SULPHUR, NITROGEN, AMMONIA
*
substNm = "SO2_gas"
factor = "32e6"
scale_legend = "1.0 logcoarse 0"
massUnit = "ugS"
colour = 'def_lowblue'
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

factor = "14e6"
massUnit = "ugN"
substNm = "NO2_gas"
scale_legend = "1.0 logcoarse 0"
colour = 'def_lowblue'
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset


substNm = "NO_gas"
massUnit = "ugN"
factor = "14e6"
scale_legend = "1 logcoarse 0" 
colour = 'def_lowblue'
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

factor = "14e6"
massUnit = "ugN"
substNm = "HNO3_gas"
scale_legend = "0.2  log 0" 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

factor = "14e6"
substNm = "NH3_gas"
scale_legend = "0.5  log 0" 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

 factor = "14e6"
substNm = "PAN_gas"
scale_legend = "0.05 log 0" 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

factor = "30e6"
massUnit = "ugHCHO"
substNm = "HCHO_gas"
scale_legend = "0.2 logcoarse 0" 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

factor = "34e6"
massUnit = "ugH2O2"
substNm = "H2O2_gas"
scale_legend = "0.5 log 0" 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

massUnit = "ugN"
factor = "14e6"
substNm = "HONO_gas"
scale_legend = "0.005 log 0" 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

*factor = "1"
factor = "33e6"
massUnit = "ugHO2"
substNm = "HO2_gas"
scale_legend = "0.001 logcoarse 0" 
'run 'drawScr_1subst' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

'quit'
