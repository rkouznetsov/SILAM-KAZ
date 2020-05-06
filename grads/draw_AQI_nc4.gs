function prsrm(args)
*
* The function draws stuff from .nc files
*
* 'reinit'
ncFNm = subwrd(args,1)
substNm = subwrd(args,2)
substNm_out = subwrd(args,3)
factor = subwrd(args,4)
massUnit = subwrd(args,5)
AnalTimeString = subwrd(args,6)
colour = subwrd(args,7)
scale_legend = subwrd(args,8)
scale_type = subwrd(args,9)
scale_offset = subwrd(args,10)
outDir = subwrd(args,11)

* Forecast offset in hours of the first record, can be 'daily'
timeOff = subwrd(args,12)

mpdset = subwrd(args,13)

* say "mpdset:" mpdset
if (strlen(mpdset) > 0)
   'set mpdset 'mpdset
*   say result
*        set mpt type color style thickness   
* coaslines+lakes+islands
   'set mpt 1 1 1 1'
* grid dotted
   'set mpt 2 1 5 0.5'
** Inland borders thick dark green
*   'set rgb  250  0  50  0'
**   'set mpt 3 15 1 2'
*   'set mpt 3 250 1 2'
* Thin short dash
   'set mpt 3 1 3 2'
* rivers -- blue 
   'set mpt 4 4 1 0.5'
   'set xlab off'
   'set ylab off'
else
   'set mpdset world_map'
*   say 'mpdset='mpdset',' result
endif




* Hack for retarded grads var name handling
gradsvar=substr(substNm,1,15)

*  say 'ncFNm ' ncFNm
*  say 'substNm 'substNm 
*  say 'substNm_out 'substNm_out 
*  say 'outDir ' outDir
*  say 'AnalTimeString 'AnalTimeString
*  say 'colour 'colour
*  say 'scale_legend 'scale_legend
*  say 'scale_type 'scale_type
*  say 'scale_offset 'scale_offset
*  
*  say 'timeOff ' timeOff

*
*----------------------------------- Open both ctl files and set the drawing size and common title
*
*'set cachesf 100'
* say ncFNm
'sdfopen 'ncFNm
'q file'
*say result
sizeLine = sublin(result,5)
xSize = subwrd(sizeLine,3)
ySize = subwrd(sizeLine,6)
timeSize = subwrd(sizeLine,12)
*'set x 5 'xSize-5
*'set y 5 'ySize-5
* 'set gxout shaded'
'set gxout grfill'
**'set dbuff on'
'run colors.gs 'colour


'set rgb 29 40 130 240'
'set rgb 30 102 229 102'
'set rgb 31 255 240 85'
'set rgb 32 255 187 87'
'set rgb 33 255 68 68'
'set rgb 34 182 70 139'
'set rgb 40 200 200 200'
'set rgb 41 100 100 100'



  title.1 = 'srf'



  'q dims'
  xline = sublin(result, 2)
  xmin=subwrd(xline, 6)
  xmax=subwrd(xline, 8)
  yline = sublin(result,3)
  ymin=subwrd(yline,6)
  ymax=subwrd(yline,8)

  if (xmax - xmin > 355)
   'set lon -180 180'
    IFLONGLOBAL=TRUE
  else
    IFLONGLOBAL=FALSE
  endif
*  say 'IFLONGLOBAL = 'IFLONGLOBAL
*
*--------------------------------- Hourly cycle
*
  time = 1
  if (timeOff = 'daily')
     filesuff='d'
     nbr=1
  else
     filesuff=''
     nbr = timeOff
  endif
  while(time < timeSize+1)
    'set t 'time
    'q dims'
    timeLine = sublin(result,5)
    dateTime = subwrd(timeLine,6)

* No hours for daily files -- less confusion
    if (timeOff = 'daily')
       hhmm= ' ' 
    else
       hhmm = substr(dateTime,1,2)':00'
    endif
    dd = substr(dateTime,strlen(dateTime)-8,strlen(dateTime))
*    say dateTime " " hhmm " " dd 

    iLev =1
      'set vpage 0 8.5 10.6 11'
      'set string 1 c '
      'set strsiz 0.15'
      'draw string 4.25 0.1 Forecast for 'substNm'. Last analysis time: 'AnalTimeString

*
*---------------- concentration
*       #xmin xmax ymin ymax
*
      'set vpage 0.25 8.25 5.25 10.75'

      'set grads off'

      'set clevs  1.5 2.5 3.5 4.5'
      'set rbcols 30 31 32 33 34'

      'd AQI'
      'draw title AQI'
      'ccbar Good Fair Moderate Poor VeryPoor'

      'set vpage 0.25 8.25 0 5.5'
      'set grads off'

*http://cola.gmu.edu/grads/gadoc/colorcontrol.html
  'set clevs 1.5 2.5 3.5 4.5'
  'set rbcols 40 41  3  4  12'

  'd AQISRC'
  'draw title Component responsible for poor AQI'

  'ccbar PM2.5 PM10 NO2 O3 SO2'

        

*
*---- Printing itself
*
      outfname = outDir'/'substNm_out'_'filesuff''math_format('%03.0f',nbr)

     'printim 'outfname'.png x800 y1000 white'
      say 'Making' outfname

      'clear'


    time=time+1
    nbr = nbr + 1
*say OOOpppppssss
*break 
  endwhile


*say END

