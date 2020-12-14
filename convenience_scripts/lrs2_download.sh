#!/bin/bash

if ! command -v wget &> /dev/null
then
    echo 'wget is not installed or in $PATH.'
    exit 1
fi

if [ -z "$LRS2_USERNAME" ] || [ -z "$LRS2_PASSWORD" ]
then
    echo 'LRS2_USERNAME or LRS2_PASSWORD environment variable is not set. Please set them to continue downloading.'
    exit 1
fi
echo 'Starting LRS2 dataset download to ./lrs2/'

echo 'Creating ./lrs2/'
mkdir -p ./lrs2/

echo 'Changing directory to ./lrs2/'
cd ./lrs2/ || exit 1

echo 'Downloading dataset parts sequentially'
for letter in {a..e}
do
    echo "Downloading parta$letter"
    wget --user "$LRS2_USERNAME" --password "$LRS2_PASSWORD" --continue "https://www.robots.ox.ac.uk/~vgg/data/lip_reading/data2/lrs2_v1_parta$letter"
done

echo 'Downloading filelists'
for file in 'pretrain.txt' 'train.txt' 'val.txt' 'test.txt'
do
    echo "Downloading filelist $file"
    wget --user "$LRS2_USERNAME" --password "$LRS2_PASSWORD" --continue "https://www.robots.ox.ac.uk/~vgg/data/lip_reading/data2/$file"
done

echo 'To combine all the parts into one .tar file, run the following command'
echo 'cat lrs2_v1_parta* > lrs2_v1.tar'
