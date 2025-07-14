#!/bin/sh
echo "CONF_kayid=0x<your_key_1>"
echo "CONF_kayid2=0x<your_key_2>"

echo "CONF_pkgsdir2=<dir_containing_genisoimage>"
echo "CONF_gi_opts=<opts_4_genisoimage>"
echo "CONF_targetdir="
echo "CONF_BASEDIR=<sourcedir 4 many things>"

echo "TARGET_archdir0=<base_4_archive_dir>"
echo "TARGET_archdir=\$TARGET_archdir0/<$CONF_target 4 archiving stuff>"
echo "TARGET_backup_part=disk/by-uuid/<devicefile reserved for archiving>"

echo "TARGET_scripts_bak_file=<file to archive scripts>"
echo "TARGET_pad_bak_file=<file to archive .iso's additional stuff>"

echo -n "TARGET_DTAR_OPTS=\"--exclude=*.bz3"
echo -n " --exclude=\$TARGET_Dkname2\"" 
echo

echo "TARGET_pad_dir="
echo "TARGET_padfile="
echo "TARGET_pad2="

echo "TARGET_Dkname1=<filename correllating to $CONF_kayid>"
echo "TARGET_Dkname2=<filename correllating to CONF_kayid2>"

echo "TARGET_DIGESTS_dir=\$TARGET_pad_dir/<dir containing digests>"
echo "TARGET_DIGESTS_file0=<base filename 4 digests>"
echo "TARGET_DIGESTS_file=\$TARGET_DIGESTS_dir/\$TARGET_DIGESTS_file0"

echo "TARGET_Dpubkf=\$TARGET_DIGESTS_dir/\$TARGET_Dkname1"
echo "TARGET_Dpubkg=\$TARGET_DIGESTS_dir/\$TARGET_Dkname2"

echo "CONF_scripts_dir=<dir containing necessary scripts>"
echo "CONF_keys_dir=<dir 4 keys>"
echo "CONF_stg0file="

echo "CONF_tmpdir0= < base_dir 4 temporary files > "

echo "CONF_squash0=\$CONF_tmpdir0/\$CONF_squash"
echo "CONF_squash_dir=\$CONF_squash0/squashfs-root"

echo "the line $CONF_squash0 ext2 noauto,user,exec,suid,dev 0 0 should be found in /etc/fstab"

echo "CONF_tmpdir=\$CONF_tmpdir0/ < temp dir 4 additional stuff > "
echo -n "CONF_source=\$CONF_tmpdir/< temporary mount point 4 base > "

echo "CONF_target=\$CONF_tmpdir/< target where base and additional stuff are copied , different from \$CONF_squash  and \$CONF_source -dirs>"
echo "CONF_bloader=<preferred bootloader>"
echo "CONF_distros_dir=<Directory Supposed To Contain Distro .isos To Modify, inspired by Karl Sanders >"

echo "CONF_wget_opts=\"--https-only --show-progress\""
echo "CONF_wget_def_url=https://<add mirror url here>"

echo "TARGET_DHCP_row1=\"<options 4 dhclient>\""

echo "CONF_patch_name="
echo "CONF_patch_list_1=\"<options 4 stage0.copy_conf()>\""
echo "CONF_patch_list_2=\"<more options 4 stage0.copy_conf()>\""
