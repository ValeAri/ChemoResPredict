#!/usr/bin/env python
# http://www.jpathinformatics.org/article.asp?issn=2153-3539;year=2013;volume=4;issue=1;spage=27;epage=27;aulast=Goode
#
#% Author: ville.rantanen@helsinki.fi   2019 01

import openslide
import math
import os
import sys
import numpy
from PIL import Image
from argparse import ArgumentParser

def get_options():
    parser=ArgumentParser(description="Convert .mrxs to PNG image format. Extract other associated images as JPEG.")
    parser.add_argument(
        "-f",
        action = "store_true",
        dest = "force",
        default = False,
        help = "Force overwriting of files."
    )
    parser.add_argument(
        "-l",
        action = "store",
        dest = "level",
        default = 1,
        type = int,
        help = "Rescale resolution: 0=original, 1=half, 2=quarter... etc, [Default %(default)s]"
    )
    parser.add_argument(
        "-t",
        action = "store_true",
        dest = "transparency",
        default = False,
        help = "If set, nonexisting pixels are transparent. By default, those pixels are white."
    )
    parser.add_argument(
        "-a",
        action = "store_true",
        dest = "writeAll",
        default = False,
        help = "If set, write tiles even if there is no content."
    )
    parser.add_argument(
        "-w",
        action = "store",
        dest = "width",
        default = 1250,
        type = int,
        help = "Width (and height) of output images. [Default %(default)s]"
    )
    parser.add_argument(
        "-v",
        action = "store_true",
        dest = "verbose",
        default = False,
        help = "More verbose output."
    )
    parser.add_argument(
        'MRXS',
        action = "store",
        help = "The .mrxs file & folder to convert."
    )
    parser.add_argument(
        'output_name',
        action = "store",
        help = "Output folder. Images exported in the folder. Metadata exported to folder_metadata.jpg"
    )
    options = parser.parse_args()
    return options


def found_data(img):
    return numpy.array(img).sum() > 0


def remove_transparency(im, bg_colour=(255, 255, 255)):

    if im.mode in ('RGBA', 'LA') or (im.mode == 'P' and 'transparency' in im.info):
        alpha = im.convert('RGBA').split()[-1]
        bg = Image.new("RGBA", im.size, bg_colour + (255,))
        bg.paste(im, mask=alpha)
        return bg.convert('RGB')
    else:
        return im


def write_if_data(img, name):
    if not options.writeAll:
        if not found_data(img):
            return False
    if options.verbose:
        print("Found data, write image: " + name)
    if not options.transparency:
        img = remove_transparency(img)
    img.save(name)
    #~ if not options.transparency:
        #~ subprocess.call("mogrify -background white -flatten \"%s\""%(name,), shell=True)
    return True


def extract_associated_images(reader, out_dir, options):
    for ass in reader.associated_images:
        fname = "%s_%s.jpg" % (out_dir, ass)
        if options.verbose:
            print( "Associated image: %s" % ( fname, ) )
        reader.associated_images[ass].save(fname)


if __name__ == "__main__":

    options = get_options()
    scaledown = int( math.pow(2, options.level) )
    out_dir = os.path.realpath(options.output_name)

    if os.path.isdir(out_dir):
        if not options.force:
            print("path %s exist!"%(out_dir,))
            sys.exit(1)
    else:
        os.mkdir(out_dir)

    reader = openslide.OpenSlide(options.MRXS)
    extract_associated_images(reader, out_dir, options)

    dim_pad = str(max( [len(str(x)) for x in reader.dimensions] ))
    out_dims = [float(x)/scaledown for x in reader.dimensions]
    out_blocks = ( int(math.ceil( out_dims[0]/options.width )), int(math.ceil( out_dims[1]/options.width )) )

    
    for y in range(out_blocks[1]):
        for x in range(out_blocks[0]):
            y_px = y * options.width
            x_px = x * options.width

            if options.verbose:
                sys.stdout.write(
                    "%d/%d\n" % (
                        x + out_blocks[0] * y,
                        out_blocks[0] * out_blocks[1]
                    )
                )

            wrote = write_if_data(
                reader.read_region(
                    (
                      scaledown * x_px,
                      scaledown * y_px
                    ),
                    options.level,
                    (options.width, options.width)
                ),
                os.path.join(
                    out_dir,
                    ("%s_-_y%0" + dim_pad + "d_x%0" + dim_pad + "d.png") % (
                        os.path.basename(options.MRXS),
                        y_px,
                        x_px
                    )
                )
            )
            if not options.verbose:
                if wrote:
                    sys.stdout.write("o")
                else:
                    sys.stdout.write(".")
            sys.stdout.flush()
        sys.stdout.write(" %d%%\n" %( 100 * (y+1) / out_blocks[1] ) )
