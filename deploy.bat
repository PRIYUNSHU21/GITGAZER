@echo off
title GITGAZER - Flutter PWA Deployment

echo.
echo 🚀 Building GITGAZER - Flutter PWA with Hive Bookmarks
echo ==================================================
echo.

REM Step 1: Clean previous builds
echo 🧹 Cleaning previous builds...
call flutter clean

REM Step 2: Get dependencies
echo.
echo 📦 Installing dependencies...
call flutter pub get

REM Step 3: Generate Hive adapters (if needed)
echo.
echo 🔧 Generating Hive type adapters...
call flutter packages pub run build_runner build --delete-conflicting-outputs

REM Step 4: Build for production
echo.
echo 🏗️ Building Flutter web app...
call flutter build web --release

REM Step 5: Generate Workbox service worker
echo.
echo ⚙️ Generating PWA service worker...
call npx workbox generateSW workbox-config.js

REM Step 6: Copy additional PWA files
echo.
echo 📱 Setting up PWA files...
copy web\manifest.json build\web\ >nul 2>&1
xcopy web\icons build\web\icons\ /E /I /Y >nul 2>&1

echo.
echo ✅ Build completed successfully!
echo.
echo 📁 Production files are in: build\web\
echo 🌐 Ready for deployment to:
echo    - Netlify: Drag build\web folder to netlify.app/drop
echo    - GitHub Pages: Push build\web contents to gh-pages branch
echo    - Firebase: firebase deploy
echo    - Vercel: vercel --prod
echo.
echo 🔖 New Features in this build:
echo    ✨ Smart Bookmarks System with Hive database
echo    🏷️ Tag management and search functionality
echo    💾 Offline-first architecture
echo    📱 Enhanced PWA capabilities
echo    🎨 Material 3 design improvements
echo.
echo 🎉 GITGAZER is ready for deployment!
echo.
pause
