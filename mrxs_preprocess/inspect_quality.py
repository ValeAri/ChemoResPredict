#!/usr/bin/env python
# http://www.jpathinformatics.org/article.asp?issn=2153-3539;year=2013;volume=4;issue=1;spage=27;epage=27;aulast=Goode
#
#% Author: ville.rantanen@helsinki.fi   2019 01

import os
import sys
import numpy
from PIL import Image
from argparse import ArgumentParser

def get_options():
    parser=ArgumentParser(description = "Inspect the quality of an image")
    parser.add_argument(
        "--white",
        action = "store",
        dest = "white",
        type = int,
        default = 255,
        help = "Definition of white [Default %(default)s]"
    )
    parser.add_argument(
        "--white-ratio",
        action = "store",
        dest = "white_ratio",
        type = float,
        default = 0.2,
        help = "If image contains white color (defined with --white) more than the value (fraction of image), then fail [Default %(default)s]. Zero will skip the test."
    )
    parser.add_argument(
        "--sharpness",
        action = "store",
        dest = "sharpness",
        default = 0.05,
        type = float,
        help = "If sharpness less than given value, then fail [Default %(default)s]. Zero will skip the test."
    )
    parser.add_argument(
        "--size",
        action = "store",
        dest = "size",
        default = 0,
        type = int,
        help = "If file size is less than given value, then fail [Default %(default)s]. Zero will skip the test."
    )
    parser.add_argument(
        'image',
        action = "store",
        help = "Image to inspect"
    )
    options = parser.parse_args()
    return options

#Quality test
def test_image(options):
    if options.size > 0:
        if os.stat(options.image).st_size < options.size:
            sys.stderr.write("Fail Quality: File size %d < %d\n" % ( os.stat(options.image).st_size, options.size)) #Size control
            return False

    im = numpy.array(Image.open(options.image).convert("L")) # convert image to monochrome

    if options.white_ratio > 0:
        wr = white_ratio(im, options.white)
        print(wr)
        if wr > options.white_ratio:
            sys.stderr.write("Fail Quality: White ratio %.2f > %.2f\n" % ( wr, options.white_ratio ))
            return False

    if options.sharpness > 0:
        s = sharpness(im)
        print(s)
        if s < options.sharpness:
            sys.stderr.write("Fail Quality: Sharpness %.3f < %.3f\n" % ( s, options.sharpness ))
            return False

    return True


def white_ratio(img, white):
    return float((img >= white).sum()) / ( img.shape[0] * img.shape[0] )


def sharpness(img):
    img = numpy.float32(img)
    img = img - img.mean()
    img = img / img.std()
    vertical = abs(img[1:, ::] - img[0:-1, ::]).sum()
    horizontal = abs(img[::, 1:] - img[::, 0:-1]).sum()
    value = ( vertical + horizontal ) / ( 2 * img.shape[0] * img.shape[1])
    return value

if __name__ == "__main__":
    options = get_options()

    sys.stderr.write(options.image + "\n")
    if test_image(options):
        sys.exit(0) #exit without errors
    else:
        sys.exit(1) #there is/are issue(s)/error(s)/problems(s)



