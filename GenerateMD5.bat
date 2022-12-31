@echo off

echo Producing Packages.md5

cd .\System
..\..\ContentExpansion\System\ucc.exe mastermd5 -c *.u -c SEF_FR/Content/*.ukx -c SEF_FR/Content/Maps/*.s4m -c SEF_FR/Content/*.utx

echo Produced entries:

cd .\System
..\..\ContentExpansion\System\ucc.exe mastermd5 -s

PAUSE