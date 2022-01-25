{ pkgs, config, ... }: {
  programs.bash.enable = true;

  programs.blesh = {
   enable = true;
   faces = {
     disabled = "fg=gray";
     overwrite_mode = "fg=black";

     region = "bg=yellow";
     region_match = "bg=gray";

     syntax_default = "none";
     syntax_command = "fg=brown";
     syntax_quoted = "fg=green";
     syntax_quotation = "fg=green,bold";
     syntax_expr = "fg=navy";
     syntax_error = "fg=white";
     syntax_varname = "fg=brown";
     syntax_delimiter = "bold";
     syntax_param_expansion = "fg=purple";
     syntax_history_expansion = "fg=white";
     syntax_function_name = "fg=purple,bold";
     syntax_comment = "fg=gray";
     syntax_glob = "fg=purple";
     syntax_brace = "fg=teal,bold";
     syntax_tilde = "fg=navy,bold";
     syntax_document = "fg=red";
     syntax_document_begin = "fg=red,bold";

     command_builtin = "fg=red";
     command_builtin_dot = "fg=red,bold";
     command_alias = "fg=teal";
     command_function = "fg=purple";
     command_file = "fg=green";
     command_keyword = "fg=blue";
     command_jobs = "fg=red";
     command_directory = "fg=navy,underline";

     filename_directory = "fg=navy,underline";
     filename_directory_sticky = "fg=white,underline";
     filename_link = "fg=teal,underline";
     filename_orphan = "fg=teal,underline";
     filename_setuid = "fg=navy,underline";
     filename_setgid = "fg=green,underline";
     filename_executable = "fg=green,underline";
     filename_other = "underline";
     filename_socket = "fg=cyan,underline";
     filename_pipe = "fg=lime,underline";
     filename_character = "fg=white,underline";
     filename_block = "fg=yellow,underline";
     filename_warning = "fg=red,underline";
     filename_ls_colors = "underline";
   };
 };
}
