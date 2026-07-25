{ ... }:
{
  vim.spellcheck = {
    enable = true;

    # Add more here if you write in another language, e.g. [ "en" "de" ].
    # The dictionaries are provisioned by Nix, so no runtime download.
    languages = [ "en" ];

    # Spellchecking is on globally, so keep it out of buffers where every
    # other word would be flagged. <leader>us toggles it per buffer.
    ignoredFiletypes = [
      "toggleterm"
      "nix"
      "lua"
      "snacks_dashboard"
      "snacks_picker_list"
      "trouble"
    ];
  };
}
