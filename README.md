# Recovery Method with Boot Detection

The following instructions provide a guide on how to use the Recovery Method with Boot Detection for installing Windows.

> The procedure includes three stages: first, you need to get the boot.wim file ready; second, you need to make sure you are prepared for recovery; and lastly, you can proceed with installing Windows.

## Preparing the boot.wim file

1. Copy the boot.wim file from the Windows installation ISO to the PATCH_BOOT folder.
2. Run the cmd script as an administrator.
3. Replace the original boot.wim file with the patched one in the ISO.

## Preparing for recovery

1. Copy the contents of the "ISO" folder, including the 2 xml files (efi.xml, mbr.xml) and the sysprep.cmd file to the root of your Windows installation ISO.
2. Copy the recovery folder to the root of your ISO and the $oem$ folder to the sources folder.
3. If you need customisations, modify the xml and configuration files in the "Custom Installation" folder and save the changes to the ISO.

## Installing Windows

After the Windows installation is finished, you should sign in to the Administrator profile and install any essential software or drivers that are required. Additionally, you need to activate Windows and any other Microsoft products that you want to use.

> When you are installing Windows, an answer file will be used to create the necessary partitions for the recovery process. You just need to continue with the installation process until the required files are copied.

After everything is ready, run the sysprep.cmd script to start the recovery process, which offers two options:

    ### Push-Button Reset
    The "Push-Button Reset" option allows you to recover Windows without relying on a recovery image. This approach reconstructs the new Windows installation using the current installation while keeping all the drivers, updates, and the build intact. You can also choose to keep your personal files or erase everything, depending on your preference.

    ### Full Image
    The "Full Image" option will wipe out the hard drive entirely and reinstall Windows using the original image, along with all the patches, drivers, and software that were present when the recovery was created. This method requires more space on the hard drive and is typically recommended for larger hard drives.

> After the recovery process has finished, the computer will be restored to a state where it is ready to be used. If you would like to change the default wallpaper that appears after recovery, you can delete the Wallpapers.zip file located in the C:\Recovery\OEM\Manufacturer folder.
