# Update MOUNT_PARTITIONS_LIST var with input from PARTITIONS_IMAGES enabled
python set_partitions_list() {
    partitionsconfig = (d.getVar('PARTITIONS_IMAGES') or "").split()

    if len(partitionsconfig) > 0:
        partitionsconfigflags = d.getVarFlags('PARTITIONS_IMAGES')
        # The "doc" varflag is special, we don't want to see it here
        partitionsconfigflags.pop('doc', None)

        for config in partitionsconfig:
            for f, v in partitionsconfigflags.items():
                if config == f:
                    items = v.split(',')
                    # Make sure a mount point is available
                    if len(items) > 2 and items[1] and items[2]:
                        if items[1] == '${STM32MP_USERFS_LABEL}':
                            bb.debug(1, "Appending '%s,%s' to MOUNT_PARTITIONS_LIST." % (items[1], items[2]))
                            d.appendVar('MOUNT_PARTITIONS_LIST', ' ' + items[1] + ',' + items[2])
                        else:
                            bb.debug(1, "Appending '%s-a,%s' to MOUNT_PARTITIONS_LIST." % (items[1], items[2]))
                            d.appendVar('MOUNT_PARTITIONS_LIST', ' ' + items[1] + '-a' + ',' + items[2])
                    break
}
