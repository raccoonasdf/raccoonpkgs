{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "oberon" = {
        hostname = "oberon.raccoon.fun";
        user = "raccoon";
      };
    };
  };
}