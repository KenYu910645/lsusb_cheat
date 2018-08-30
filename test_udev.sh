#! /bin/bash

get_dev=$(ls /dev/ttyA*; ls /dev/ttyU*)

declare -i idx=1 
until [ -z "$(echo ${get_dev} | cut -d " " -f${idx})" ]
do
    dev_name=$(echo ${get_dev} | cut -d " " -f${idx})
    idx=idx+1

    dev_name=${dev_name:5}
    udevadm=$(udevadm info -a -n ${dev_name})
    echo ${udevadm}
    devpath=$(udevadm info -a -n ${dev_name} | grep ATTRS{devpath}== | cut -d "\"" -f2)
    devpath=$(echo ${devpath} | cut -d " " -f1)

    idVendor=$(udevadm info -a -n  ${dev_name} | grep ATTRS{idVendor}== | cut -d "\"" -f2)
    idVendor=$(echo ${idVendor} | cut -d " " -f1)

    idProduct=$(udevadm info -a -n  ${dev_name} | grep ATTRS{idProduct}== | cut -d "\"" -f2)
    idProduct=$(echo ${idProduct} | cut -d " " -f1)

    product_name=$(lsusb | grep ${idVendor}:${idProduct})
    product_name=${product_name:33}
    echo " "
    echo "************     "${product_name}"     ***************"
    echo "dev_name  : "${dev_name}
    echo "ATTRS{devpath}   : "${devpath}
    echo "ATTRS{idVendor}  : "${idVendor}
    echo "ATTRS{idProduct} : "${idProduct}
done
