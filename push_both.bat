@echo off
echo Pushing to original repository...
git push origin main
echo Pushing to forked repository...
git push fork main
echo Done!
pause