#
#
# posh prompt install and setup script
#
BASHSCRIPT_DIR=$HOME/bashscripts
PROMPT_DIR=$BASHSCRIPT_DIR/prompt
PROMPT_TMP_DIR=$BASHSCRIPT_DIR/tmp
PROMPT_THEME_DIR=$PROMPT_DIR/themes
PROMPT_FONT_DIR=$PROMPT_TMP_DIR/fonts
export PATH="$PATH:$BASHSCRIPT_DIR:$PROMPT_DIR"

reinit()
{
  reset
  echo "please restart your terminal for changes to take affect."
}

download_posh()
{
	echo "downloading posh"
	local posh_windows_url=https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v8.0.1/posh-windows-amd64.exe
	local posh_linux_url=https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v8.0.1/posh-linux-amd64
	local posh_darwin_url=https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v8.0.1/posh-darwin-arm64
	download "${posh_windows_url}" "${PROMPT_DIR}/posh.exe"
}


download_posh_themes()
{
	[[ -d "${PROMPT_THEME_DIR}" ]] && return
	echo "downloading posh themes"
	mkdir -p "${PROMPT_TMP_DIR}"
	local themesurl="https://github.com/JanDeDobbeleer/oh-my-posh/releases/download/v8.1.0/themes.zip"
	download "${themesurl}" "${PROMPT_TMP_DIR}/themes.zip"
	mkdir -p "${PROMPT_THEME_DIR}"
	unzip -o -q "${PROMPT_TMP_DIR}/themes.zip" -d "${PROMPT_THEME_DIR}"
}


download_winfont()
{
	echo "downloading font installer"
	download "https://github.com/mdmattsson/WinFontInstall/releases/download/v1.0.2/WinFontInstaller-x64.exe" "${PROMPT_DIR}/WinFontInstall.exe"
}

download_fonts()
{
	# https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Meslo/M/Regular/complete/Meslo%20LG%20M%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.ttf
	echo "downloading fonts"

	local firacode_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip"
	local meslo_font_url="https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip"
	mkdir -p "${PROMPT_FONT_DIR}"
	
	download ${firacode_font_url} "${PROMPT_TMP_DIR}/FiraCode.zip"
	download ${meslo_font_url} "${PROMPT_TMP_DIR}/Meslo.zip"
	unzip -o -q "${PROMPT_TMP_DIR}/FiraCode.zip" -d "${PROMPT_FONT_DIR}"		
	unzip -o -q "${PROMPT_TMP_DIR}/Meslo.zip" -d "${PROMPT_FONT_DIR}"		
}

install_fonts()
{
	echo "Installing fonts..."
	WinFontInstall.exe --move --user --folder ${PROMPT_FONT_DIR}	
}



set_mintty()
{
	echo "Columns=166" > $HOME/.minttyrc
	echo "Rows=48" >> $HOME/.minttyrc
	echo "Font=MesloLGL NF" >> $HOME/.minttyrc
}

cleanup()
{
	rm -rf "${PROMPT_TMP_DIR}"
}
check_prompt_install()
{
	#prepare dirs
	[[ ! -d "${PROMPT_DIR}" ]] && mkdir -p "${PROMPT_DIR}"
	[[ ! -d "${PROMPT_TMP_DIR}" ]] && mkdir -p "${PROMPT_TMP_DIR}"
	#download & unstall
	download_posh
	download_posh_themes
	download_fonts
	download_winfont
	install_fonts
	set_mintty
	cleanup
	reinit
}

set_prompt()
{
	if [[ ! -f "${PROMPT_DIR}/posh.exe" ]]; then
		echo "setting up bash prompt for first time use..."
		check_prompt_install
	fi
	eval "$(posh --init --shell bash --config $PROMPT_THEME_DIR/michael.json)"
	#git config --global color.ui true	
	
}


set_prompt
