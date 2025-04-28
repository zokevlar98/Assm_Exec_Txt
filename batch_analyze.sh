#!/bin/bash

# Variables
PYTHON_SCRIPT="get_assm_exec.py"
PYTHON_SCRIPT_PRE="pre_batch.py"
MALWARE_DIR="./malware"                                         # Dossier contenant les malwares
N_GRAMS=3                                                       # Taille des n-grams
ASM_DIR="./asm_outputs"                                         # Dossier pour les fichiers .asm
NGRAMS_DIR="./ngrams_outputs"                                   # Dossier pour les fichiers .txt
LOG_FILE="./failed.log"
MACRO_OUTPUT_DIR="./macros_outputs"


mkdir -p "$ASM_DIR"
mkdir -p "$NGRAMS_DIR"
mkdir -p "$MACRO_OUTPUT_DIR"

# Vider le fichier de logs s'il existe
> "$LOG_FILE"

python3 "$PYTHON_SCRIPT_PRE" "$MALWARE_DIR" "$MACRO_OUTPUT_DIR"

# Compter le nombre total de fichiers
total_files=$(find "$MALWARE_DIR" -type f | wc -l)
current=0

# Parcourir tous les sous-dossiers de MALWARE_DIR
find "$MALWARE_DIR" -type f | while read -r malware_file; do
	# Extraire juste le nom du fichier
	filename=$(basename -- "$malware_file")
	filename_no_ext="${filename%.*}"
	
	# Extraire le chemin relatif du fichier par rapport à MALWARE_DIR
	relative_path="${malware_file#$MALWARE_DIR/}"
	subfolder=$(dirname "$relative_path")

	
	mkdir -p "$ASM_DIR/$subfolder"
	mkdir -p "$NGRAMS_DIR/$subfolder"

	# Définir Path de sortie
	asm_output="${ASM_DIR}/${subfolder}/${filename_no_ext}.asm"
	ngrams_output="${NGRAMS_DIR}/${subfolder}/${filename_no_ext}.txt"

	# Call & faile
	if python3 "$PYTHON_SCRIPT" "$malware_file" "$N_GRAMS" "$asm_output" "$ngrams_output"; then
		echo "[$((++current))/$total_files] ✅ Processed: $filename"
	else
		echo "[$((++current))/$total_files] ❌ Failed: $filename"
		echo "[$((++current))/$total_files] ❌ Failed: $filename" >> "$LOG_FILE"
	fi
done

echo "🏁 Traitement terminé."
echo "📜 Liste des fichiers échoués enregistrée dans : $LOG_FILE"
