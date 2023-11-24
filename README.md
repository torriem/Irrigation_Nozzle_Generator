Occasionally I loose a complete sprinkler from a pivot.  Although I keep spare regulator and sprinkler units on the shelf, I don't always have the correct nozzle size on hand. This OpenSCAD file creates print-able nozzles for iWob, iWob2, and Nelson -style irrigation sprinklers, using OEM standard size numbers.  Adjust the tolerance to get the oriface to the correct size. iWob and iWob2 nozzles are sized in 64ths of an inch, with in-between sizes of 0.5.  For example 18/64ths or 18.5/64ths.  Nelson uses 128ths of an inch.  For example 37/128th.

Disclaimer: these nozzles should only be used temporarily until the correct nozzle is purchased as the size may not be very accurate compared to the injection-molded OEM nozzles.

There are several parameters in the SCAD file that can be changed:

- size - size number of iwob or iwob2 nozzles (in 64ths of an inch)
- nelson_size - size number of nelson nozzle (in 128th of an inch)
- model - one of "iwob" "iwob2" "nelson" or "all".  Specify what kind of nozzle to create.  All creates one of each kind in the same file
- nozzle_tolerance - how many mm oversize to make the hole, to account for printer inprecision.  For the X1 Carbon with ABS, 0.12mm oversize ends up about right.  Can measure certain sizes with drill bit shanks.

Those parameters can be passed on the command-line with `-D`.  For example:

```
openscad -D 'model="iwob"' -D 'size=19.5' -o iwob_19_5.stl irrigation_nozzle.scad
```

A script could generate a complete set of stl files using these parameters.
