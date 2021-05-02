#!/usr/bin/awk -f
BEGIN { out=0; }
/SECTION-END/ { out=0; }
{ if(out) { print; } }
/SECTION-START/ { out=1; }
