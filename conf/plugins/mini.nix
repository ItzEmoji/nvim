{ lib, pkgs, ... }:
{
  vim.mini = {
    pairs.enable = true;
    comment.enable = true;
    surround.enable = true;
    splitjoin.enable = true;
    move.enable = true;
    sessions.enable = true;
  };
}

