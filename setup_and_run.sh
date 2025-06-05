#!/bin/bash
set -e

echo "🛠 Starting environment setup..."

# Use current directory as base
WORKDIR=$(pwd)

# Check for HF token
if [ -z "$HF_TOKEN" ]; then
    echo "❌ HF_TOKEN is not set. Please run: export HF_TOKEN=your_token"
    exit 1
fi

# Set Hugging Face cache inside current directory
export TRANSFORMERS_CACHE="$WORKDIR/hf_cache"
export HF_HOME="$WORKDIR/hf_cache"
export HF_DATASETS_CACHE="$WORKDIR/hf_cache/datasets"
export HUGGINGFACEHUB_API_TOKEN="$HF_TOKEN"
export HF_AUTH_TOKEN="$HF_TOKEN"

# Set up Python virtual environment in ./venv
echo "🐍 Creating virtual environment..."
python3 -m venv "$WORKDIR/venv"
source "$WORKDIR/venv/bin/activate"

# Upgrade pip
pip install --upgrade pip

# Install dependencies
if [ -f "$WORKDIR/requirements.txt" ]; then
    echo "📦 Installing from requirements.txt..."
    pip install -r "$WORKDIR/requirements.txt"
else
    echo "📦 Installing default dependencies..."
    pip install torch transformers accelerate bitsandbytes einops
fi

# Run your Python script
echo "🚀 Running chat_llama3.1.py..."
python3 "$WORKDIR/chat_llama3.1.py"
