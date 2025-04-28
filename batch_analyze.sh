#!/bin/bash

# Variables
PYTHON_SCRIPT="analyze_binary.py"  # Ton script Python principal
MALWARE_DIR="./malwares"           # Dossier contenant les malwares
N_GRAMS=3                          # Taille des n-grams
ASM_DIR="./asm_outputs"            # Dossier pour les fichiers .asm
NGRAMS_DIR="./ngrams_outputs"      # Dossier pour les fichiers .txt
LOG_FILE="./failed_files.log"      # Fichier pour enregistrer les échecs

# Créer les dossiers de sortie s'ils n'existent pas
mkdir -p "$ASM_DIR"
mkdir -p "$NGRAMS_DIR"

# Vider le fichier de logs s'il existe
> "$LOG_FILE"

# Compter le nombre total de fichiers
total_files=$(find "$MALWARE_DIR" -type f | wc -l)
current=0

# Parcourir tous les fichiers
find "$MALWARE_DIR" -type f | while read -r malware_file; do
    # Extraire juste le nom du fichier
    filename=$(basename -- "$malware_file")
    filename_no_ext="${filename%.*}"

    # Définir chemins de sortie
    asm_output="${ASM_DIR}/${filename_no_ext}.asm"
    ngrams_output="${NGRAMS_DIR}/${filename_no_ext}.txt"

    # Appeler le script Python et capturer les erreurs
    if python3 "$PYTHON_SCRIPT" "$malware_file" "$N_GRAMS" "$asm_output" "$ngrams_output"; then
        echo "[$((++current))/$total_files] ✅ Processed: $filename"
    else
        echo "[$((++current))/$total_files] ❌ Failed: $filename"
        echo "$filename" >> "$LOG_FILE"
    fi
done

echo "🏁 Traitement terminé."
echo "📜 Liste des fichiers échoués enregistrée dans : $LOG_FILE"
echo "📁 Fichiers ASM enregistrés dans : $ASM_DIR"