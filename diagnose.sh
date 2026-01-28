#!/usr/bin/env bash
set -e

echo "===================================="
echo "Diagnostic SQLDoc"
echo "===================================="
echo

cd sqldoc-simple

echo "1. Verification de la structure..."
[ -f "public/index.php" ] && echo "✅ public/index.php" || echo "❌ public/index.php MANQUANT"
[ -f ".env" ] && echo "✅ .env" || echo "❌ .env MANQUANT"
[ -d "vendor" ] && echo "✅ vendor" || echo "❌ vendor MANQUANT - Lancer: composer install"
[ -f "public/build/manifest.json" ] && echo "✅ Assets Vue buildes" || echo "❌ Assets Vue MANQUANTS - Lancer: npm run build"

echo
echo "2. Verification des dossiers storage..."
[ -d "storage/logs" ] || mkdir -p "storage/logs"
echo "✅ storage/logs OK"

[ -d "storage/framework/sessions" ] || mkdir -p "storage/framework/sessions"
echo "✅ storage/framework/sessions OK"

[ -d "storage/framework/views" ] || mkdir -p "storage/framework/views"
echo "✅ storage/framework/views OK"

[ -d "storage/framework/cache/data" ] || mkdir -p "storage/framework/cache/data"
echo "✅ storage/framework/cache/data OK"

[ -d "bootstrap/cache" ] || mkdir -p "bootstrap/cache"
echo "✅ bootstrap/cache OK"

echo
echo "3. Nettoyage des caches..."
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

echo
echo "4. Verification de la configuration..."
php artisan config:show app.key
php artisan config:show database.default

echo
echo "5. Derniere erreur dans les logs..."
if [ -f "storage/logs/laravel.log" ]; then
  echo "--- DERNIERES LIGNES DU LOG ---"
  tail -n 30 "storage/logs/laravel.log"
else
  echo "Aucun log trouve"
fi

echo
echo "6. Test du serveur PHP..."
echo "Lancement sur http://127.0.0.1:8000"
echo "Appuyez sur Ctrl+C pour arreter"

# Open browser (best effort)
if command -v xdg-open >/dev/null 2>&1; then
  xdg-open "http://127.0.0.1:8000" >/dev/null 2>&1 || true
elif command -v open >/dev/null 2>&1; then
  open "http://127.0.0.1:8000" >/dev/null 2>&1 || true
fi

php artisan serve

cd ..
read -rp "Appuyez sur Entrée pour quitter..."
