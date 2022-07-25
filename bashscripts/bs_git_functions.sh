#
#
# various git related functions
#



rebuild()
{
	[[ -f "CMakeCache.txt" ]] && rm -rf * && clear
	
	[[ -f "../src/CMakeLists.txt" ]] && cmakeroot=../src
	[[ "${cmakeroot}" == "" ]] && [[ -f "../src/src/CMakeLists.txt" ]] && cmakeroot=../src/src
	[[ "${cmakeroot}" == "" ]] && [[ -f "../src/build/CMakeLists.txt" ]] && cmakeroot=../src/build
	[[ "${cmakeroot}" == "" ]] && [[ -f "../src/build/install/CMakeLists.txt" ]] && cmakeroot=../src/build/install
	[[ "${cmakeroot}" == "" ]] && [[ "../src/install/CMakeLists.txt" ]] && cmakeroot=../src/install
	[[ "${cmakeroot}" == "" ]] && [[ "../src/install/build/CMakeLists.txt" ]] && cmakeroot=../src/install/build

	if [[ "${cmakeroot}" != "" ]]; then
	  local project_name=$(grep --ignore-case project ${cmakeroot}/CMakeLists.txt)
	  project_name=$(echo $project_name | awk -F '[{}]' '{print $2}')	  echo -e "repo: building repo ${project_name}"
	  #rm -rf * && clear && cmake -DCMAKE_TOOLCHAIN_FILE="c:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake"  -DCMAKE_INSTALL_PREFIX=../install ${cmakeroot}
	  cmake ${cmakeroot}
	  cmake --build . --config Debug
	  cmake --build . --config Release
	else
	  echo "Cannot build.. may not be CMake project,  could not find CMakeLists.txt"
	fi
}

repo()
{
	clear
	[[ $# -eq 0 ]] && echo -e "No URL supplied" && return	
	[[ $# -gt 0 ]] && url=$1 && base_name=$(basename ${url}) && repo_name=${base_name%.*}
	[[ $# -gt 1 ]] && repo_name=$2


	echo -e "repo: downloading ${base_name}"
	mkdir -p ${repo_name}/build
	mkdir -p ${repo_name}/src
	
	# add link to repo page
	link_filename="${repo_name}/${repo_name}.URL"
	echo "[InternetShortcut]" >${link_filename}
	echo "URL=${url%.git}" >>${link_filename}
	echo "IDList=">>${link_filename}
	echo "HotKey=0">>${link_filename}
	echo "IconFile=">>${link_filename}
	echo "IconIndex=0">>${link_filename}
	
	#clone repo locally
	cd ${repo_name}/src
	git clone ${url} .

	#find cmake root
	cmakeroot=""
	[[ -f ".gitmodules" ]] && git submodule update --init --recursive
}


brepo()
{
	repo "$@"
	cd ../build
	rebuild
}


private_clone()
{
	clear
	if [ $# -eq 0 ]; then
		echo -e "No URL supplied"
		return
	fi
	
	if [ $# -gt 0 ]; then
		url="$1"
		base_name=$(basename ${url})
		repo_name=${base_name%.*}
	fi

	if [ $# -gt 1 ]; then
		privrepo_name="$2"
	fi

	echo -e "repo: downloading ${base_name}"
	mkdir -p ${repo_name}/build
	mkdir -p ${repo_name}/src
	
	# add link to repo page
	link_filename="${repo_name}/${repo_name}.URL"
	echo "[InternetShortcut]" >${link_filename}
	echo "URL=${url%.git}" >>${link_filename}
	echo "IDList=">>${link_filename}
	echo "HotKey=0">>${link_filename}
	echo "IconFile=">>${link_filename}
	echo "IconIndex=0">>${link_filename}
	
	#clone repo locally
	cd ${repo_name}/src
	git clone --bare ${url} .

	#find cmake root
	cmakeroot=""
	if [[ -f ".gitmodules" ]]; then
		git submodule update --init --recursive
	fi
	
	git push --mirror ${privrepo_name}
}


install()
{
	[[ -f "CMakeCache.txt" ]] && rm -rf * && clear
	
	[[ -f "../src/CMakeLists.txt" ]] && cmakeroot=../src
	[[ "${cmakeroot}" == "" ]] && [[ -f "../src/src/CMakeLists.txt" ]] && cmakeroot=../src/src
	[[ "${cmakeroot}" == "" ]] && [[ -f "../src/build/CMakeLists.txt" ]] && cmakeroot=../src/build
	[[ "${cmakeroot}" == "" ]] && [[ -f "../src/build/install/CMakeLists.txt" ]] && cmakeroot=../src/build/install
	[[ "${cmakeroot}" == "" ]] && [[ "../src/install/CMakeLists.txt" ]] && cmakeroot=../src/install
	[[ "${cmakeroot}" == "" ]] && [[ "../src/install/build/CMakeLists.txt" ]] && cmakeroot=../src/install/build

	local project_name=$(grep --ignore-case project ${cmakeroot}/CMakeLists.txt)
	project_name=$(echo $project_name | awk -F '[{}]' '{print $2}')

	if [[ "${cmakeroot}" != "" ]]; then
	  echo -e "repo: building repo ${project_name}"
	  #rm -rf * && clear && cmake -DCMAKE_TOOLCHAIN_FILE="c:/dev/vcpkg/scripts/buildsystems/vcpkg.cmake"  -DCMAKE_INSTALL_PREFIX=../install ${cmakeroot}
	  cmake ${cmakeroot} && cmake --build .
	  #cmake --build . --target install --config Release
	fi
}


#Get Branch Commit Differences for Merging
find_branch_diffs()
{
	if [ $# -lt 2 ]; then
		echo -e "need to pass a source and target branch name"
		return
	fi
	source_repo="$1"
	target_repo="$2"
	git log origin/${source_repo}..origin/${target_repo} --oneline --no-merges
}

# ### From https://docs.gitlab.com/ee/user/project/merge_requests/#checkout-merge-requests-locally : e.g. gcmr upstream 12345
# gcmr() { git fetch $1 merge-requests/$2/head:mr-$1-$2 && git checkout mr-$1-$2; }
# ### This function prunes references to deleted remote branches and
# ### deletes local branches that have been merged and/or deleted from the remotes.
# ### It is intended to be run when on a master branch, and warns when it isn't.
# gclean (){
  # local BRANCH=`git rev-parse --abbrev-ref HEAD`
  # # Warning if not on a master* branch
  # if [[ $BRANCH != master* ]]
  # then
    # echo -e "\e[91m!! WARNING: It looks like you are not on a master branch !!\e[39m"
    # read -r -p "Are you sure you want to continue? [y/N] " response
    # if ! [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
    # then
      # echo "Aborted. Nothing was changed."
      # return 1
    # fi
  # fi
  # echo "Simulating a clean on $BRANCH ..." \
  # && echo "===== 1/2: simulating pruning origin =====" \
  # && git remote prune origin --dry-run \
  # && echo "===== 2/2: simulating cleaning local branches merged to $BRANCH =====" \
  # && git branch --merged $BRANCH | grep -v "^\**\s*master"  \
  # && echo "=====" \
  # && echo "Simulation complete."
  # read -r -p "Do you want to proceed with the above clean? [y/N] " response
  # if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
  # then
    # echo "Running a clean on $BRANCH ..."
    # echo "===== 1/2: pruning origin =====" \
    # && git remote prune origin \
    # && echo "===== 2/2: cleaning local branches merged to $BRANCH =====" \
    # && git branch --merged $BRANCH | grep -v "^\**\s*master" | xargs git branch -d \
    # && echo "=====" \
    # && echo "Clean finished."
  # else
    # echo "Aborted. Nothing was changed."
  # fi
# }
# ### Sync function for my current workflow, which only has a remote origin.
# ### Fetches origin and rebases current branch from origin.
# gsync (){
  # local BRANCH=`git rev-parse --abbrev-ref HEAD`
  # echo "Syncing the current branch: $BRANCH"
  # echo "===== 1/2: fetching origin =====" \
  # && git fetch origin \
  # && echo "===== 2/2: rebasing $BRANCH =====" \
  # && git rebase origin/$BRANCH \
  # && echo "=====" \
  # && echo "Syncing finished."
# }
# ### Sync function for my previous workflow, which had upstream+originfork+local.
# ### Syncs local and origin branch from a remote: runs a fetch from specified remote + rebase local + push to origin.
# OLDgsync (){
  # local BRANCH=`git rev-parse --abbrev-ref HEAD`
  # echo "Syncing the current branch: $BRANCH"
  # echo "===== 1/3: fetching $1 =====" \
  # && git fetch $1 \
  # && echo "===== 2/3: rebasing $BRANCH =====" \
  # && git rebase $1/$BRANCH \
  # && echo "===== 3/3: pushing to origin/$BRANCH =====" \
  # && git push origin $BRANCH \
  # && echo "=====" \
  # && echo "Syncing finished."
# }
# ### Function to take git interactive rebase argument. e.g.: gir 2
# gri() { git rebase -i HEAD~$1; }
# gir() { git rebase -i HEAD~$1; }
# ### Function to undo all changes (including stages) back to the last commit, with a confirmation.
# gundoall () {
  # echo "WARNING: This will delete all untracked files, and undo all changes since the last commit."
  # read -r -p "Are you sure? [y/N] " response
  # if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
  # then
    # echo "===== 1/2: git reset --hard HEAD =====" \
    # && git reset --hard HEAD \
    # && echo "===== 2/2: git clean -fd \$(git rev-parse --show-toplevel) =====" \
    # && git clean -fd $(git rev-parse --show-toplevel)
  # else
    # echo "Aborted. Nothing was changed."
  # fi
# }
