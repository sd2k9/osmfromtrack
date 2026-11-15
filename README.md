osmfromtrack
============

Download OSM data from a coordinate box or around a gpx file track.
When not disabled, also the topographic data will be created.


State
=====
Usable


Description
===========
Bounding Box Mode:  
    Supply with two set of coordinates (like from Google Map's LatLng marker)
    and the box will be fetched from OSM.  
    Example: osmfromtrack bbox data 61,001 22,758 60.948 22.871

GPX File Mode:  
    Extract the map bounding box from a GPX track file.
    The supplied file is read and all track points of the following
    format are considered:  
    &lt;trkpt lat="50.9816789999999" lon="14.075968"/&gt;

All points are read and a margin of 5km in all directions is applied to
calculate the bounding box.

To download the OSM map data to a Garmin eTrex30 (or compatible) device
use the tool etrex30, available from
https://github.com/sd2k9/tools/blob/master/etrex30

etrex30 can also be called from within osmfromtrack.


License
=======
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 3 as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.


Topographic Map Configuration for Debian
========================================
See also  
https://wiki.openstreetmap.org/wiki/OSM_Map_On_Garmin/Topographic_maps

The topographic overlay (contour lines) is created from the Copernicus DEM
(30 m resolution, https://registry.opendata.aws/copernicus-dem/). The elevation
tiles are read directly from a public AWS bucket, no account is required.
If you don't want a topographic map, use the command line option "--no-topo".

Please note that Copernicus GLO-30 is a digital surface model (DSM),
not a bare-earth digital terrain model (DTM).  
It can include buildings, infrastructure and vegetation in the represented surface. 

Required Debian packages:  
    sudo apt install gdal-bin python3-gdal python3-pyosmium

How it works
- The 1x1 degree elevation tiles covering the bounding box are located.
  Tiles which do not exist (ocean, or countries not in the public 30 m data)
  are skipped; when no tile exists at all, osmfromtrack aborts.
- The tiles are clipped to the box and contour lines are generated (gdal_contour).
- The lines are simplified (ogr2ogr) and written as <filebase>.topo.osm.
- Lines are tagged contour=elevation, ele=<meters> and
  contour_ext=elevation_major/medium/minor, as expected by the mkgmap default
  style. Note that this style labels the lines in feet.

Tile caching  
By default the tiles are read remotely and nothing is stored. To keep the
downloaded tiles for later runs use --hgtdir DIRECTORY.

Configuration  
Done at the top of the osmfromtrack file, look for the opts entries 'topo_*':
- topo\_interval:  Contour line distance in m (default 50)  
- topo\_major, topo\_medium:  Major/medium line every n m (default 500 and 100)
- topo_simplify:  Simplification tolerance in degrees, 0.0001 is about 10 m,
  0 disables it (default 0.00005)
- topo\_dem_base, topo\_dem\_code:  Elevation data source (default 30 m tiles)

Please check the Copernicus DEM license terms before distributing maps.
