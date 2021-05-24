#!/usr/bin/awk -f
BEGIN { out=0; }
/GOLDEN-SECTION-END/ { out=0; }
{ if(out) { print; } }
/GOLDEN-SECTION-START/ { out=1; }
