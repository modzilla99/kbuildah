#!/bin/bash

KERN=kernel-${KVER}.fc${FVER}.src.rpm
RPM=~/rpmbuild
KSPEC=${RPM}/SPECS/kernel.spec

echo "Setting up workspace..."
koji download-build --arch=src $KERN
rpmdev-setuptree
rpm -Uvh $KERN
rm -f $KERN
cp --force /patches/* ${RPM}/SOURCES/

echo "Setup successful... Patching kernel.spec to add patches..."

sed -i -e "s/# define buildid .local/%define buildid .${NAME}/g" $KSPEC

patches=( $(ls /patches) )

START=0
((END = ${#patches[@]} - 1))
i=$START
echo $END
while [[ $i -le $END ]]
do
    if [[ $i -lt "10" ]]
    then
        sed -i "s/# END OF PATCH DEFINITIONS/Patch900$i: ${patches[$i]}\n# END OF PATCH DEFINITIONS/" $KSPEC
    elif [[ $i -lt "100" ]]
    then
        sed -i "s/# END OF PATCH DEFINITIONS/Patch90$i: ${patches[$i]}\n# END OF PATCH DEFINITIONS/" $KSPEC
    fi
    ((i = i + 1))
done

echo "Added follwing patches to the kernel.spec:"
echo ${patches[@]}


rpmbuild -bb --with baseonly --without debug --without debuginfo --target=$ARCH $KSPEC

[[ $? -ne 0 ]] && {
    echo "Error while compiling, please report!"
    exit 1
}

cp -r ${RPM}/RPMS /out/
echo "Copied rpms to /out"