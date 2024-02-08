#!/bin/bash

# This file is part of Espruino, a JavaScript interpreter for Microcontrollers
#
# Copyright (C) 2017 Gordon Williams <gw@pur3.co.uk>
# wilberforce (Rhys Williams)
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# -----------------------------------------------------------------------------
# Setup toolchain and libraries for build targets, installs if missing
# set env vars for builds
# For use in:
#    Travis
#    Firmware builds
#    Docker
#
# -----------------------------------------------------------------------------

if [ $# -eq 0 ]
then
  echo "USAGE:"
  echo "  source scripts/provision.sh {BOARD}"
  echo "  source scripts/provision.sh ALL"
  return 1
fi

# set the current board
BOARDNAME=$1

if [ "$BOARDNAME" = "ALL" ]; then
  echo "Installing dev tools for all boards"
  PROVISION_ESP32=1
  PROVISION_ESP8266=1
  PROVISION_LINUX=1
  PROVISION_NRF52=1
  PROVISION_NRF51=1
  PROVISION_NRF_SDK15=1
  PROVISION_NRF_SDK15_3=1
  PROVISION_NRF_SDK17=1
  PROVISION_STM32F1=1
  PROVISION_STM32F4=1
  PROVISION_STM32L4=1 
  PROVISION_RASPBERRYPI=1 
else
  FAMILY=`scripts/get_board_info.py $BOARDNAME 'board.chip["family"]'`
  if [ "$FAMILY" = "" ]; then
    echo "UNKNOWN BOARD ($BOARDNAME)"
    return 1
  fi  
  export PROVISION_$FAMILY=1
  export PROVISION_$BOARDNAME=1
  if python scripts/get_makefile_decls.py $BOARDNAME | grep NRF_SDK17; then
    PROVISION_NRF_SDK17=1
  fi
  if python scripts/get_makefile_decls.py $BOARDNAME | grep NRF_SDK15_3; then
    PROVISION_NRF_SDK15_3=1
  elif python scripts/get_makefile_decls.py $BOARDNAME | grep NRF_SDK15; then
    PROVISION_NRF_SDK15=1
  fi
fi
echo Provision BOARDNAME = $BOARDNAME
echo Provision FAMILY = $FAMILY

if [ "$PROVISION_ESP32" = "1" ]; then
    echo ===== ESP32
    # needed for esptool for merging binaries
    if pip --version 2>/dev/null; then 
      echo python/pip installed
    else
      echo Installing python/pip pyserial
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y python python3-pip
    fi
    if pip list 2>/dev/null | grep pyserial >/dev/null; then 
      echo pyserial installed; 
    else 
      echo Installing pyserial
      sudo pip -q install pyserial
    fi    
    # SDK
    if [ ! -d "app" ]; then
        echo installing app folder
        curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/esp32/deploy/app.tgz | tar xfz - --no-same-owner
        #curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/ESP32-V3.1/esp32/deploy/app.tgz | tar xfz - --no-same-owner
    fi
    if [ ! -d "esp-idf" ]; then
        echo installing esp-idf folder
        curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/esp32/deploy/esp-idf.tgz | tar xfz - --no-same-owner
        #curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/ESP32-V3.1/esp32/deploy/esp-idf.tgz | tar xfz - --no-same-owner
    fi
    if ! type xtensa-esp32-elf-gcc 2> /dev/null > /dev/null; then
        echo installing xtensa-esp32-elf-gcc
        if [ ! -d "xtensa-esp32-elf" ]; then
           #curl -Ls https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz | tar xfz - --no-same-owner
           curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/esp32/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz | tar xfz - --no-same-owner
        else
           echo "Folder found"
        fi
    fi
    echo ESP_IDF_PATH=`pwd`/esp-idf
    echo ESP_APP_TEMPLATE_PATH=`pwd`/app
    echo "PATH=\$PATH:`pwd`/xtensa-esp32-elf/bin/"
    export ESP_IDF_PATH=`pwd`/esp-idf
    export ESP_APP_TEMPLATE_PATH=`pwd`/app
    export PATH=$PATH:`pwd`/xtensa-esp32-elf/bin/
    echo GCC is $(which xtensa-esp32-elf-gcc)
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_ESP8266" = "1" ]; then
    echo ===== ESP8266
    if [ ! -d "ESP8266_NONOS_SDK-2.2.1" ]; then
        echo ESP8266_NONOS_SDK-2.2.1
        curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/esp8266/ESP8266_NONOS_SDK-2.2.1.tar.gz | tar xfz - --no-same-owner
    fi
    if ! type xtensa-lx106-elf-gcc 2> /dev/null > /dev/null; then
        echo installing xtensa-lx106-elf-gcc
        if [ ! -d "xtensa-lx106-elf" ]; then
            curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/esp8266/xtensa-lx106-elf-20160330.tgx | tar Jxf - --no-same-owner
        else
            echo "Folder found"
        fi

    fi
    export ESP8266_SDK_ROOT=`pwd`/ESP8266_NONOS_SDK-2.2.1
    export PATH=$PATH:`pwd`/xtensa-lx106-elf/bin/
    echo GCC is $(which xtensa-lx106-elf-gcc)
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_LINUX" = "1" ]; then
    echo ===== LINUX
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_RASPBERRYPI" = "1" ]; then
    echo ===== RASPBERRYPI
    if [ ! -d "targetlibs/raspberrypi" ]; then
        echo Installing Raspberry pi tools
        mkdir targetlibs/raspberrypi        
        cd targetlibs/raspberrypi
        git clone --depth=1 https://github.com/raspberrypi/tools
        # wiringpi?
        cd ../..
    fi    
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_NRF52" = "1" ]; then
    echo ===== NRF52
    if ! type pip 2> /dev/null > /dev/null; then
      echo Installing python and pip
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq -y python python-pip
    fi
    if ! type nrfutil 2> /dev/null > /dev/null; then
      echo Installing nrfutil
      sudo pip install --ignore-installed nrfutil protobuf==3.17.3
      # --ignore-installed is used because pip 10 fails because PyYAML was already installed by the system
      # protobuf-3.17.3 is required because it seems protobuf-3.18 which auto-installs as of ~15 sept 2021 is incompatible with Python 2.7
      # -q can be used to silence the above
    fi
    ARM=1

fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_NRF51" = "1" ]; then
    ARM=1
fi
if [ "$PROVISION_NRF_SDK15" = "1" ]; then
    if [ ! -d "targetlibs/nrf5x_15/components" ]; then
        echo Installing NRF SDK 15.0 to targetlibs/nrf5x_15/components
        curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/nrf52/nRF5_SDK_15.0.0_a53641a_no_docs_unix.zip -o nRF5_SDK_15.0.0_a53641a.zip
        # This is nRF5_SDK_15.0.0_a53641a.zip without the docs/examples folder, and with line endings converted to unix (for patch)
        unzip -q -o nRF5_SDK_15.0.0_a53641a.zip
        cp -r nRF5_SDK_15.0.0_a53641a/external/* targetlibs/nrf5x_15/external 
        rm -rf nRF5_SDK_15.0.0_a53641a/external       
        cp -r nRF5_SDK_15.0.0_a53641a/* targetlibs/nrf5x_15
        rm -rf nRF5_SDK_15.0.0_a53641a.zip nRF5_SDK_15.0.0_a53641a
        echo ======================================================
        echo "FIXME - SDK15 NFC patches don't apply cleanly"
        echo ======================================================
        cat targetlibs/nrf5x_15/patches/* | patch -p1 || true
    fi
fi
if [ "$PROVISION_NRF_SDK15_3" = "1" ]; then
    if [ ! -d "targetlibs/nrf5x_15_3/components" ]; then
        echo Installing NRF SDK 15.3 to targetlibs/nrf5x_15_3/components
        curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/nrf52/nRF5_SDK_15.3.0_59ac345_no_docs_unix.zip -o nRF5_SDK_15.3.0_59ac345.zip
        # This is nRF5_SDK_15.0.0_a53641a.zip without the docs/examples folder, and with line endings converted to unix (for patch)
        unzip -q -o nRF5_SDK_15.3.0_59ac345.zip
        cp -r nRF5_SDK_15.3.0_59ac345/external/* targetlibs/nrf5x_15_3/external 
        rm -rf nRF5_SDK_15.3.0_59ac345/external       
        cp -r nRF5_SDK_15.3.0_59ac345/* targetlibs/nrf5x_15_3
        rm -rf nRF5_SDK_15.3.0_59ac345.zip nRF5_SDK_15.3.0_59ac345
        echo ======================================================
        echo "FIXME - SDK15 NFC patches don't apply cleanly"
        echo ======================================================
        cat targetlibs/nrf5x_15_3/patches/* | patch -p1 || true
    fi
fi
if [ "$PROVISION_NRF_SDK17" = "1" ]; then
    if [ ! -d "targetlibs/nrf5x_17/components" ]; then
        echo Installing NRF SDK 17.0 to targetlibs/nrf5x_17/components
        curl -Ls https://github.com/espruino/EspruinoBuildTools/raw/master/nrf52/nRF5_SDK_17.0.2_d674dde_no_docs_unix -o nRF5_SDK_17.zip
        # This is nRF5_SDK_17.0.2_d674dde.zip without the docs/examples folder, and with line endings converted to unix (for patch)
        unzip -q -o nRF5_SDK_17.zip
        cp -r nRF5_SDK_17.0.2_d674dde/external/* targetlibs/nrf5x_17/external
        rm -rf nRF5_SDK_17.0.2_d674dde/external
        cp -r nRF5_SDK_17.0.2_d674dde/* targetlibs/nrf5x_17
        rm -rf nRF5_SDK_17.zip nRF5_SDK_17.0.2_d674dde
        echo ======================================================
        cat targetlibs/nrf5x_17/patches/* | patch -p1
    fi
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_STM32F1" = "1" ]; then
    ARM=1
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_STM32F3" = "1" ]; then
    ARM=1
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_STM32F4" = "1" ]; then
    ARM=1
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_STM32L4" = "1" ]; then
    ARM=1
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_EFM32GG" = "1" ]; then
    ARM=1
fi
#--------------------------------------------------------------------------------
if [ "$PROVISION_SAMD" = "1" ]; then
    ARM=1
fi
#--------------------------------------------------------------------------------


if [ "$ARM" = "1" ]; then
    # defaulting to ARM
    echo ===== ARM
    EXPECTEDARMGCCVERSION="13.2.1"
    EXPECTEDARMGCCFILENAME="arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi"
    if type arm-none-eabi-gcc 2> /dev/null > /dev/null; then
        ARMGCCVERSION=$(arm-none-eabi-gcc -dumpfullversion)
        echo arm-none-eabi-gcc installed, version $ARMGCCVERSION    
        if [ ! "$ARMGCCVERSION" = "$EXPECTEDARMGCCVERSION" ]; then
          echo "*********************************************************************"
          echo "*********************************************************************"
          echo "***                                                               ***"
          echo "*** ARM GCC IS INSTALLED ALREADY, BUT IS NOT THE EXPECTED VERSION ***"
          echo "***                                                               ***"
          echo "***   The build may work with your compiler version, but it       ***"
          echo "***   is possible you will encounter errors, or issues with       ***"
          echo "***   build size                                                  ***"
          echo "***                                                               ***"
          echo "*********************************************************************"
          echo "*********************************************************************"
          echo "      Expected $EXPECTEDARMGCCVERSION"
          echo "      Got      $ARMGCCVERSION"
        fi    
    else
        echo "installing gcc-arm-embedded to Espruino/$EXPECTEDARMGCCFILENAME/bin"
        #sudo add-apt-repository -y ppa:team-gcc-arm-embedded/ppa
        #sudo apt-get update
        #sudo DEBIAN_FRONTEND=noninteractive apt-get --force-yes --yes install libsdl1.2-dev gcc-arm-embedded
        # Unpack - newer, and much faster
        if [ ! -d "$EXPECTEDARMGCCFILENAME" ]; then
          curl -Ls "https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz" | tar xfJ - --no-same-owner
        else
            echo "Folder found"
        fi
	      export PATH=$PATH:`pwd`/$EXPECTEDARMGCCFILENAME/bin
    fi
fi
