#!/usr/bin/env python3
# SPDX-License-Identifier: BSD-2-Clause
#
# Copyright (c) 2024, STMicroelectronics
#
# -*-check metadata crc*-

import zlib
import argparse

# if metadata is stored inside a partition, metadata struture size is
# needed to be able to compute the CRC. The size depends on
# NR_OF_FW_BANKS (default:2) and NR_OF_IMAGES_IN_FW_BANK (default:1)
# in fwu_metadata.h from tf-a.
METADATA_SIZE=96

parser = argparse.ArgumentParser()
parser.add_argument('-m', '--metadata', type=str, required=True,
                    help='need to give path to metadata partition')
args = parser.parse_args()

with open(args.metadata, 'rb') as file:
    metadata = file.read()

# CRC is uint32_t at the very beginning of the file
metadata_crc32 = int.from_bytes(metadata[:4], byteorder='little',
                                signed = False)

# CRC is computed with metadata content, except the 4 first bytes
computed_crc_32 = zlib.crc32(metadata[4:METADATA_SIZE])

if (metadata_crc32 != computed_crc_32):
    print("CRC Error")
    print("metadata_crc32: " + str(metadata_crc32))
    print("computed crc32: " + str(computed_crc_32))
else:
    print("CRC OK: " + str(metadata_crc32))
