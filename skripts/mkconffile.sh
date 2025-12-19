#!/bin/sh
echo "CONF_kayid=0x_your_key_1 #(actually keys.conf)"
echo "CONF_kayid2=0x_your_key_2 #(actually keys.conf)"

echo "CONF_pkgsdir2=dir_containing_genisoimage"
echo "CONF_gi_opts=opts_4_genisoimage"
echo "CONF_targetdir="
echo "CONF_BASEDIR=sourcedir_4_many_things"

echo "TARGET_archdir0=base_4_archive_dir #(necessary)?"
echo "TARGET_archdir=\$TARGET_archdir0/\$CONF_target_4_archiving_stuff #necessary?"
echo "TARGET_backup_part=disk/by-uuid/devicefile_reserved_4_rchiving #necessary?"

echo "TARGET_scripts_bak_file=file_2_archive_scr1pts #necessary?"
echo "TARGET_pad_bak_file=file_2_archive_.iso's_additional_stuff #necessary?"

#miten tuo tuossa alla suhtautuu TPX-juttuihin?
echo -n "TARGET_DTAR_OPTS=\"--exclude=*.bz3"
echo -n " --exclude=\$TARGET_Dkname2\"" #tarpeellinen nykyään?
echo

echo "TARGET_pad_dir= #necessary?"
echo "TARGET_padfile= #necessary"
echo "TARGET_pad2= #necessary?"

echo "TARGET_Dkname1=<ilename_correllating_to_\$CONF_kayid #keys.conf"
echo "TARGET_Dkname2=filename_correllating_to_\$CONF_kayid2 #keys.conf"

echo "TARGET_DIGESTS_dir=\$TARGET_pad_dir/dir_containing_digests"
echo "TARGET_DIGESTS_file0=base_filename_4_digests"
echo "TARGET_DIGESTS_file=\$TARGET_DIGESTS_dir/\$TARGET_DIGESTS_file0"

echo "TARGET_Dpubkf=\$TARGET_DIGESTS_dir/\$TARGET_Dkname1 #keys.conf"
echo "TARGET_Dpubkg=\$TARGET_DIGESTS_dir/\$TARGET_Dkname2 #keys.conf"

echo "CONF_scripts_dir=dir containing necessary scripts"
echo "CONF_keys_dir=dir_4_keys"
echo "CONF_stg0file= #necessary?"

echo "CONF_tmpdir0=base_dir_4_temporary_files"
echo "CONF_tmpdir=\$CONF_tmpdir0/temp_dir_4_additional_stuff"

echo "CONF_squash0=\$CONF_tmpdir0/\$CONF_squash #squ.ash"
echo "CONF_squash_dir=\$CONF_squash0/squashfs-root #squ.ash"
echo "#the line $CONF_squash0 ext2 noauto,user,exec,suid,dev 0 0 should be found in /etc/fstab ?"

echo -n "CONF_source=\$CONF_tmpdir/temporary_mount_point_4_base"
echo "CONF_target=\$CONF_tmpdir/target_where_base _nd_additional_stuff_are_copied #, different from \$CONF_squash  and \$CONF_source -dirs"
echo "CONF_bloader=preferred_bootloader"
echo "#CONF_distros_dir=Directory Supposed To Contain Distro .isos To Modify, inspired by Karl Sanders "

echo "#CONF_wget_opts=\"--https-only --show-progress\""
echo "#CONF_wget_def_url=https://add,mirror,url,here"

echo "#TARGET_DHCP_row1=\"options_4_dhclient>\""
#141225:hienab päivitetty

