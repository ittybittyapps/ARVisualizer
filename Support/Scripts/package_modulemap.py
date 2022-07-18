#!/usr/bin/python3

#
#  Copyright (c) 2018 Itty Bitty Apps Pty Ltd. All rights reserved.
#

import sys
import shutil
from os import environ, path, makedirs

def main(args):
    input_file = environ['SCRIPT_INPUT_FILE_0']
    built_products_directory = environ['BUILT_PRODUCTS_DIR']
    public_headers_directory_name = environ['PUBLIC_HEADERS_FOLDER_PATH']

    output_directory = path.join(built_products_directory, public_headers_directory_name)

    # Create the path to the destination file if it's missing
    if not path.exists(output_directory):
        makedirs(output_directory)

    # Copy the file using `copy2` so that file metadata (such as timestamps) is preserved. If the timestamps aren't preserved, Xcode will do a full (non-incremental) build every time.
    output_file = path.join(output_directory, 'module.modulemap')
    shutil.copy2(input_file, output_file)

    exit(0)

if __name__ == "__main__":
    main(sys.argv)
