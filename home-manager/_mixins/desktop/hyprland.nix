{config, ...}:
{
home = {
    file = {
	"${config.xdg.configHome}/hypr" = {
	    source = ../dotfiles/hypr;
	};
	"${config.xdg.configHome}/shikane" = {
	    source = ../dotfiles/shikane;
	};
	"${config.xdg.configHome}/swaylock" = {
	    source = ../dotfiles/swaylock;
	};
	"${config.xdg.configHome}/waybar" = {
	    source = ../dotfiles/waybar;
	};
	"${config.xdg.configHome}/wlogout" = {
	    source = ../dotfiles/wlogout;
	};
	"${config.xdg.configHome}/wofi" = {
	    source = ../dotfiles/wofi;
	};
    };
};
}
