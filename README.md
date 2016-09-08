osmfromtrack
============

Download OSM data from a coordinate box or around a gpx file track.
When not disabled, also the topographic data will be created.


State
=====
Usable

For topographic map data a patched version of phyghtmap
is required (see below)


Description
===========
Bounding Box Mode:  
    Supply with two set of coordinates (like from Google Map's LatLng marker)
    and the box will be fetched from OSM.  
    Example: osmfromtrack data 61,001 22,758 60.948 22.871

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
    http://wiki.openstreetmap.org/wiki/Topographic_maps_for_garmin_devices

To create a topographic map you need the tool phyghtmap.
If you don't want this, just use the command line option "--no-topo"

For the current version  1.43-1 you also need to apply the following patch
to being able to set the hgt cache directory:  
http://wiki.openstreetmap.org/wiki/User:Edamame/PatchPhyghtmapHgtDir  
If not wanted, just remove the line  
"opts['topo_opts_hgtcache'].format(dir=opts['topo_hgtcache_dir']),"  
from the execute_cmd code

Another patch (currently unreleased) is required to invoke etrex30 from within.  
For now, remove the following line  
                       "--verbatim-output-name" ],    # phyghtmap improvement not to mangle the file name  
(and replace by a single "]," )

How to setup phyghtmap with debian (other OS may vary)
- Get DEB packet of phyghtmap from http://katze.tfiu.de/projects/phyghtmap/  
  e.g. http://katze.tfiu.de/projects/phyghtmap/phyghtmap_1.43-1_all.deb
- Install, e.g.  
  sudo dpkg -i  phyghtmap_1.43-1_all.deb
- For Version 1.43 you manually need to repair some things
- If you get the error  
  File "/usr/bin/phyghtmap", line 5, in &lt;module&gt;  
    from pkg_resources import load_entry_point  
  ImportError: No module named pkg_resources  
  Solution: sudo aptitude install python-pkg-resources
- If you get the error  
  File "/usr/lib/python2.7/dist-packages/pkg_resources.py", line 584, in resolve  
    raise DistributionNotFound(req)  
    pkg_resources.DistributionNotFound: phyghtmap==1.43  
  Solution:  
  - cd ../../python2.7/dist-packages/
  - sudo ln -s ../../python2.6/dist-packages/phyghtmap
  - sudo ln -s ../../python2.6/dist-packages/phyghtmap-1.43.egg-info/

A sample call as done by osmfromtrack:  
  phyghtmap --area=9.755300:47.478000:9.804400:47.502600 --step=50 -o srtmtest \  
  --line-cat=400,100 --jobs=2  --viewfinder-mask=1

Configuration can be done at the top of osmfromtrack file, look for 'topo_opts' .

