#!/bin/bash
set -e
echo "=== Configuracion Git – Tarea 0.11 ==="
read -p "Nombre completo : " GIT_NAME
read -p "Email GitHub    : " GIT_EMAIL
read -p "Usuario GitHub  : " GH_USER
read -p "Nombre del repo : " REPO_NAME
echo "Token (invisible al escribir):"
read -s GH_TOKEN
echo ""
git config --global user.name  "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
[ ! -d ".git" ] && git init
git add .
git commit -m "feat: Tarea 0.11 - Lectura robusta de archivos"
git branch -M main
git remote remove origin 2>/dev/null || true
git remote add origin "https://${GH_USER}:${GH_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"
git push -u origin main
echo ""
echo "LISTO: https://github.com/${GH_USER}/${REPO_NAME}"
