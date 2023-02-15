ext="jnoortheen.nix-ide-0.2.1"
URL=`echo $ext | sed -rn 's/(.*)\.(.*)-(.*)/https:\/\/marketplace.visualstudio.com\/_apis\/public\/gallery\/publishers\/\1\/vsextensions\/\2\/\3\/vspackage/p'`
echo "Downloading $URL to $ext.vsix..."
#curl --compressed -sLo- $URL | head -2 
curl --compressed -sL $URL -o test.vsix
echo "Fin"
