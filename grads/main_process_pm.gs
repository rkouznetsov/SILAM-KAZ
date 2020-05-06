function drawemep(args)
LastAnalStr = subwrd(args,1)
PMFNm = subwrd(args,2)
outDir = subwrd(args,3)
hroff = subwrd(args,4)
mpdset = subwrd(args,5)


say PMFNm
say outDir
drawScr_1subst = "draw_1subst_nc4.gs"
drawScr_AQI = "draw_AQI_nc4.gs"
*
*      ... and draw it
*

substNm = "PM2_5"
factor = "1"
massUnit = "ugPM"
scale_legend = "10.0 logcoarse 0"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "PM10"
factor = "1"
massUnit = "ugPM"
scale_legend = "30.0 logcoarse 0"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset
#say 'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset


* substNm = "ocd_gas_w550"
* factor = "1"
* massUnit = "ocd"
* scale_legend = "0.005 lin 0"
* colour = 'def_lowwhite' 
* 'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "ocd_part_w550"
factor = "1"
massUnit = "ocd"
scale_legend = "0.2 log 0"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "ocd_frp_w550"
factor = "1"
massUnit = "ocd"
scale_legend = "0.2 log 0"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "ocd_sslt_w550"
factor = "1"
massUnit = "ocd"
scale_legend = "0.2 log 0"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "ocd_dust_w550"
factor = "1"
massUnit = "ocd"
scale_legend = "0.2 log 0"
colour = 'def_lowwhite' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset
 
* substNm = "ocd_gas_w380"
* factor = "1"
* massUnit = "ocd"
* scale_legend = "0.01 lin 0"
* colour = 'def_lowwhite' 
* 'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset
 
* substNm = "ocd_part_w380"
* factor = "1"
* massUnit = "ocd"
* scale_legend = "0.2 log 0"
* colour = 'def_lowwhite' 
* 'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset
 
* substNm = "ocd_sslt_w380"
* factor = "1"
* massUnit = "ocd"
* scale_legend = "0.2 log 0"
* colour = 'def_lowwhite' 
* 'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset
 
* substNm = "ocd_dust_w380"
* factor = "1"
* massUnit = "ocd"
* scale_legend = "0.2 log 0"
* colour = 'def_lowwhite' 
* 'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset
 
substNm = "O3_column"
factor = "1"
massUnit = "DobsonUnit"
scale_legend = "30.0 lin 4"
colour = 'def_lowblue' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "SO2_column"
factor = "1"
massUnit = "DobsonUnit"
scale_legend = "0.1 log 0"
colour = 'def_lowblue' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "NO2_column"
factor = "1e-15"
massUnit = "1e15molec/cm2"
scale_legend = "2 log 1"
colour = 'def_lowblue' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "O3_tropcol"
substNmOut = "O3_column"
factor = "1"
massUnit = "DobsonUnit"
scale_legend = "1.0 lin 0"
colour = 'def_lowblue' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNmOut' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "SO2_tropcol"
substNmOut = "SO2_column"
factor = "1"
massUnit = "DobsonUnit"
scale_legend = "0.1 log 0"
colour = 'def_lowblue' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNmOut' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

substNm = "NO2_tropcol"
substNmOut = "NO2_column"
factor = "1e-15"
massUnit = "1e15molec/cm2"
scale_legend = "3 log 0"
colour = 'def_lowblue' 
'run 'drawScr_1subst' 'PMFNm' 'substNm' 'substNmOut' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset

*
*  AQI
*


substNm = "AQI"

* These do not matter. Just to keep the same interface
factor = "1"
massUnit = "1"
scale_legend = "10.0 log 0"
colour = 'def_lowwhite' 
'run 'drawScr_AQI' 'ncFnm' 'substNm' 'substNm' 'factor' 'massUnit' 'LastAnalStr' 'colour' 'scale_legend' 'outDir' 'hroff' 'mpdset
'quit'

'quit'

