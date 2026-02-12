{pkgs,lib,...}:{  environment.systemPackages=with pkgs;[git vim   wget];
services.openssh.enable=true;
users.users.testuser={isNormalUser=true;extraGroups=["wheel"  "networkmanager"];initialPassword="password";};
networking.hostName="messy-machine";
time.timeZone="Europe/Berlin";
}

