#!/bin/bash
set -e

echo "🛠 Starting environment setup..."

# Ensure we're in the correct directory
cd /workspace

# Check for token
if [ -z "$HF_TOKEN" ]; then
    echo "❌ HF_TOKEN is not set. Please run: export HF_TOKEN=your_token"
    exit 1
fi

# Set Hugging Face cache inside /workspace
export TRANSFORMERS_CACHE=/workspace/hf_cache
export HF_HOME=/workspace/hf_cache
export HF_DATASETS_CACHE=/workspace/hf_cache/datasets
export HUGGINGFACEHUB_API_TOKEN=$HF_TOKEN
export HF_AUTH_TOKEN=$HF_TOKEN

# Setup Python virtual environment
echo "🐍 Creating virtual environment..."
python3 -m venv /workspace/venv
source /workspace/venv/bin/activate

# Upgrade pip
pip install --upgrade pip

# Install Python dependencies
if [ -f requirements.txt ]; then
    echo "📦 Installing from requirements.txt..."
    pip install -r requirements.txt
else
    echo "📦 Installing default dependencies..."
    pip install torch transformers accelerate bitsandbytes einops
fi

# Run your script
echo "🚀 Launching chat_llama3.1.py..."
python3 /workspace/chat_llama3.1.py
