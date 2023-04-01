{ ... }:

{
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;
        command_timeout = 1000;
        cmd_duration = {
          format = " [$duration]($style) ";
          style = "bold #EC7279";
          show_notifications = true;
        };
        nix_shell = {
          format = " [$symbol$state]($style) ";
        };
        battery = {
          full_symbol = "🔋 ";
          charging_symbol = "⚡️ ";
          discharging_symbol = "💀 ";
        };
        git_branch = {
          format = "[$symbol$branch]($style) ";
        };
        gcloud = {
          format = "[$symbol$active]($style) ";
        };
      };
    };
  };
}
