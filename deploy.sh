#!/bin/bash

# GITGAZER - Deployment Script
# This script builds and prepares the Flutter PWA for deployment

echo "🚀 Building GITGAZER - Flutter PWA with Hive Bookmarks"
echo "=================================================="

# Step 1: Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean

# Step 2: Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

# Step 3: Generate Hive adapters (if needed)
echo "🔧 Generating Hive type adapters..."
flutter packages pub run build_runner build --delete-conflicting-outputs

# Step 4: Build for production
echo "🏗️ Building Flutter web app..."
flutter build web --release

# Step 5: Generate Workbox service worker
echo "⚙️ Generating PWA service worker..."
npx workbox generateSW workbox-config.js

# Step 6: Copy additional PWA files
echo "📱 Setting up PWA files..."
cp web/manifest.json build/web/
cp web/icons/* build/web/icons/ 2>/dev/null || true

echo "✅ Build completed successfully!"
echo ""
echo "📁 Production files are in: build/web/"
echo "🌐 Ready for deployment to:"
echo "   - Netlify: Drag build/web folder to netlify.app/drop"
echo "   - GitHub Pages: Push build/web contents to gh-pages branch"
echo "   - Firebase: firebase deploy"
echo "   - Vercel: vercel --prod"
echo ""
echo "🔖 New Features in this build:"
echo "   ✨ Smart Bookmarks System with Hive database"
echo "   🏷️ Tag management and search functionality"
echo "   💾 Offline-first architecture"
echo "   📱 Enhanced PWA capabilities"
echo "   🎨 Material 3 design improvements"
echo ""
echo "🎉 GITGAZER is ready for deployment!"
