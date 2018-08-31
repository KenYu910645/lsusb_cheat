#! /bin/bash
get_dev=$(ls /dev/ttyA*; ls /dev/ttyU*; ls /dev/video*)

echo "Finding USB device, this might take a while"
declare -i idx=1 
until [ -z "$(echo ${get_dev} | cut -d " " -f${idx})" ]
do
    dev_name=$(echo ${get_dev} | cut -d " " -f${idx})
    idx=idx+1
    dev_name=${dev_name:5}
    
    udevadm info -a -n ${dev_name} > udev_buff.txt
    devpath=$(cat udev_buff.txt | grep ATTRS{devpath}== | cut -d "\"" -f2 | head -n 1)
    
    idVendor=$(cat udev_buff.txt | grep ATTRS{idVendor}== | cut -d "\"" -f2 | head -n 1)

    idProduct=$(cat udev_buff.txt | grep ATTRS{idProduct}== | cut -d "\"" -f2 | head -n 1)

    product_name=$(lsusb | grep ${idVendor}:${idProduct} | head -n 1)
    product_name=${product_name:33}
    if [ ! -n "$product_name" ]; then
        product_name=$(cat udev_buff.txt | grep ATTRS{product}== | cut -d "\"" -f2 | head -n 1)
    fi
    symlink=$(ls /dev/ -al | grep "\->" | grep ${dev_name} | awk '{print $9}')
    echo " "
    echo -e "************  \033[1;33m${product_name}\033[0m       ***************"
    echo -e "dev_name         : \033[1;31m${dev_name}\033[0m"
    echo    "ATTRS{devpath}   : "${devpath}
    echo    "ATTRS{idVendor}  : "${idVendor}
    echo    "ATTRS{idProduct} : "${idProduct}
    echo -e "SYMLINK          : \033[1;31m${symlink}\033[0m"

done
