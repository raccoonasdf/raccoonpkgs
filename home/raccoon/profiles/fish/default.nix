{ lib, config, ... }: {
  programs.fish = {
    enable = true;

    functions = {
      fish_prompt.body = builtins.readFile ./fish_prompt.fish;
      "with".body = "nix-shell -p $argv --command fish";
      new.body = ''
        if count $argv >/dev/null
          $argv & disown
        else
          if test "$SHELL" = "alacritty"
            alacritty --working-directory . & disown
          end
        end
      '';
      ranger.body = lib.mkIf config.programs.ranger.enable
        "command ranger --choosedir=$HOME/.cache/.rangerdir; cd (cat $HOME/.cache/.rangerdir)";
    };

    shellAliases = {
      "bat" = "bat -p";
      "cat" = "bat -pp";
      "mv" = "mv -i";
      "ls" = "eza";
      "tree" = "eza -T";
    };

    interactiveShellInit = ''
      # syntax colors
      set fish_color_normal normal
      set fish_color_command magenta
      set fish_color_keyword blue
      set fish_color_quote yellow
      set fish_color_redirection cyan
      set fish_color_end brblue
      set fish_color_error red
      set fish_color_param brblue
      set fish_color_comment brblack
      set fish_color_selection white --bold --background=bryellow
      set fish_color_operator blue
      set fish_color_escape yellow
      set fish_color_valid_path --underline

      # ui colors
      set fish_color_autosuggestion brblack
      set fish_color_cancel -r
      set fish_color_history_current --bold
      set fish_color_search_match brblue

      # prompt colors
      set fish_color_cwd green
      set fish_color_cwd_root red
      set fish_color_host normal
      set fish_color_host_remote yellow
      set fish_color_status red
      set fish_color_user normal

      # pager colors
      set fish_pager_color_completion normal
      set fish_pager_color_description yellow --dim
      set fish_pager_color_prefix white --bold #--underline
      set fish_pager_color_progress brwhite --background=cyan

      # other settings
      set fish_greeting
      set fish_prompt_pwd_dir_length 3
    '';
  };
}
