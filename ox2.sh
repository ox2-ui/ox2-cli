#!/bin/bash

#
#     Package folder symlinking
#

link_package() {
  if [ -d "packages/oo-$1" ]; then
    echo "Package: ox2:$1 already linked"
  elif [ -d "$HOME/Projects/ox2/ox2:$1" ] ; then
    # create 'packages' dir if not present
    mkdir -p packages
    echo "Linking package: $1"
    ln -s ~/Projects/ox2/ox2:$1 packages/oo-$1
  else
    echo "Error: package 'ox2:$1' not found in ~/Projects/ox2/"
  fi
}

unlink_package() {
  if [ -d "packages/oo-$1" ]; then
    echo "Unlinking package: $1"
    rm -f packages/oo-$1
  else
    echo "Package ox2:$1 is not linked"
  fi
}

#
#     Package handling
#

add_meteor_package() {
  echo "> meteor add ox2:$1"
  meteor add ox2:$1
}

remove_meteor_package() {
  echo "> meteor remove ox2:$1"
  meteor remove ox2:$1
}

add_package() {
  link_package $1
  if [ -d "packages/oo-$1" ] ; then
    add_meteor_package $1
  else
    echo "Package was not added to your meteor app"
  fi
}

remove_package() {
  remove_meteor_package $1
  unlink_package $1
}

#
#     Platform tools
#

# ox2 platform package name list
platform_packages=( detective helpers normalize font-roboto font-roboto-condensed typography icons-spark colors layout buttons parts scroller panels modals forms tabs datetime-picker banner sortable text-display google-maps filesaver loader log-helpers )

# ox2 platform package name list prefixed with organization
for package in ${platform_packages[@]}; do
  prefixed_platform_packages="${prefixed_platform_packages} ox2:${package}"
done


add_platform() {
  echo "Adding ox2 platform..."
  # Link all platfomr packages first to avoid package dependency errors in console
  for package in ${platform_packages[@]}; do
    link_package ${package}
  done
  meteor add ${prefixed_platform_packages}
}

remove_platform() {
  echo "Removing ox2 platform..."
  # Remove all meteor packages first to avoid package dependency issues
  meteor remove ${prefixed_platform_packages}
  for package in ${platform_packages[@]}; do
    unlink_package ${package}
  done
}

#
#     Commands
#

if [ "$1" = "add" ] ; then
  add_package $2
elif [ "$1" = "remove" ] ; then
  remove_package $2
elif [ "$1" = "link" ] ; then
  link_package $2
elif [ "$1" = "unlink" ] ; then
  unlink_package $2
elif [ "$1" = "platform-add" ] ; then
  add_platform
elif [ "$1" = "platform-remove" ] ; then
  remove_platform
else
  echo "Use: ox2 <command>"
  echo "Command list:"
  echo " * add <packagename> - to link and add local ox2 package to your app"
  echo " * remove <packagename> - to unlink and remove local ox2 package from your app"
  echo " * link <packagename> - to link local ox2 package to your project folder"
  echo " * unlink <packagename> - to unlink local ox2 package to your project folder"
  echo " * platform-add - to add the ox2 platform"
  echo " * platform-remove - to remove the ox2 platform"
fi
