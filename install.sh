# |_ _|_ _  __| |_ __ _| | | __|__ __| |_
#  | || ' \(_-<  _/ _` | | | _/ -_|_-<  _|
# |___|_||_/__/\__\__,_|_|_|_|\___/__/\__|

# taken a lot from this https://github.com/divio/osx-bootstrap
# InstallFest
# This script can be run from the terminal by pasting in
# bash <(curl https://raw.github.com/phlco/installfest_scripts/master/install.sh)

# clear terminal screen
clear

# Start install fest
echo 'Welcome to Installfest'

# Determine OS version
declare osvers=$(sw_vers -productVersion)
declare latest_os="10.9.1"
echo "You're running OSX $osvers"
if [[ "$osvers" < "$latest_os" ]]; then
  echo "Please think about upgrading to the latest OS"
fi

# Let's make sure we're updated
echo "Checking for software updates..."
sudo softwareupdate -i -a

# The one prereq is Xcode Command Line Tools
# Check for those
if [ -x /Applications/Xcode.app/ ]; then
  echo "Xcode is installed"
else
  echo "Please install Xcode then rerun this script."
  exit
fi

# dramatis personae
declare source_dir=~/.wdi-installfest/scripts
declare source_git=https://github.com/phlco/installfest_scripts.git

# we need to download the repo for the absolute paths
if [[ ! -d $source_dir ]]; then
  echo 'Downloading Installfest repo...'
  # autoupdate bootstrap file
  git clone $source_git $source_dir
  # hide folder
  chflags hidden $source_dir
else
  # update repo
  echo 'Updating repo...'
  cd $source_dir
  git pull origin master
fi

# Ensure Macports and RVM aren't installed
source $source_dir/clean.sh

# install homebrew and formulae
source $source_dir/brew.sh

# additional settings and bash_profile
source $source_dir/settings.sh

# git setup
source $source_dir/git.sh

# sublime setup
source $source_dir/sublime.sh

# additional apps
source $source_dir/apps.sh

# Ruby setup
source $source_dir/rbenv.sh

# Gem setup
source $source_dir/gems.sh

# reload
source ~/.bash_profile

echo "All done?"
echo "You may want to run brew doctor to ensure everything is working."
echo "Next make sure your SSH keys are setup."
echo "Follow the instructions here: https://help.github.com/articles/generating-ssh-keys"
