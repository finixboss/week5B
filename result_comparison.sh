#!/bin/bash

# Define the input CSV file
input_file="reports/baseline_model_results.csv"

# Check if the file exists
if [[ ! -f "$input_file" ]]; then
    echo "Error: File $input_file not found!"
    exit 1
fi

# Initialize variables
best_model=""
max_f1_score=0

# Find the best model based on F1-score
best_model=$(awk -F, '
    NR == 1 { next }  # Skip header
    {
        if ($3 > max_f1) {  # Assume F1-score is in the 3rd column
            max_f1=$3;
            best=$0;  # Store the best model details
        }
    }
    END { print best }' "$input_file")

# Generate the Markdown Report
report_file="reports/baseline_model_report.md"
echo "# Baseline Model Report" > "$report_file"
echo "## Best Model Performance" >> "$report_file"
echo "$best_model" | awk -F, '{ 
    print "* Data Version: " $1 "\n* Model Name: " $2 "\n* F1-Score: " $3 "\n* Accuracy: " $4 
    # Add path to confusion matrix image if available
    print "* Confusion Matrix: ![Confusion Matrix](reports/" $2 "_confusion_matrix.png)" 
}' >> "$report_file"

