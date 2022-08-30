pathdirs=(
  ~/bin
  /usr/sbin
  /media/PROJECTS/osxcross/target/bin
  ~/.local/bin
  ~/.cargo/bin
)

for dir in $pathdirs; do
    if [ -d $dir ]; then
        path+=$dir
    fi
done
