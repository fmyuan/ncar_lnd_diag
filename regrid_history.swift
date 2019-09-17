type file;

global string yes = "1";
global string no = "0";

# Read in env variables 
string file_dir = @arg("file_dir");
string file_prefix = @arg("file_prefix");
int first_yr = @toint(@arg("first_yr"));
int last_yr = @toint(@arg("last_yr"));
string output_directory = @arg("output_directory");
string weight_dir = @arg("weight_dir");
string old_res = @arg("old_res");
string new_res = @arg("new_res");
string method = @arg("method");
string wgt_file = @arg("wgt_file");
string script_dir = @arg("script_dir");
string fileList = @arg("fileList");
string area_dir = @arg("area_dir");
string area_file = @arg("area_file");

(file out) regrid(string procDir, string oldfile, string method, string wgt_dir, string wgt_file, string area_dir, string area_file, string script_dir,
			string old_res, string new_res, string output_dir){

   app{ regrid_history_ncl_wrapper_csh procDir oldfile method wgt_dir wgt_file area_dir area_file script_dir old_res new_res output_dir @filename(out);} 
}


file regrid_files[];

string ncFiles[] = readData(fileList);
foreach f,i in ncFiles{
  regrid_files[i]=regrid(file_dir,f,method,weight_dir,wgt_file,area_dir,area_file,script_dir,old_res,new_res,output_directory);
}


