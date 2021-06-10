{
  programs.git = {
    enable = true;
    aliases.id = ''
      ! git config user.name "$(git config user.$1.name)"; git config user.email "$(git config user.$1.email)"; git config user.signingkey "$(git config user.$1.signingkey)"; :'';
    extraConfig = {
      user.useConfigOnly = true;
      "user \"raccoon\"" = {
        name = "raccoon!";
        email = "raccoon@raccoon.fun";
        signingkey = "5203D9EAE7B65E37";
      };
      "user \"charlie\"" = {
        name = "Charlie Gates";
        email = "charlie@cgates.xyz";
        signingkey = "913136FAF8A95421";
      };
    };
  };
}
