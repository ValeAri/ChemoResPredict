# Tools to export and filter MRXS images

## Requirements

- Python
- PIL for python
- openslide for python


## Usage

Have MRXS files in a folder, as in:
```
.
└─── data_demo/
   ├── 1M02
   │   ├── Data0000.dat
   │   ├── Data0001.dat
   │   └── ....
   ├── 1M02.mrxs
   ├── 1M16
   │   └── ....
   └── 1M16.mrxs
```

Run the exporter:

`./convert_mrxs data_demo/ exported_demo/`

The export will have a lot of images with mostly glass in the image. Some
of the images may be blurry. See the script `filter_pngs`. It has two
parameters to set filtering, `WHITE_RATIO` and `SHARPNESS`. White ratio
determines how many pixels may be white. Setting it 0.2 means, any image
that is more than 20% white, will be discarded. Sharpness value is used to
discard images that are out-of-focus. An arbitrary value 0.07 means that 
images will less sharpness are discarded. The correct value must be decided 
experimentally.

To run filtering, execute: `./filter_pngs exported_demo/ filtered_demo/`




