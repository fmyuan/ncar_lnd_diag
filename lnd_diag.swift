type file;

global string yes = "1";
global string no = "0";

# Read in env variables 
int weightAnnAvg = @toint(@arg("weightAnnAvg"));
int overWriteTrend = @toint(@arg("overWriteTrend"));
int overWriteClimo = @toint(@arg("overWriteClimo"));
string runtype = @arg("RUNTYPE");
string wkdir = @arg("WKDIR");
string ptmpdir = @arg("PTMPDIR");
int local_link = @toint(@arg("LOCAL_LN"));
int localFlag1 = @toint(@arg("LOCAL_FLAG_1"));
int localFlag2 = @toint(@arg("LOCAL_FLAG_2"));
int localFlag1_atm = @toint(@arg("LOCAL_FLAG_atm_1"));
int localFlag2_atm = @toint(@arg("LOCAL_FLAG_atm_2"));
int localFlag1_rtm = @toint(@arg("LOCAL_FLAG_rtm_1"));
int localFlag2_rtm = @toint(@arg("LOCAL_FLAG_rtm_2"));
string local1_dir = @arg("LOCAL_1");
string local2_dir = @arg("LOCAL_2");
string local1_atm_dir = @arg("LOCAL_atm_1");
string local2_atm_dir = @arg("LOCAL_atm_2");
string local1_rtm_dir = @arg("LOCAL_rtm_1");
string local2_rtm_dir = @arg("LOCAL_rtm_2");
string webdir = @arg("WEBDIR");
string diag_code = @arg("DIAG_CODE");trace(@strcat("diag_code: ",@arg("DIAG_CODE")));
int cn = @toint(@arg("CN"));
int casa = @toint(@arg("CASA"));
string plot_type = @arg("PLOTTYPE");
int trends_1 = @toint(@arg("trends_1"));
int trends_2 = @toint(@arg("trends_2"));
int climo_1 = @toint(@arg("climo_1"));
int climo_2 = @toint(@arg("climo_2"));
int rtm_1 = @toint(@arg("rtm_1"));
int rtm_2 = @toint(@arg("rtm_2"));
int trends_atm_1 = @toint(@arg("trends_atm_1"));
int trends_atm_2 = @toint(@arg("trends_atm_2"));
int climo_atm_1 = @toint(@arg("climo_atm_1"));
int climo_atm_2 = @toint(@arg("climo_atm_2"));
int trends_rtm_1 = @toint(@arg("trends_rtm_1"));
int trends_rtm_2 = @toint(@arg("trends_rtm_2"));
int climo_rtm_1 = @toint(@arg("climo_rtm_1"));
int climo_rtm_2 = @toint(@arg("climo_rtm_2"));
int trends_first_yr_1 = @toint(@arg("trends_first_yr_1"));
int trends_first_yr_2 = @toint(@arg("trends_first_yr_2"));
int clim_first_yr_1 = @toint(@arg("clim_first_yr_1"));
int clim_first_yr_2 = @toint(@arg("clim_first_yr_2"));
int trends_num_yrs_1 = @toint(@arg("trends_num_yrs_1"));
int trends_num_yrs_2 = @toint(@arg("trends_num_yrs_2"));
int trends_match_flag = @toint(@arg("trends_match_flag"));
int trends_match_yr_1 = @toint(@arg("trends_match_yr_1"));
int trends_match_yr_2 = @toint(@arg("trends_match_yr_2"));
int clim_num_yrs_1 = @toint(@arg("clim_num_yrs_1"));
int clim_num_yrs_2 = @toint(@arg("clim_num_yrs_2"));
string MSS_tarfile_1 = @arg("MSS_tarfile_1");
string MSS_tarfile_2 = @arg("MSS_tarfile_2");
string MSS_path_1 = @arg("MSS_path_1");
string MSS_path_2 = @arg("MSS_path_2");
string MSS_path_atm_1 = @arg("MSS_path_atm_1");
string MSS_path_atm_2 = @arg("MSS_path_atm_2");
string MSS_path_rtm_1 = @arg("MSS_path_rtm_1");
string MSS_path_rtm_2 = @arg("MSS_path_rtm_2");
string caseid_1 = @arg("caseid_1");
string caseid_2 = @arg("caseid_2");
string prefix_1 = @arg("prefix_1");
string prefix_2 = @arg("prefix_2");
string case_1_dir = @arg("case_1_dir");
string case_2_dir = @arg("case_2_dir");
string pref_1_dir = @arg("prefix_1_dir");
string pref_2_dir = @arg("prefix_2_dir");
string case_1_atm_dir = @arg("case_1_atm_dir");
string case_2_atm_dir = @arg("case_2_atm_dir");
string pref_1_atm_dir = @arg("prefix_1_atm_dir");
string pref_2_atm_dir = @arg("prefix_2_atm_dir");
string case_1_rtm_dir = @arg("case_1_rtm_dir");
string case_2_rtm_dir = @arg("case_2_rtm_dir");
string pref_1_rtm_dir = @arg("prefix_1_rtm_dir");
string pref_2_rtm_dir = @arg("prefix_2_rtm_dir");
int rmTrendFlag = @toint(@arg("rmMonFilesTrend"));
int rmClimoFlag = @toint(@arg("rmMonFilesClimo"));
int meansFlag = @toint(@arg("meansFlag"));
int deleteProcDir = @toint(@arg("deleteProcDir"));
int clamp = @toint(@arg("clamp"));
string commonname_1 = @arg("commonname_1");
int usecommonname_1 = @toint(@arg("usecommonname_1"));
string commonname_2 = @arg("commonname_2");
int usecommonname_2 = @toint(@arg("usecommonname_2"));
string diag_home = @arg("diag_home");
string diag_resources = @arg("diag_resources");
string diag_version = @arg("diag_version");
int expContours = @toint(@arg("expContours"));
int hydro = @toint(@arg("hydro"));
string input_files = @arg("input_files");
int land_mask1 = @toint(@arg("land_mask1"));
int land_mask2 = @toint(@arg("land_mask2"));
int min_lat = @toint(@arg("min_lat"));
int min_lon = @toint(@arg("min_lon"));
string obs_data = @arg("obs_data");
string obs_res = @arg("obs_res");
int paleo = @toint(@arg("paleo"));
int plotObs = @toint(@arg("plotObs"));
string plottype = @arg("plottype");
int raster = @toint(@arg("raster"));
int reg_contour = @toint(@arg("reg_contour"));
string sig_lvl = @arg("sig_lvl");
int debugflag = @toint(@arg("debugflag"));
int convertflag = @toint(@arg("convertflag"));
int regrid_1 = @toint(@arg("regrid_1"));
string method_1 = @arg("method_1");
string wgt_dir_1 = @arg("wgt_dir_1");
string wgt_file_1 = @arg("wgt_file_1");
string area_dir_1 = @arg("area_dir_1");
string area_file_1 = @arg("area_file_1");
string old_res_1 = @arg("old_res_1");
string new_res_1 = @arg("new_res_1");
int regrid_2 = @toint(@arg("regrid_2"));
string method_2 = @arg("method_2");
string wgt_dir_2 = @arg("wgt_dir_2");
string wgt_file_2 = @arg("wgt_file_2");
string area_dir_2 = @arg("area_dir_2");
string area_file_2 = @arg("area_file_2");
string old_res_2 = @arg("old_res_2");
string new_res_2 = @arg("new_res_2");
string projection = @arg("projection");
string colormap = @arg("colormap");
string density = @arg("density");
string diag_shared = @arg("diag_shared");
string ncarg_root = @arg("ncarg_root");
int clamp_diag = @toint(@arg("clamp_diag"));
int nlon_1 = @toint(@arg("nlon_1"));
int nlon_2 = @toint(@arg("nlon_2"));
int nlat_1 = @toint(@arg("nlat_1"));
int nlat_2 = @toint(@arg("nlat_2"));
string model_vs_model = @arg("model_vs_model");

int multi_instance1 = @toint(@arg("multi_instance1"));
int num_instance1 = @toint(@arg("num_instance1"));
string id_instance1 = @arg("id_instance1");
string instance1[];

int multi_instance2 = @toint(@arg("multi_instance2"));
int num_instance2 = @toint(@arg("num_instance2"));
string id_instance2 = @arg("id_instance2");
string instance2[];

#================================================================================
# Define Arrays
#================================================================================
if (multi_instance1 == 1) {
  if (num_instance1 == 1) {
    instance1 = [id_instance1];
  } else {
    if (num_instance1 == 16) {
      instance1 = ["_0001","_0002","_0003","_0004","_0005","_0006","_0007","_0008","_0009","_0010","_0011","_0012","_0013","_0014","_0015","_0016"];
    } else {
      if (num_instance1 == 32) {
        instance1 = ["_0001","_0002","_0003","_0004","_0005","_0006","_0007","_0008","_0009","_0010","_0011","_0012","_0013","_0014","_0015","_0016","_0017","_0018","_0019","_0020","_0021","_0022","_0023","_0024","_0025","_0026","_0027","_0028","_0029","_0030","_0031","_0032"];
      } else {
        instance1 = [""];
      }
    }
  }
} else {
  instance1 = [""];
}

if (multi_instance2 == 1) {
  if (num_instance2 == 1) {
    instance2 = [id_instance2];
  } else {
    if (num_instance2 == 16) {
      instance2 = ["_0001","_0002","_0003","_0004","_0005","_0006","_0007","_0008","_0009","_0010","_0011","_0012","_0013","_0014","_0015","_0016"];
    } else {
      if (num_instance2 == 32) {
        instance2 = ["_0001","_0002","_0003","_0004","_0005","_0006","_0007","_0008","_0009","_0010","_0011","_0012","_0013","_0014","_0015","_0016","_0017","_0018","_0019","_0020","_0021","_0022","_0023","_0024","_0025","_0026","_0027","_0028","_0029","_0030","_0031","_0032"];
      } else {
        instance2 = [""];
      }
    }
  }
} else {
  instance2 = [""];
}

string modeList[] = ["clm2","cam2","rtm"];
string monList[] = ["-01","-02","-03","-04","-05","-06","-07","-08","-09","-10","-11","-12"];
int ndays[] = [31,28,31,30,31,30,21,21,30,31,30,31];
string seaList[] = ["DJF", "MAM", "JJA", "SON"];
string reqFileListClimo[] = ["_ANN_climo", "_ANN_means","_DJF_climo", "_DJF_means",
  "_MAM_climo", "_MAM_means", "_JJA_climo", "_JJA_means", "_SON_climo", "_SON_means",
  "_MONS_climo"];
string reqFileListTrends[] = ["_ANN_ALL"];

string caseList[];
string prefList[];
#  string prefListB[];
#  string branPath[];
string locDir[];
int locFlag[];
string caseDir_A[];
string prefDir[];
#  string prefDirB[];
int climo[];
int trends[];
int nclimo[];
int ntrends[];
string MSS_tar[];
string MSS[];
int createTrends[];
int createClimo[];
int nlons[];
int nlats[];

if (runtype == "model-obs") {
  caseList = [caseid_1];
  prefList = [prefix_1];
#  string prefListB[] = [bran_1_prefix];
#  string branPath[] = [bran_1_path];
  locDir = [local1_dir, local1_atm_dir, local1_rtm_dir];
  locFlag = [localFlag1, localFlag1_atm, localFlag1_rtm];
  caseDir_A = [case_1_dir, case_1_atm_dir, case_1_rtm_dir];
  prefDir = [pref_1_dir, pref_1_atm_dir, pref_1_rtm_dir];
#  string prefDirB[] = [bran_1_dir, bran_1_atm_dir, bran_1_rtm_dir];
  climo = [clim_first_yr_1];
  trends = [trends_first_yr_1];
  nclimo = [clim_num_yrs_1];
  ntrends = [trends_num_yrs_1];
  MSS_tar = [MSS_tarfile_1];
  MSS = [MSS_path_1, MSS_path_atm_1, MSS_path_rtm_1];
  createTrends = [trends_1, trends_atm_1, trends_rtm_1];
  createClimo = [climo_1, climo_atm_1, climo_rtm_1];
  nlats = [nlat_1];
  nlons = [nlon_1];

} else {
  caseList = [caseid_1, caseid_2];
  prefList = [prefix_1, prefix_2];
#  string prefListB[] = [bran_1_prefix, bran_2_prefix];
#  string branPath[] = [bran_1_path, bran_2_path];
  climo = [clim_first_yr_1, clim_first_yr_2];
  trends = [trends_first_yr_1, trends_first_yr_2];
  nclimo = [clim_num_yrs_1, clim_num_yrs_2];
  ntrends = [trends_num_yrs_1, trends_num_yrs_2];
  locDir = [local1_dir, local1_atm_dir, local1_rtm_dir,
                            local2_dir, local2_atm_dir, local2_rtm_dir];
  locFlag = [localFlag1, localFlag1_atm, localFlag1_rtm,
                           localFlag2, localFlag2_atm, localFlag2_rtm];
  caseDir_A = [case_1_dir, case_1_atm_dir, case_1_rtm_dir,
                            case_2_dir, case_2_atm_dir, case_2_rtm_dir];
  prefDir = [pref_1_dir, pref_1_atm_dir, pref_1_rtm_dir,
                             pref_2_dir, pref_2_atm_dir, pref_2_rtm_dir];
#  string prefDirB[] = [bran_1_dir, bran_1_atm_dir, bran_1_rtm_dir,
#                             bran_2_dir, bran_2_atm_dir, bran_2_rtm_dir];
  MSS_tar = [MSS_tarfile_1, MSS_tarfile_2];
  MSS = [MSS_path_1, MSS_path_atm_1, MSS_path_rtm_1,
                         MSS_path_2, MSS_path_atm_2, MSS_path_rtm_2];
  createTrends = [trends_1, trends_atm_1, trends_rtm_1,
                               trends_2, trends_atm_2, trends_rtm_2];
  createClimo = [climo_1, climo_atm_1, climo_rtm_1,
                              climo_2, climo_atm_2, climo_rtm_2];
  nlats = [nlat_1,nlat_2];
  nlons = [nlon_1,nlon_2];
}

#================================================================================
# App Calls
#================================================================================

(string yrstr)yearprint(int yr_1){
  if(yr_1<10) {
    yrstr = @strcat("000",yr_1);
  }
  if(yr_1 >= 10 && yr_1 <100) {
    yrstr=@strcat("00",yr_1);
  }
  if(yr_1 >= 100 && yr_1 < 1000) {
    yrstr=@strcat("0",yr_1);
  }
  if(yr_1 >= 1000) {
    yrstr=@strcat(yr_1);
  }
}
(string mstr)monthprint(int m){
  if(m<10) {
    mstr = @strcat("0",m);
  } else {
    mstr = @strcat(m);
  }
}

(file out) mfiles(string casedirL, string caseidL, int yrL, string modeL, string instanceL, string MSS_pathL,
                  string MSS_tarfileL, int local_linkL, int localFlagL, string localDirL){

     app{ mfiles_csh casedirL caseidL yrL modeL instanceL MSS_pathL MSS_tarfileL local_linkL localFlagL localDirL @filename(out);}
}

(file out) mfiles_2(file f[], string casedirL, string caseidL, int yrL, string modeL, string instanceL, string MSS_pathL,
                  string MSS_tarfileL, int local_linkL, int localFlagL, string localDirL){

     app{ mfiles_csh casedirL caseidL yrL modeL instanceL MSS_pathL MSS_tarfileL local_linkL localFlagL localDirL @filename(out);}
}

(file out)createAnnualFile(file mfileCompleteL, int yrL, string casedirL, string caseidL, string modeL, string instanceL,
          string procDirL, string prefixL, int weightAnnAvgL, string yr_pntL){

     app{ createAnnual_pl yrL @strcat(casedirL,"/") caseidL modeL instanceL @strcat(procDirL,"/") prefixL weightAnnAvgL yr_pntL @filename(out);}
}

(file out)createAnnualAllFile(file createAnnualFileCompleteL[], string caseDirL, string caseListL, string modeTypeL, string instanceL,
           string trends_fyr_prntL, string prefListL, string prefDirL, int trends_nyrL, string trends_rangeL){

     app{ createAnnualAll_pl @strcat(caseDirL,"/") caseListL modeTypeL instanceL trends_fyr_prntL prefListL @strcat(prefDirL,"/") trends_nyrL
                trends_rangeL @filename(out);}
}

(file out) getDecFlag(int clim_fyrL, int clim_lyrL, string casedirL, string caseidL, string modeL, string instanceL,
               int localFlagL, string MSS_tarfileL, string MSS_pathL, string localDirL, int local_linkL, string diag_home){

    app{ getDecFlag_csh clim_fyrL clim_lyrL casedirL caseidL modeL instanceL localFlagL MSS_tarfileL MSS_pathL
              localDirL local_linkL diag_home @filename(out);}
}

(file out) create_SEAS_means_step1(file mfileAll_climoComplete[], string season, int yr, int decFlag, 
		string mode, string instance, string procDir, string prefix, int weightAnnAvgL, string caseid, string caseDirL){

    app{ create_SEAS_means_step1_pl season yr decFlag mode instance procDir prefix weightAnnAvgL caseid caseDirL @filename(out);}
}

(file out) create_SEAS_climo_step1_1(file mfileAll_climoComplete[], string modeType, string instance, int clim_fyr, int clim_lyr,
		int decFlag, string procDir, string casedir,string caseid){
    
    app{ create_SEAS_climo_step1_1_pl modeType instance clim_fyr clim_lyr decFlag procDir casedir caseid @filename(out);}
}

(file out) create_SEAS_climo_step1_2(file link_lnd_seas_climoDir, string modeType, string instance, string procDir, string caseid,
		string month, string prefix){

    app{ create_SEAS_climo_step1_2_pl modeType instance procDir caseid month prefix @filename(out);}
}

(file out) create_ANN_climo(file createAnnual_climoFileComplete[], string mode, string instance, string casedir, string caseid, 
		string clim_fyr_prnt, string prefixDir, string prefix, int clim_nyr, string clim_range){

    app{ create_ANN_climo_pl mode instance casedir caseid clim_fyr_prnt prefixDir prefix clim_nyr clim_range @filename(out);}
}

(file out) create_ANN_means(file createAnnual_climoFileComplete[], string mode, string instance, string casedir, string caseid,
                string clim_fyr_prnt, string prefixDir, string prefix, int clim_nyr, string clim_range){

    app{ create_ANN_means_pl mode instance casedir caseid clim_fyr_prnt prefixDir prefix clim_nyr clim_range @filename(out);}
}

(file out) create_SEAS_climo_step2(file SEAS_Climo_complete[], string seas, string mode, string instance, string casedir, string caseid, 
		string prefixDir, string prefix, int clim_nyr, string clim_range, int weightAnnAvgL, string procDir){

    app{ create_SEAS_climo_step2_pl seas mode instance casedir caseid prefixDir prefix clim_nyr clim_range weightAnnAvgL procDir
		@filename(out);}
}

(file out) create_MONS_climo_step2_1(file mfileAll_climoComplete[], string procDir, int clim_fyr, int clim_lyr,
                        string casedir, string caseid, string mode, string instance){

    app{ create_MONS_climo_step2_1_pl procDir clim_fyr clim_lyr casedir caseid mode instance @filename(out);}
}

(file out) create_MONS_climo_step2_2(file create_MONS_climo_step2_1_complete, string month, string procDir, string mode, 
			string instance, string caseid, string prefix){

   app{ create_MONS_climo_step2_2_pl month procDir mode instance caseid prefix @filename(out);}
}

(file out) create_MONS_climo_step2_3(file create_MONS_climo_step2_2_complete[], string procDir, string prefix, string modeType, 
			string instance, string prefixDir, string clim_range, int clim_nyr){

   app{ create_MONS_climo_step2_3_pl procDir prefix modeType instance prefixDir clim_range clim_nyr @filename(out);}
}

(file out) create_SEAS_means_step2(file AnnualSeasonalF_Allyears[], string season, string procDir, string prefix, 
			int weightAnnAvgL, int clim_lyr, string casedir, string caseid, string mode, 
                        string instance, string prefixDir){

   app{ create_SEAS_means_step2_pl season procDir prefix weightAnnAvgL clim_lyr casedir caseid mode instance prefixDir @filename(out);}
}

(file out) create_multi_instance_average(file nclF[], string climoF, string casedir, string caseid, string prefixDir,
                        string prefix, int num_instance){

   app{ create_multi_instance_average_pl climoF casedir caseid prefixDir prefix num_instance @filename(out);}
}

(file out) regrid(string procDir, string oldfile, string method, string wgt_dir, string wgt_file, string area_dir, string area_file, string oldres, string newfile, 
			string diag_home, string fname2mv2){

   app{ regrid_csh procDir oldfile method wgt_dir wgt_file area_dir area_file oldres newfile diag_home fname2mv2 @filename(out);} 
}

(file out) run_ncl_model_obs(int casa, string caseid_1, int clamp, int clim_first_yr_1, 
			int clim_num_yrs_1, int cn, string commpnName_1,
                        string diag_code, string diag_home, string diag_resources, 
			string diag_version, int expContours, int hydro, string input_files,
                        int land_mask1, int min_lat, int min_lon, string obs_data, string obs_res, 
			int paleo, string plottype, string prefix_1, string ptmpdir,
                        int raster, int reg_contour, int rtm_1, string sig_lvl, int trends_first_yr_1, int trends_num_yrs_1,
                        int usecommonname_1, string wkdir, string f, string s, file AllComplete2[], string projection, 
			string colormap, string density, string diag_shared, string ncarg_root){
 
   app{ run_ncl_model_obs_csh casa caseid_1 clamp clim_first_yr_1 clim_num_yrs_1 cn commpnName_1
                        diag_code diag_home diag_resources diag_version expContours hydro input_files
                        land_mask1 min_lat min_lon obs_data obs_res paleo plottype prefix_1 ptmpdir
                        raster reg_contour rtm_1 sig_lvl trends_first_yr_1 trends_num_yrs_1
                        usecommonname_1 wkdir f s projection colormap density diag_shared ncarg_root @filename(out);}
 
}

(file out) run_ncl_model_model(int casa, string caseid_1, string caseid_2, int clamp, int clim_first_yr_1, 
			int clim_first_yr_2, int clim_num_yrs_1, int clim_num_yrs_2, int cn, string commonname_1, 
			string commonname_2, string compare, int debugflag, string diag_code, string diag_home, 
			string diag_resources, string diag_version, int expContours, int hydro, string input_files,
                        int land_mask1, int min_lat, int min_lon, string obs_data, string obs_res, 
			int paleo, int plotObs, string plottype, string prefix_1, string prefix_2, string ptmpdir, int raster, 
			int reg_contour, int rtm_1, int rtm_2, string sig_lvl, int trends_first_yr_1, int trends_first_yr_2,
                        int trends_match_flag, int trends_match_yr_1, int trends_match_yr_2, int trends_num_yrs_1, int trends_num_yrs_2,
                        int usecommonname_1, int usecommonname_2, string wrkdr, string f, string s, file AllComplete2[], file AllComplete_2[],
			string projection, string colormap, string density, string diag_shared, string ncarg_root){

   app{ run_ncl_model_model_csh casa caseid_1 caseid_2 clamp clim_first_yr_1 clim_first_yr_2
                        clim_num_yrs_1 clim_num_yrs_2 cn commonname_1 commonname_2 compare debugflag
                        diag_code diag_home diag_resources diag_version expContours hydro input_files
                        land_mask1 min_lat min_lon obs_data obs_res paleo plotObs plottype prefix_1 prefix_2
                        ptmpdir raster reg_contour rtm_1 rtm_2 sig_lvl trends_first_yr_1 trends_first_yr_2
                        trends_match_flag trends_match_yr_1 trends_match_yr_2 trends_num_yrs_1 trends_num_yrs_2
                        usecommonname_1 usecommonname_2 wrkdr f s projection colormap density diag_shared ncarg_root @filename(out);}
}

(file out) run_clamp_ncl(file AllComplete2[], file clamp_complete[], string iT[], string f,  string wrkdr, string prefix, string prefix_dir, 
		int fn, string model_vs_model, string runtype , string prefix_1_dir){

   app{ run_clamp_ncl_csh iT[0] iT[1] iT[2] iT[3] iT[4] iT[5] iT[6] iT[7] iT[8] iT[9] iT[10] iT[11] iT[12] iT[13] iT[14] iT[15] iT[16] iT[17]
		f wrkdr prefix prefix_dir fn model_vs_model runtype prefix_1_dir @filename(out);}
}

(file out) run_clamp_ncl_2(file CompareTable, file AllComplete2[], file clamp_complete[], string iT[], string f,  string wrkdr, string prefix, string prefix_dir,
                int fn, string model_vs_model, string runtype , string prefix_1_dir){

   app{ run_clamp_ncl_csh iT[0] iT[1] iT[2] iT[3] iT[4] iT[5] iT[6] iT[7] iT[8] iT[9] iT[10] iT[11] iT[12] iT[13] iT[14] iT[15] iT[16] iT[17]
                f wrkdr prefix prefix_dir fn model_vs_model runtype prefix_1_dir @filename(out);}
}

(file out) mergerCompareTable(file clmap_ncl[], string prefix_dir, string model_vs_model, string diag_shared, string prefix, string wkdir, string diag_home,string iT[],
				string prefix_1_dir, int model_model){

   app{ mergerCompareTable_csh iT[0] iT[1] iT[2] iT[3] iT[4] iT[5] iT[6] iT[7] iT[8] iT[9] iT[10] iT[11] iT[12] iT[13] iT[14] iT[15] iT[16] iT[17]
					prefix_dir model_vs_model diag_shared prefix wkdir diag_home prefix_1_dir model_model @filename(out);}
}

(file out) run_pre_clamp_ncl(int first_yr, int last_yr, int nyear, string prefix, string prefix_dir, int nlat, int nlon, string f, 
		string dpath, string wrkdir, string caseid){

   app{ run_pre_clamp_ncl_csh first_yr last_yr nyear prefix prefix_dir nlat nlon f wrkdir dpath caseid @filename(out);}
}

(file out) complete_array(file array[]){

    app{ complete_csh @filename(out);}
}

(file out) complete_2_array(file array1[], file array2[]){

    app{ complete_csh @filename(out);}
}


(file out) complete_file(file f){

    app{ complete_csh @filename(out);}
}

(file out) complete_2_file(file f1, file f2){

    app{ complete_csh @filename(out);}
}

(file out) complete(){

    app{ complete_csh @filename(out);}
}

(file out) complete_myMode(file createAnnual_trendsFileComplete[], file createAnnAllFileC, 
		file createAnnual_climoFileComplete[], file AnnualSeasonalF_Allyears[], 
		file SEAS_Climo_complete[], file create_ANN_climo_complete, 
		file create_ANN_means_complete, file create_SEAS_climo_step2_complete[],
		file create_MONS_climo_step2_3_complete, file create_SEAS_means_step2_complete[]){

    app{ complete_csh @filename(out);}
}

(file out)getFileList(file nclF[], string wrkdirL, string filetype) {

	app {get_fileList_csh wrkdirL filetype @filename(out);}
}

(file out) convertImages(string f, string fp, string wkdir, string webdir, string runtype, string plottype, string density){

    app{ lnd_ps2gif_swift_pl f fp wkdir webdir runtype plottype density @filename(out);}
}

file AllComplete1[];
#================================================================================
foreach caseType,caseCtr in caseList {
#================================================================================

  file modesComplete[];
#================================================================================
  foreach modeType,modeC in modeList {
#================================================================================

        int modeCtr = modeC + (caseCtr*3);

	string casedir = caseDir_A[modeCtr];
	string localDir = locDir[modeCtr];
	int localFlag = locFlag[modeCtr];
	string prefixDir = prefDir[modeCtr];
#	string prefixDirB = prefDirB[modeCtr];

	string procDir = @strcat(prefixDir,"proc/");
#	string procDirB = @strcat(prefixDirB,"proc/");

	string caseid = caseList[caseCtr];
	string prefix = prefList[caseCtr];
#	string prefixB = preListN[caseCtr];
#	string pathB = branPath[caseCtr];
	string MSS_tarfile = MSS_tar[caseCtr];
	string MSS_path = MSS[modeCtr];
	int runTrends = createTrends[modeCtr];
	int runClimo = createClimo[modeCtr];

	int trends_fyr = trends[caseCtr];
	string trends_fyr_prnt = yearprint(trends_fyr);
	int trends_nyr = ntrends[caseCtr];
	int trends_lyr = ((trends_fyr+trends_nyr)-1); 
	string trends_range = @strcat(trends_fyr,"-",trends_lyr);

	int clim_fyr = climo[caseCtr];
	string clim_fyr_prnt = yearprint(clim_fyr);
	int clim_nyr = nclimo[caseCtr];
	int clim_lyr = ((clim_fyr + clim_nyr)-1);
	string clim_range = @strcat(clim_fyr,"-",clim_lyr);

	int trends_years_to_test[] = [trends_fyr : trends_fyr + trends_nyr - 1 : 1];
 	int climo_years_to_test[] = [clim_fyr : clim_fyr + clim_nyr - 1 : 1];

#================================================================================
# Main Loop
#================================================================================
#**************************************************
# Check for or get history files and create the Annual trends/climo files
#**************************************************
#================================================================================
      string instance[];
      if (caseCtr == 0) {
        instance = instance1;
      } else {
        instance = instance2;
      }
      foreach instanceId,instanceCtr in instance {
#================================================================================

        file mfileAllComplete[];
        file createAnnual_trendsFileComplete[]; 

        file mfileAll_climoComplete[];
        file createAnnual_climoFileComplete[];

        if (runTrends == 1) {
          foreach yr in trends_years_to_test {
	    # Check for monthly files locally
            file mfileComplete_trend = mfiles(casedir,caseid,yr,modeType,instance[instanceCtr],MSS[modeCtr],MSS_tar[caseCtr],local_link,
                                              locFlag[modeCtr],locDir[modeCtr]);
 	    mfileAllComplete[yr] = mfileComplete_trend;
            # Create annual file
            createAnnual_trendsFileComplete[yr] = createAnnualFile(mfileComplete_trend, yr, casedir, caseid, modeType, instance[instanceCtr],
                                                  procDir, prefList[caseCtr], weightAnnAvg, yearprint(yr));
          }
        } else {
          createAnnual_trendsFileComplete[0] = complete(); 
        }

        if (runClimo == 1) {
          foreach yr in climo_years_to_test {
	    # Check for monthly files locally
            file mfileComplete_climo = mfiles_2(createAnnual_trendsFileComplete,casedir,caseid,yr,modeType,instance[instanceCtr],
                                 MSS[modeCtr],MSS_tar[caseCtr],local_link,locFlag[modeCtr],locDir[modeCtr]);
            mfileAll_climoComplete[yr] = mfileComplete_climo;  
            # Create annual file
            createAnnual_climoFileComplete[yr] = createAnnualFile(mfileComplete_climo, yr, casedir, caseid, modeType, instance[instanceCtr],
                                                 procDir, prefList[caseCtr], weightAnnAvg, yearprint(yr));
          }
        } else {
          createAnnual_climoFileComplete[0] = complete(); 
        }

#**************************************************
# Create the AnnualAll Trends file
#**************************************************
        file createAnnAllFileC;
        if (runTrends == 1 && meansFlag == 1) {
          createAnnAllFileC = createAnnualAllFile(createAnnual_trendsFileComplete,casedir, caseid, modeType, instance[instanceCtr],
                              trends_fyr_prnt,prefix,prefixDir,trends_nyr,trends_range);
        } else {
	  createAnnAllFileC = complete();
        } 

#**************************************************
# Check which DJF's to use
#**************************************************

        int decFlag;

        if (runClimo == 1){
    	  file getDecFlagC = getDecFlag(clim_fyr,clim_lyr,casedir,caseid,modeType,instance[instanceCtr],locFlag[modeCtr],MSS_tar[caseCtr],
       	  MSS[modeCtr],locDir[modeCtr],local_link,diag_home);

    	  string decFlagRead[] = readData(getDecFlagC);
    	  decFlag = @toint(decFlagRead[0]);
        }

#**************************************************
# Run create_SEAS_means_step1 for each year/season
#**************************************************

        file  AnnualSeasonalF_Allyears[];
        if (runClimo == 1){
          foreach yr,j in climo_years_to_test {
            file AnnualSeasonalF_1yr[];
            foreach season,k in seaList{
               AnnualSeasonalF_1yr[k] = create_SEAS_means_step1(mfileAll_climoComplete,season,yr,decFlag,modeType,instance[instanceCtr],
                                        procDir,prefix,weightAnnAvg,caseid,casedir);
            }
            AnnualSeasonalF_Allyears[j] = complete_array(AnnualSeasonalF_1yr); 
          }
        } else {
	  AnnualSeasonalF_Allyears[0] = complete();
	}

#**************************************************
# Run create_SEAS_climo_step1 (divided in to two parts)
#**************************************************

	file SEAS_Climo_complete[];
	if (runClimo == 1){
          if (clim_fyr != clim_lyr){
   	    file link_lnd_seas_climoDir = create_SEAS_climo_step1_1(mfileAll_climoComplete,modeType,instance[instanceCtr],clim_fyr,
                                          clim_lyr,decFlag,procDir,casedir,caseid);
	
	    foreach month,i in monList{
	      SEAS_Climo_complete[i] = create_SEAS_climo_step1_2(link_lnd_seas_climoDir,modeType,instance[instanceCtr],procDir,caseid,month,prefix); 
	    }
          }
	} else {
	  SEAS_Climo_complete[0] = complete();
	}

#**************************************************
# Run create_ANN_climo
#**************************************************

	file create_ANN_climo_complete;
	if (runClimo == 1){
	  create_ANN_climo_complete = create_ANN_climo(createAnnual_climoFileComplete, modeType, instance[instanceCtr], casedir,
                                      caseid, clim_fyr_prnt, prefixDir, prefix, clim_nyr, clim_range);
	} else {
	  create_ANN_climo_complete = complete();
	}

#**************************************************
# Run create_ANN_means
#**************************************************

	file create_ANN_means_complete;
	if (runClimo == 1){
	  create_ANN_means_complete = create_ANN_means(createAnnual_climoFileComplete, modeType, instance[instanceCtr], casedir,
                                      caseid, clim_fyr_prnt, prefixDir, prefix, clim_nyr, clim_range);
	} else {
	  create_ANN_means_complete = complete();
	}

#**************************************************
# Run create_SEAS_climo_step2
#**************************************************

        file create_SEAS_climo_step2_complete[];
	if (runClimo == 1){
	  foreach season,k in seaList{
		create_SEAS_climo_step2_complete[k] = create_SEAS_climo_step2(SEAS_Climo_complete, season, modeType,
                                                      instance[instanceCtr], casedir, caseid, prefixDir, prefix,clim_nyr,
                                                      clim_range, weightAnnAvg, procDir); 	
	  }
	} else {
	  create_SEAS_climo_step2_complete[0] = complete();
	}

#**************************************************
# Run create_MONS_climo_step2 (divided in to three parts)
#**************************************************

	file create_MONS_climo_step2_3_complete;
	if (runClimo == 1){
	  file create_MONS_climo_step2_1_complete = create_MONS_climo_step2_1(mfileAll_climoComplete, procDir, clim_fyr, clim_lyr,
			casedir, caseid, modeType, instance[instanceCtr]);

	  file create_MONS_climo_step2_2_complete[];
	  foreach month,i in monList{
		create_MONS_climo_step2_2_complete[i] = create_MONS_climo_step2_2(create_MONS_climo_step2_1_complete, month, 
				                        procDir, modeType, instance[instanceCtr], caseid, prefix); 	
	  }
	  create_MONS_climo_step2_3_complete = create_MONS_climo_step2_3(create_MONS_climo_step2_2_complete, procDir,
			                       prefix, modeType, instance[instanceCtr], prefixDir, clim_range, clim_nyr);
	} else {
	  create_MONS_climo_step2_3_complete = complete();
	}

#**************************************************
# Run create_SEAS_means_step2
#**************************************************
	file create_SEAS_means_step2_complete[];
        if (runClimo == 1 && meansFlag == 1) {
	  foreach season,k in seaList{
		create_SEAS_means_step2_complete[k] = create_SEAS_means_step2(AnnualSeasonalF_Allyears, season, procDir,
			                              prefix, weightAnnAvg, clim_lyr, casedir, caseid, modeType, instance[instanceCtr],
                                                      prefixDir);
	  }
	} else {
	  create_SEAS_means_step2_complete[0] = complete();
	}

#**************************************************
# Signal that the modeType for this caseType created
# all of the files it needed to
#**************************************************
	modesComplete[modeCtr+(instanceCtr*3)] = complete_myMode(createAnnual_trendsFileComplete, 
				                 createAnnAllFileC, createAnnual_climoFileComplete, AnnualSeasonalF_Allyears, 
				                 SEAS_Climo_complete, create_ANN_climo_complete, create_ANN_means_complete, 
                                                 create_SEAS_climo_step2_complete, create_MONS_climo_step2_3_complete, 
				                 create_SEAS_means_step2_complete);

   } # end instanceId

  } # end modeType

  AllComplete1[caseCtr] = complete_array(modesComplete);
} # end caseType

#**************************************************
# Create multi-instance average if required
#**************************************************

file multi_instance_Trendaverage[];
file multi_instanceMM_Trendaverage[];
file multi_instance_Climoaverage[];
file multi_instanceMM_Climoaverage[];
file AllTrendComplete2[];
file AllClimoComplete2[];
file AllComplete2[];
int runTrendsM1;
int runTrendsM2;
int runClimoM1;
int runClimoM2;

if (multi_instance1 == 1 || multi_instance2 == 1) {
  if (runtype == "model1-model2") {
    if (multi_instance1 == 1) {
      runTrendsM1 = createTrends[0];
      runClimoM1 = createClimo[0];
    } else {
      runTrendsM1 = 0;
      runClimoM1 = 0;
    }
    if (multi_instance2 == 1) {
      runTrendsM2 = createTrends[3];
      runClimoM2 = createClimo[3];
    } else {
      runTrendsM2 = 0;
      runClimoM2 = 0;
    }
  } else {
    if (multi_instance1 == 1) {
      runTrendsM1 = createTrends[0];
      runClimoM1 = createClimo[0];
    } else {
      runTrendsM1 = 0;
      runClimoM1 = 0;
    }
  }
  if (runTrendsM1 == 1) {
    foreach trendF,t in reqFileListTrends{
      if (multi_instance1 == 1) {
        multi_instance_Trendaverage[t] = create_multi_instance_average(AllComplete1, trendF, case_1_dir, caseid_1, pref_1_dir,
                                         prefix_1, num_instance1);
      } else {
        multi_instance_Trendaverage[t] = complete();
      }
      if (runtype == "model1-model2" && multi_instance2 == 1 && runTrendsM2 == 1) {
        multi_instanceMM_Trendaverage[t] = create_multi_instance_average(AllComplete1, trendF, case_2_dir, caseid_2, pref_2_dir,
                                               prefix_2, num_instance2);
      } else {
        multi_instanceMM_Trendaverage[t]=complete();
      }
      AllTrendComplete2[t] = complete_2_array(multi_instance_Trendaverage,multi_instanceMM_Trendaverage);
    }
  } else {
    AllTrendComplete2[0] = complete();
  }
  if (runClimoM1 == 1) {
    foreach climoF,c in reqFileListClimo{
      if (multi_instance1 == 1) {
        multi_instance_Climoaverage[c] = create_multi_instance_average(AllComplete1, climoF, case_1_dir, caseid_1, pref_1_dir,
                                         prefix_1, num_instance1);
      } else {
        multi_instance_Climoaverage[c] = complete();
      }
      if (runtype == "model1-model2" && multi_instance2 == 1 && runClimoM2 == 1) {
        multi_instanceMM_Climoaverage[c] = create_multi_instance_average(AllComplete1, climoF, case_2_dir, caseid_2, pref_2_dir,
                                               prefix_2, num_instance2);
      } else {
        multi_instanceMM_Climoaverage[c]=complete();
      }
      AllClimoComplete2[c] = complete_2_array(multi_instance_Climoaverage,multi_instanceMM_Climoaverage);
    }
  } else {
    AllClimoComplete2[0] = complete();
  }
  AllComplete2[0] = complete_2_array(AllTrendComplete2,AllClimoComplete2);
} else {
  AllComplete2[0] = complete();
}

#**************************************************
# Run some pre-c-lamp scripts if running the c-lamp diags
#**************************************************
file pre_clamp_complete[];
file pre_clampMM_complete[];

if (clamp_diag == 1) {
 
  string pre_clampScripts[] = ["10.write_ameriflux_clm4.5BGC_RUN.ncl", "20.write_fire_clm4.5BGC_RUN.ncl"];
  foreach f,n in pre_clampScripts {
    string full_f = @strcat(diag_home,"/clamp/",f);
    pre_clamp_complete[n]=run_pre_clamp_ncl(clim_first_yr_1, ((clim_first_yr_1+clim_num_yrs_1)-1), clim_num_yrs_1, 
      prefix_1, pref_1_dir, nlat_1, nlon_1, full_f, case_1_dir, wkdir, caseid_1);   
    if (runtype == "model1-model2"){
      pre_clampMM_complete[n]=run_pre_clamp_ncl(clim_first_yr_2, ((clim_first_yr_2+clim_num_yrs_2)-1), clim_num_yrs_2,
        prefix_2, pref_2_dir, nlat_2, nlon_2, full_f, case_2_dir, wkdir, caseid_2);
    } else {
      pre_clampMM_complete[n]=complete();
    }
  }
}

#**************************************************
# Check to see if climo files need to be regridded
#**************************************************

file regrid_files_finished_1[];
file regrid_files_finished_2[];

if (regrid_1 == 1){


  file ncFileList; 
  ncFileList = getFileList(AllComplete2, pref_1_dir, "nc");
  
  string ncFiles[] = readData(ncFileList);
  foreach f,i in ncFiles{
    regrid_files_finished_1[i]=regrid(pref_1_dir,f,method_1,wgt_dir_1,wgt_file_1,area_dir_1,area_file_1,old_res_1,@strcat(new_res_1,"_",f),diag_home,@strcat(old_res_1,"_",f));
  }

} else {

  regrid_files_finished_1[0] = complete_2_array(AllComplete1,AllComplete2);
}

if (regrid_2 == 1){

  file ncFileList;  
  ncFileList = getFileList(AllComplete2, pref_2_dir, "nc");

  string ncFiles[] = readData(ncFileList);
  foreach f,i in ncFiles{
    regrid_files_finished_2[i]=regrid(pref_2_dir,f,method_2,wgt_dir_2,wgt_file_2,area_dir_2,area_file_2,old_res_2,@strcat(new_res_2,"_",f),diag_home,@strcat(old_res_2,"_",f));
  }

} else {

  regrid_files_finished_2[0] = complete_2_array(AllComplete1,AllComplete2);
}
#**************************************************
# Run NCL scripts
#**************************************************

string ncl_files[] = readData(@strcat(wkdir,"ncl_list.txt"));
file ncl_finished[];

if (runtype == "model-obs") {
  foreach f,i in ncl_files{

    string compare = "obs";

    ncl_finished[i] = run_ncl_model_obs(casa, caseid_1, clamp, clim_first_yr_1, clim_num_yrs_1, cn, commonname_1,
		        diag_code, diag_home, diag_resources, diag_version, expContours, hydro, input_files,
	                land_mask1, min_lat, min_lon, obs_data, obs_res, paleo, plottype, prefix_1, ptmpdir,
		        raster, reg_contour, rtm_1, sig_lvl, trends_first_yr_1, trends_num_yrs_1,
		        usecommonname_1, wkdir, f, "null", regrid_files_finished_1,projection,colormap,density,
		        diag_shared, ncarg_root);
  }
} else {
   foreach f,i in ncl_files{

     string compare = "model";
     trace(@strcat("ncl file: ",f));
     if (f == @strcat(diag_code,"/set_2.ncl")){

       string seasons[] = ["DJF","JJA","MAM","SON","ANN"];
       string new_f = @strcat(diag_code,"/set_2_seas.ncl");

       file set_2_finished[];

       foreach s,j in seasons{
         set_2_finished[j] = run_ncl_model_model(casa, caseid_1, caseid_2, clamp, clim_first_yr_1, clim_first_yr_2,
                        clim_num_yrs_1, clim_num_yrs_2, cn, commonname_1, commonname_2, compare, debugflag,
                        diag_code, diag_home, diag_resources, diag_version, expContours, hydro, input_files,
                        land_mask1, min_lat, min_lon, obs_data, obs_res, paleo, plotObs, plottype, prefix_1, prefix_2,
                        ptmpdir, raster, reg_contour, rtm_1, rtm_2, sig_lvl, trends_first_yr_1, trends_first_yr_2,
                        trends_match_flag, trends_match_yr_1, trends_match_yr_2, trends_num_yrs_1, trends_num_yrs_2,
                        usecommonname_1, usecommonname_2, wkdir, new_f, s, regrid_files_finished_1,
                        regrid_files_finished_2,projection,colormap,density,diag_shared,ncarg_root);
       }
        ncl_finished[i] = complete_array(set_2_finished);
     }else {
       
       ncl_finished[i] = run_ncl_model_model(casa, caseid_1, caseid_2, clamp, clim_first_yr_1, clim_first_yr_2,
                        clim_num_yrs_1, clim_num_yrs_2, cn, commonname_1, commonname_2, compare, debugflag,
                        diag_code, diag_home, diag_resources, diag_version, expContours, hydro, input_files,
                        land_mask1, min_lat, min_lon, obs_data, obs_res, paleo, plotObs, plottype, prefix_1, prefix_2,
                        ptmpdir, raster, reg_contour, rtm_1, rtm_2, sig_lvl, trends_first_yr_1, trends_first_yr_2,
                        trends_match_flag, trends_match_yr_1, trends_match_yr_2, trends_num_yrs_1, trends_num_yrs_2,
                        usecommonname_1, usecommonname_2, wkdir, f, "null", regrid_files_finished_1,
                        regrid_files_finished_2,projection,colormap,density,diag_shared,ncarg_root);
     }
   }
}

file clamp_ncl_finished[];
file clamp_ncl_finished_2[];

if (clamp_diag == 1) {
  
  string input_text_A[] = readData(@strcat(wkdir,"clamp_input_text_1.txt"));
  string clamp_ncl_files[] = readData(@strcat(wkdir,"clamp_ncl_list.txt"));
  foreach f,i in clamp_ncl_files{
    clamp_ncl_finished[i] = run_clamp_ncl(regrid_files_finished_1,pre_clamp_complete,input_text_A, f, wkdir, prefix_1, pref_1_dir,i,
		model_vs_model, runtype, pref_1_dir);
  }

  if (runtype == "model1-model2"){
      file mergerCompareTableComplete = mergerCompareTable(clamp_ncl_finished, pref_1_dir, model_vs_model, diag_shared, prefix_1,wkdir,diag_home,input_text_A, 
		pref_1_dir,1);
      string input_text_A_2[] = readData(@strcat(wkdir,"clamp_input_text_2.txt"));
      string clamp_ncl_files_2[] = readData(@strcat(wkdir,"clamp_ncl_list_2.txt"));
      foreach f,i in clamp_ncl_files_2{
        clamp_ncl_finished_2[i] = run_clamp_ncl_2(mergerCompareTableComplete,regrid_files_finished_2,pre_clampMM_complete,input_text_A_2, f, wkdir, prefix_2, pref_2_dir,i,
		model_vs_model, runtype, pref_1_dir);
      }
      file mergerCompareTableComplete_2 = mergerCompareTable(clamp_ncl_finished_2, pref_2_dir, model_vs_model, diag_shared, prefix_2,wkdir,diag_home,input_text_A_2, 
		pref_1_dir,1);
  } else {
      file mergerCompareTableComplete = mergerCompareTable(clamp_ncl_finished, pref_1_dir, model_vs_model, diag_shared, prefix_1,wkdir,diag_home,input_text_A,
                pref_1_dir,0);
  }  
} else {
  clamp_ncl_finished[0] = complete();
}

file All_ncl_finished[];
All_ncl_finished[0] = complete_array(ncl_finished);

#================================================================================
# Convert the image files
#================================================================================
file psFileList;

if (convertflag == 1){
  psFileList = getFileList(All_ncl_finished,wkdir,"ps");

  string psFiles[] = readData(psFileList);
  foreach f in psFiles{
    file convertFile; 
    convertFile = convertImages(f, @strcat(wkdir,f), wkdir, webdir, runtype, plottype, density); 
  } 
}


