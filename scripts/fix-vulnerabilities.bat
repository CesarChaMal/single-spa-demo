@echo off
echo Fixing security vulnerabilities in all microfrontends...
echo.

echo Fixing root config vulnerabilities...
cd single-spa-demo-root-config
npm audit fix --force
cd ..

echo.
echo Fixing navigation app vulnerabilities...
cd single-spa-demo-nav
npm audit fix --force
cd ..

echo.
echo Fixing page 1 app vulnerabilities...
cd single-spa-demo-page-1
npm audit fix --force
cd ..

echo.
echo Fixing page 2 app vulnerabilities...
cd single-spa-demo-page-2
npm audit fix --force
cd ..

echo.
echo All vulnerabilities fixed!
pause