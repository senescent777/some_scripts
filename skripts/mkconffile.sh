#!/bin/sh

echo "CONF_pkgsdir2=dir_containing_genisoimage"
echo "CONF_gi_opts=opts_4_genisoimage"
echo "CONF_BASEDIR=sourcedir_4_many_things"

echo "#TARGET_DTAR_OPTS vs TPX? "

echo "TARGET_pad_dir= #necessary?"
echo "TARGET_pad2= #necessary?"
echo "TARGET_DIGESTS_dir=\$TARGET_pad_dir/dir_containing_digests"
echo "TARGET_DIGESTS_file0=base_filename_4_digests"
echo "TARGET_DIGESTS_file=\$TARGET_DIGESTS_dir/\$TARGET_DIGESTS_file0"

echo "#TARGET_Dpubkf=\$TARGET_DIGESTS_dir/\$TARGET_Dkname1 #see keys.conf.example"
echo "#TARGET_Dpubkg=\$TARGET_DIGESTS_dir/\$TARGET_Dkname2 #see keys.conf.example"

echo "CONF_scripts_dir=dir containing necessary scripts"
echo "CONF_keys_dir=dir_4_keys"
echo "CONF_keys_dir_pub=/only_pub_keys_here"

echo "CONF_tmpdir0=base_dir_4_temporary_files"
echo "CONF_tmpdir=\$CONF_tmpdir0/temp_dir_4_additional_stuff"

echo "CONF_squash0=\$CONF_tmpdir0/\$CONF_squash #squ.ash"
echo "CONF_squash_dir=\$CONF_squash0/squashfs-root #squ.ash"
echo "#the line $CONF_squash0 ext2 noauto,user,exec,suid,dev 0 0 should be found in /etc/fstab ?"

echo -n "CONF_source=\$CONF_tmpdir/temporary_mount_point_4_base"
echo "CONF_target=\$CONF_tmpdir/target_where_base _nd_additional_stuff_are_copied #, different from \$CONF_squash  and \$CONF_source -dirs"
echo "CONF_bloader=preferred_bootloader"

