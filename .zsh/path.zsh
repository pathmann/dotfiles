prefpathdirs=(
	~/.cargo/bin
)

pathdirs=(
  ~/bin
  /usr/sbin
  /media/PROJECTS/osxcross/target/bin
  ~/.local/bin
)

for dname in $prefpathdirs; do
	if [ -d $dname ]; then
		path=($dname $path)
	fi
done

for dname in $pathdirs; do
    if [ -d $dname ]; then
        path+=$dname
    fi
done
