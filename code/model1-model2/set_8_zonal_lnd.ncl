load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$DIAG_SHARED/lnd_func.ncl"
load "$WKDIR/variable_master.ncl"
;************************************************
begin
  print ("=========================================")
  print ("Starting:  set_8_zonal_lnd.ncl; zonal tracers")
  print ("Start Time: "+systemfunc("date") )
  print ("=========================================")
  ptmpdir = getenv("PTMPDIR")
  wkdir   = getenv("WKDIR")
  plot_type  = getenv("PLOTTYPE")
  useCommon1 = getenv("UseCommonName_1")
  useCommon2 = getenv("UseCommonName_2")


; the set lists contains two columns of information. This comes into
; NCL as one long string that we need to parse out.
; check for files with only 1 variable

  q = asciiread(wkdir+"/master_set8_zonal_lnd.txt",-1,"string")
  if (dimsizes(q) .eq. 1) then
        tmp = stringtocharacter(q)
        nvars = 1
        scale_type = new(nvars,"string")
        vars       = new(nvars,"string")
        do i=0,nvars-1
                scale_type(i) = charactertostring(tmp(0:12))
                vars(i)       = charactertostring(tmp(16:))
        end do
  else
        tmp = stringtocharacter(asciiread(wkdir+"/master_set8_zonal_lnd.txt",-1,"string"))
        nvars = dimsizes(tmp(:,0))
        scale_type = new(nvars,"string")
        vars       = new(nvars,"string")
        do i=0,nvars-1
                scale_type(i) = charactertostring(tmp(i,0:12))
                vars(i)       = charactertostring(tmp(i,16:))
        end do
  end if
  delete(tmp)
  delete(q)

  seasons = (/"DJF","JJA","MAM","SON","ANN"/)
;*************************************************
; main loop
;*************************************************
  
  do i=0,dimsizes(vars)-1 
    prefix   = new(2,"string")
    useFlag1 = useCommon1 
    useFlag2 = useCommon2 
    if (useFlag1 .eq. "1") then
          name1   = "commonName_1"
    else
          name1   = "caseid_1"
    end if
    if (useFlag2 .eq. "1") then
          name2   = "commonName_2"
    else
          name2   = "caseid_2"
    end if
    name11      = "prefix_1"
    name22      = "prefix_2"
    prefix(0)      = getenv(name11)
    prefix(1)      = getenv(name22)

; loop over seasons

  do n = 0,dimsizes(seasons)-1
      print("Processing season " + seasons(n))
      in1       = addfile(ptmpdir+"/"+prefix(0)+"/"+prefix(0)+"_"+seasons(n)+"_climo.nc","r")
      in2       = addfile(ptmpdir+"/"+prefix(1)+"/"+prefix(1)+"_"+seasons(n)+"_climo.nc","r")
      nlev1      = getfilevardimsizes(in1,"lev")
      lat1       = in1->lat
      lon1       = in1->lon
      time       = in1->time
      nlat1      = dimsizes(lat1)
      nlon1      = dimsizes(lon1)
      nlev2      = getfilevardimsizes(in2,"lev")
      lat2       = in2->lat
      lon2       = in2->lon
      nlat2      = dimsizes(lat2)
      nlon2      = dimsizes(lon2)
      if (nlat1 .ne. nlat2) then
		print("Grid sizes differ! EXITING SET 8.1" + nlat1 + "  vs  " + nlat2)
		exit
      end if
      data = new((/2,nlat1/),"float")
      ; plot = new(2,graphic)
      
   ; *************************
   ; read case 1 model variable
   ; *************************
      if(isfilevar(in1,vars(i)))then
             x   = in1->$vars(i)$
      else
             x 	 = derive_land(vars(i),in1)
      end if
      rank       = dimsizes(dimsizes(x))
      x1  = x

      delete(x)
      if(all(ismissing(x1)))then
          print("case 1 variable "+ vars(i)+ " not found")
          plot_check1 = False
          continue
      else
          plot_check1 = True
      end if

   ; *************************
   ; read case 2 model variable
   ; *************************
      if(isfilevar(in2,vars(i)))then
              x  = in2->$vars(i)$
      else
              x  = derive_land(vars(i),in2)
      end if
      rank       = dimsizes(dimsizes(x))
      x2  = x
      delete(x)

      if(all(ismissing(x2)))then
          print("case 2 variable "+ vars(i)+ " not found")
          plot_check = False
          continue
      else
          plot_check2 = True
      end if

      ; screen for NaNs
      x1 = catchNaN(x1)
      x2 = catchNaN(x2)

      print(" " + vars(i))

      info = var_init(vars(i))
      x1    = scale_var(x1,scale_type(i),info)
      x2    = scale_var(x2,scale_type(i),info)

      x11 = dim_avg_Wrap(x1)
      x22 = dim_avg_Wrap(x2)

; extract years averaged for plotting
    if (isatt(in1,"yrs_averaged")) then
        yrs_ave1 = in1@yrs_averaged
    end if
    if (isatt(in2,"yrs_averaged")) then
        yrs_ave2 = in2@yrs_averaged
    end if

    cases    = new(2,"string")
    cases(0) = getenv(name1)
    cases(1) = getenv(name2)
    cases(0) = cases(0) + " (" + yrs_ave1 + ")"
    cases(1) = cases(1) + " (" + yrs_ave2 + ")"

; calculate zonal values
      if(plot_check1.eq.False)then
	  continue
      else
    	  data(0,:) = x11
    	  data(1,:) = x22
          plat = lat1
          data!0 = "line"
          data!1 = "lat"
          data&lat = plat
      end if
     
;*************************************************
; create plot
;*************************************************
     if(plot_check1.eq.False)then
	  continue
     else
        plot = new(2,graphic)
    	varDiff = data(0,:)
    	varDiff = (/data(0,:)-data(1,:)/)        ; case difference

    	wks = gsn_open_wks(plot_type,wkdir + "set8_zonal_lnd_"+seasons(n) +"_"+vars(i))
   	 
    	pres                       = True
        pres@gsnMaximize           = True                   ; make as large as possible
        pres@gsnPaperOrientation   = "Portrait"
        pres@gsnPanelCenter        = True
        pres@gsnPanelBottom        = 0.15                   ; save space for legend
        pres@gsnPanelRowSpec       = True
        pres@gsnFrame              = False                  ; don't advance yet so add legend
        pres@txString              = seasons(n)

    	res                        = True
        res@gsnDraw                = False                  ; don't advance yet so add legend
        res@gsnFrame               = False                  ; don't advance yet so add legend
    	res@tiXAxisString          = "Latitude"
    	res@tiYAxisString          = x1@units
    	res@xyDashPatterns         = (/0.,16./)          ; solid, dashed
    	res@xyLineThicknesses      = (/2.,2./)
    	res@xyLineColors           = (/"red","blue"/)
	
    	res@pmLegendDisplayMode    = "Never"
    	res@pmLegendSide           = "Bottom"            
    	res@pmLegendParallelPosF   = 0.50           
    	res@pmLegendOrthogonalPosF = 0.02              
    	res@pmLegendWidthF         = 0.25             
    	res@pmLegendHeightF        = 0.08 
    	res@lgLabelFontHeightF     = 0.020
    	res@lgPerimOn              = True
    	res@xyExplicitLegendLabels = cases
    	res@tmXBMinorOn            = False
    	res@tiMainString           = x1@long_name

        lgres                       = True                   ; allow legend resources
        lgres@lgLineColors          = res@xyLineColors       ; set these equal to those
        lgres@lgPerimOn             = True
        lgres@lgDashIndexes         = res@xyDashPatterns     ; ditto
        lgres@lgLabelFontHeightF    = 0.040                  ; increase font height
        lgres@lgLineLabelStrings    = (/"",""/)              ; no labels in lines
        lgres@lgAutoManage          = False                  ; must have to adjust fonts
        lgres@vpWidthF              = 0.35
        lgres@vpHeightF             = 0.10

    	plot(0) = gsn_csm_xy(wks,plat,data,res)   
    	res@tiMainString           = "Difference Plot"
	delete(res@xyLineColors)
    	res@xyLineColors           = (/"black"/)
    	plot(1) = gsn_csm_xy(wks,plat,varDiff,res)   

        gsn_panel(wks,plot,(/1,2/),pres)               ; draw panel plot
        gsn_legend_ndc(wks,2,cases,0.35,0.12,lgres)    ; draw common legend    MAY HAVE TO ADJUST Y

	frame(wks)
    	delete(x1)
    	delete(x2)
    	delete(x11)
    	delete(x22)
    	delete(plot)
    	delete(cases)
    	delete(data)
    	delete(res)
    end if	; plot_check loop   
   end do   	; end seasons loop
  end do   	; end variable plot
  ; remove error file if program completes successfully.  
  filo  = wkdir +"/set8_zonal_lnd_error_file"                   
  system("/bin/rm -f " + filo)  
end
