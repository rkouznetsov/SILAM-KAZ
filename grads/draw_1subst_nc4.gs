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

Only2D="TRUE"

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
*   'set mpt 4 4 1 0.5'
   'set xlab off'
   'set ylab off'
else
   'set mpdset lores'
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


*Use only 10 clevs
nclevs=10 
if (scale_type = 'log')
   lev.1 = 0.1 * scale_legend
   lev.2 = 0.2 * scale_legend 
   lev.3 = 0.4  * scale_legend
   lev.4 = 0.8  * scale_legend
   lev.5 = 1.5  * scale_legend
   lev.6 = 2.5  * scale_legend
   lev.7 = 4  * scale_legend
   lev.8 = 7  * scale_legend
   lev.9 = 15  * scale_legend
   lev.10 = 25 * scale_legend
   lev.11 = 40  * scale_legend
   lev.12 = 70  * scale_legend
   lev.13 = 150  * scale_legend
   lev.14 = 250 * scale_legend
   lev.15 = 400  * scale_legend
   lev.16 = 700  * scale_legend
   lev.17 = 1500  * scale_legend
   lev.18 = 2500 * scale_legend
else 
   if (scale_type = 'logcoarse')
      lev.1 = 0.1 * scale_legend
      lev.2 = 0.2 * scale_legend 
      lev.3 = 0.5  * scale_legend
      lev.4 = 1.0  * scale_legend
      lev.5 = 2  * scale_legend
      lev.6 = 5  * scale_legend
      lev.7 = 10  * scale_legend
      lev.8 = 20 * scale_legend
      lev.9 = 50  * scale_legend
      lev.10 = 100 * scale_legend
      lev.11 = 200 * scale_legend
      lev.12 = 500  * scale_legend
      lev.13 = 1000 * scale_legend
      lev.14 = 2000 * scale_legend
      lev.15 = 5000  * scale_legend
      lev.16 = 10000 * scale_legend
      lev.17 = 20000  * scale_legend
      lev.18 = 50000 * scale_legend
   else
      if (scale_type = 'cams')
* Should be used only with offset of 0
         lev.1 = 0 * scale_legend
         lev.2 = 10 * scale_legend 
         lev.3 = 20  * scale_legend
         lev.4 = 30  * scale_legend
         lev.5 = 40  * scale_legend
         lev.6 = 50  * scale_legend
         lev.7 = 60  * scale_legend
         lev.8 = 70 * scale_legend
         lev.9 = 80  * scale_legend
         lev.10 = 90 * scale_legend
         lev.11 = 100 * scale_legend
         lev.12 = 120  * scale_legend
         lev.13 = 150 * scale_legend
         lev.14 = 999 * scale_legend
         nclevs=14
      else
         iTmp = 1
         while(iTmp < 19)
           lev.iTmp = iTmp * scale_legend
           iTmp = iTmp + 1
         endwhile
      endif
   endif
endif
iTmp = scale_offset + 1
clevs='set clevs'
while(iTmp <= scale_offset + nclevs)
  clevs = clevs % ' ' %  lev.iTmp
  iTmp = iTmp + 1
endwhile
*say clevs



*if (scale_type = 'log')
*   lev1 = 0.1 * scale_legend
*   lev2 = 0.2 * scale_legend 
*   lev3 = 0.4  * scale_legend
*   lev4 = 0.8  * scale_legend
*   lev5 = 1.5  * scale_legend
*   lev6 = 2.5  * scale_legend
*   lev7 = 4  * scale_legend
*   lev8 = 7  * scale_legend
*   lev9 = 15  * scale_legend
*   lev10 = 25 * scale_legend
*else 
*   if (scale_type = 'logcoarse')
*      lev1 = 0.1 * scale_legend
*      lev2 = 0.2 * scale_legend 
*      lev3 = 0.5  * scale_legend
*      lev4 = 1.0  * scale_legend
*      lev5 = 2  * scale_legend
*      lev6 = 5  * scale_legend
*      lev7 = 10  * scale_legend
*      lev8 = 20 * scale_legend
*      lev9 = 50  * scale_legend
*      lev10 = 100 * scale_legend
*   else
*      lev1 = 1 * scale_legend
*      lev2 = 2 * scale_legend 
*      lev3 = 3  * scale_legend
*      lev4 = 4  * scale_legend
*      lev5 = 5  * scale_legend
*      lev6 = 6  * scale_legend
*      lev7 = 7 * scale_legend
*      lev8 = 8  * scale_legend
*      lev9 = 9  * scale_legend
*      lev10 = 10 * scale_legend
*   endif
*endif
*clevs='set clevs 'lev1' 'lev2' 'lev3' 'lev4' 'lev5' 'lev6' 'lev7' 'lev8' 'lev9' 'lev10

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


* Find the vertical interpolation coefficients. The first level is assumed to be surface.
* 

nlevs = 5
heights.2 = 500
heights.3 = 1000
heights.4 = 3000
heights.5 = 7500

ilev = 2



'q ctlinfo'
* say 'result:'
* say result

iline=1
* Level heights
while (iline<1000)
   zline = sublin(result, iline)
   iline = iline + 1
   if ( subwrd(zline, 1) = 'zdef') 
      break
   endif
endwhile
nlevs_in_ctl = subwrd(zline, 2)
*time
while (iline<2000)
   tline_maybe = sublin(result, iline)
   iline = iline + 1
   if ( subwrd(tline_maybe, 1) = 'tdef')
      break 
   endif
   zline = zline' 'tline_maybe
endwhile


*
*  If  substNm is a variable in the file -- it is not a concentration
*
ifContinue = 1
ifcnc=FALSE
ifdd=FALSE
ifwd=FALSE

while (iline<1500)
   tline = sublin(result, iline)
   if (strlen(tline) < 1)
     if (ifcnc = FALSE) 
       say 'Could not find any variable for 'substNm
       ifContinue = 0
     endif
     break
   endif
   if (substr(tline,1,strlen(substNm)) = substNm)
      break
   endif
   if (substr(tline,1,strlen(substNm)+4) = 'cnc_'substNm)
      ifcnc=TRUE 
   endif
   if (substr(tline,1,strlen(substNm)+3) = 'dd_'substNm)
      ifdd=TRUE 
   endif
   if (substr(tline,1,strlen(substNm)+3) = 'wd_'substNm)
      ifwd=TRUE 
   endif
   
   iline = iline + 1
endwhile

*
* We continue only if the substanse is in the file
*
if(ifContinue = 1)

*
*  Is it 2D or 3D ???
*
  if2D = FALSE
  if (ifcnc = FALSE | Only2D = TRUE)
*   say tline
    if (subwrd(tline, 2) < 2) 
      if2D = TRUE
*     say "2D"
    endif
  endif 
*say 'ifcnc:  'ifcnc'   if2D:  'if2D

  if (if2D = FALSE)
     while (ilev <= nlevs)
       title.ilev = heights.ilev'm'
       ilev2 = 1
       while (ilev2 < nlevs_in_ctl)
         down = subwrd(zline, 3+ilev2)
         up = subwrd(zline, 4+ilev2)
*        say ilev2' 'up' 'down' 'heights.ilev
         if (heights.ilev >= down & heights.ilev < up)
           ind_down.ilev = ilev2
           ind_up.ilev = ilev2+1
           weight_down.ilev = (up-heights.ilev) / (up-down)
           weight_up.ilev = (heights.ilev-down) / (up-down)
*           say 'Level, indices, weights: 'heights.ilev' 'ind_down.ilev' 'ind_up.ilev' 'weight_down.ilev' 'weight_up.ilev
           break
         endif
         ilev2 = ilev2 + 1
       endwhile 
       if (ilev2 = nlevs_in_ctl)
         say 'Failed to set interpolation weights'
         'quit'
       endif 
       ilev = ilev + 1
     endwhile
  endif

  weight_down.1 = 1
  weight_up.1 = 0
  ind_down.1 = 1
  ind_up.1 = 1
  title.1 = 'srf'
*'quit'



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
    while(iLev < nlevs+1)
      'set vpage 0 8.5 10.6 11'
      'set string 1 c '
      'set strsiz 0.15'
      'draw string 4.25 0.1 Forecast for 'substNm'. Last analysis time: 'AnalTimeString
*
*---------------- concentration
*       #xmin xmax ymin ymax
*
      'set vpage 0.25 8.25 3.8 11'

      clevs
      'set grads off'

      IF3PANEL = FALSE
      if (ifcnc = TRUE)
         'd (cnc_'substNm '(z='ind_down.iLev')*'weight_down.iLev' + cnc_'substNm '(z='ind_up.iLev')*'weight_up.iLev') * ' factor
         'cbarn'
         'draw title Concentration, 'massUnit'/m3, 'hhmm''dd

         if(iLev = 1)
*
*--------------- dry deposition
*          
           if (ifdd = TRUE)
             'set vpage 0 4.4 0 4.5'
             'set clevs 0.01 0.02 0.05 0.1 0.2 0.5 1 2 5'
             'set grads off'
             'd dd_'substNm ' * 10 *' factor
             'cbarn'
             'draw title Dry dep. 0.1 'massUnit'/m2sec, 'hhmm''dd
             IF3PANEL = TRUE
           endif
*
*---------------- wet deposition
*
           if (ifwd = TRUE)
             'set vpage 4.1 8.5 0 4.5'
             'set clevs 0.01 0.02 0.05 0.1 0.2 0.5 1 2 5'
             'set grads off'
             'd wd_'substNm ' * ' factor
             'cbarn'
             'draw title Wet dep. 'massUnit'/m2sec, 'hhmm''dd
              IF3PANEL = TRUE
           endif

         endif
        
*
*---- Prepare the picture for image printing
*
*        'set vpage 8 8.05 0 0.05'
*        'd (cnc_'substNm')'
         levnm_out='_'title.iLev

      else
         'd 'gradsvar'*'factor
         'cbarn'
         'draw title 'substNm_out', 'massUnit', 'hhmm''dd

         if (IFLONGLOBAL = TRUE)
           IF3PANEL = TRUE
           'set mproj nps'
           'set vpage 0 4.4 0 4.5'
           'set lat 30 'ymax
           clevs
           'set grads off'
           'd 'gradsvar'*'factor

           'set mproj sps'
           'set vpage 4.1 8.5 0 4.5'
           'set lat 'ymin' -30'
           clevs
           'set grads off'
           'd 'gradsvar'*'factor

* return things back            
           'set mproj latlon'
           'set lat 'ymin' 'ymax
         endif

*        'set vpage 8 8.05 0 0.05'
*        'd 'substNm
         levnm_out=''

      endif
*
*---- Printing itself
*
*     'swap'
      outfname = outDir'/'substNm_out''levnm_out'_'filesuff''math_format('%03.0f',nbr)
       say outfname
      if (IF3PANEL = TRUE )
         'printim 'outfname'.png x800 y1000 white'
      else
*         crop things
         'printim 'outfname'-tmp.png x800 y1000 white'
         '!convert -crop 800x642+0+0 'outfname'-tmp.png 'outfname'.png'
         '!rm 'outfname'-tmp.png'
      endif
       
       
*      say outfname
*  'print'

      'clear'

      if (if2D = TRUE)
         break
      endif

      iLev = iLev + 1
    endwhile

    time=time+1
    nbr = nbr + 1
*say OOOpppppssss
*break 
  endwhile

*'disable print'
endif

*say END

