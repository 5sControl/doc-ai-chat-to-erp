#!/usr/bin/env python3
"""
Simple test script to compare tokenization with official IPATokenizer
This will help debug token mismatch issues with Kokoro TTS

Usage:
    cd test_kokoro
    pip install numpy onnxruntime soundfile  # ttstokenizer will be used locally if available
    python test_kokoro_tokens.py
"""

import json
import sys
from pathlib import Path

# Add parent directory to path to find local IPATokenizer if available
sys.path.insert(0, str(Path(__file__).parent.parent))

try:
    # Try to import local IPATokenizer first
    try:
        from ttstokenizer import IPATokenizer
        print("Using local IPATokenizer from workspace")
    except ImportError:
        # Try to import from installed package
        import importlib.util
        # Look for ttstokenizer in parent directories
        for parent in Path(__file__).parent.parents:
            ttstokenizer_path = parent / "ttstokenizer"
            if ttstokenizer_path.exists():
                spec = importlib.util.spec_from_file_location("ttstokenizer", ttstokenizer_path / "__init__.py")
                if spec and spec.loader:
                    ttstokenizer = importlib.util.module_from_spec(spec)
                    spec.loader.exec_module(ttstokenizer)
                    IPATokenizer = ttstokenizer.IPATokenizer
                    print(f"Using IPATokenizer from: {ttstokenizer_path}")
                    break
        else:
            # Fallback to installed package
            from ttstokenizer import IPATokenizer
            print("Using installed IPATokenizer package")
except ImportError:
    print("ERROR: IPATokenizer not found.")
    print("Options:")
    print("1. Install: pip install ttstokenizer")
    print("2. Add ttstokenizer folder to workspace")
    sys.exit(1)

try:
    import numpy as np
except ImportError:
    print("ERROR: numpy not installed. Install with: pip install numpy")
    sys.exit(1)

# Test phrase - same as used in Flutter app
TEST_PHRASE = "Because I fell in love."

def test_tokenization():
    """Test tokenization with IPATokenizer"""
    print("=" * 60)
    print("Kokoro TTS Tokenization Test")
    print("=" * 60)
    print(f"\nTest phrase: \"{TEST_PHRASE}\"")
    print("-" * 60)
    
    # Initialize tokenizer
    tokenizer = IPATokenizer()
    
    # Tokenize the phrase
    tokens = tokenizer(TEST_PHRASE)
    
    print(f"\nTokens (from IPATokenizer):")
    print(f"  Raw tokens: {tokens}")
    print(f"  Token count: {len(tokens)}")
    
    # Format as expected by model (with padding)
    padded_tokens = [0, *tokens, 0]
    print(f"\nTokens with padding [0, *tokens, 0]:")
    print(f"  {padded_tokens}")
    print(f"  Total length: {len(padded_tokens)}")
    
    # Also show as list format for easy copy-paste
    print(f"\nFor Flutter comparison (copy this):")
    print(f"  Expected tokens: {tokens}")
    print(f"  Expected padded: {padded_tokens}")
    
    # Show token-to-phoneme mapping for debugging
    print(f"\nToken breakdown:")
    print(f"  Phrase: \"{TEST_PHRASE}\"")
    print(f"  Tokens: {tokens}")
    print(f"  Each token represents a phoneme character")
    
    return tokens, padded_tokens

def test_with_model():
    """Test with actual ONNX model if available"""
    try:
        import onnxruntime
        import soundfile as sf
    except ImportError:
        print("\n" + "=" * 60)
        print("ONNX Runtime or soundfile not available.")
        print("Skipping model inference test.")
        print("Install with: pip install onnxruntime soundfile")
        return
    
    # Check if model files exist - check multiple locations
    script_dir = Path(__file__).parent
    parent_dir = script_dir.parent
    
    # Try different locations
    possible_locations = [
        script_dir / "model.onnx",
        parent_dir / "model.onnx",
        parent_dir / "tts_models" / "kokoro" / "model.onnx",
        Path.home() / "Downloads" / "model.onnx",  # Common download location
    ]
    
    model_path = None
    voices_path = None
    
    for loc in possible_locations:
        if loc.exists():
            model_path = loc
            # Try to find corresponding voices.json
            voices_candidates = [
                loc.parent / "voices.json",
                loc.parent.parent / "voices.json",
                parent_dir / "tts_models" / "kokoro" / "voices.json",
            ]
            for vc in voices_candidates:
                if vc.exists():
                    voices_path = vc
                    break
            if voices_path:
                break
    
    if not model_path or not voices_path:
        print("\n" + "=" * 60)
        print("Model files not found.")
        print("Searched locations:")
        for loc in possible_locations:
            print(f"  - {loc} {'✓' if loc.exists() else '✗'}")
        print("\nSkipping model inference test.")
        print("\nTo test with model:")
        print("1. Download model.onnx and voices.json from:")
        print("   https://huggingface.co/NeuML/kokoro-base-onnx")
        print("2. Place them in test_kokoro/ folder or tts_models/kokoro/")
        return
    
    print("\n" + "=" * 60)
    print("Testing with ONNX Model")
    print("=" * 60)
    print(f"\nModel: {model_path}")
    print(f"Voices: {voices_path}")
    
    # Load voices
    with open(voices_path, "r", encoding="utf-8") as f:
        voices = json.load(f)
    
    print(f"\nLoaded {len(voices)} voices from voices.json")
    print(f"Available voices: {list(voices.keys())[:5]}...")
    
    # Initialize model
    session = onnxruntime.InferenceSession(
        str(model_path),
        providers=["CPUExecutionProvider"]
    )
    
    input_names = [inp.name for inp in session.get_inputs()]
    output_names = [out.name for out in session.get_outputs()]
    print(f"\nModel inputs: {input_names}")
    print(f"Model outputs: {output_names}")
    
    # Tokenize
    tokenizer = IPATokenizer()
    tokens = tokenizer(TEST_PHRASE)
    padded_tokens = [[0, *tokens, 0]]
    
    print(f"\nTokenized phrase: \"{TEST_PHRASE}\"")
    print(f"Tokens: {tokens}")
    print(f"Padded tokens: {padded_tokens}")
    
    # Get speaker (using 'af' voice)
    speaker_id = "af"
    if speaker_id not in voices:
        speaker_id = list(voices.keys())[0]
        print(f"\nWarning: 'af' not found, using '{speaker_id}' instead")
    
    speaker = np.array(voices[speaker_id], dtype=np.float32)
    print(f"\nUsing speaker: {speaker_id}")
    print(f"Speaker array shape: {speaker.shape}")
    print(f"Speaker array length: {len(speaker)}")
    
    # Select style vector based on token length
    token_length = len(tokens)
    if token_length < len(speaker):
        style_vector = speaker[token_length]
        print(f"\nSelected style vector index: {token_length}")
        print(f"Style vector shape: {style_vector.shape if hasattr(style_vector, 'shape') else 'scalar'}")
    else:
        style_vector = speaker[-1] if len(speaker) > 0 else speaker[0]
        print(f"\nWarning: Token length {token_length} >= speaker array length {len(speaker)}")
        print(f"Using last style vector")
    
    # Ensure style_vector is 1D array
    if isinstance(style_vector, np.ndarray) and style_vector.ndim == 0:
        style_vector = np.array([style_vector])
    elif not isinstance(style_vector, np.ndarray):
        style_vector = np.array([style_vector])
    
    # Reshape to [1, embedding_size] if needed
    if style_vector.ndim == 1:
        style_vector = style_vector.reshape(1, -1)
    
    print(f"Final style vector shape: {style_vector.shape}")
    
    # Prepare inputs based on model format
    if "input_ids" in input_names:
        # Newer model format
        inputs = {
            "input_ids": np.array(padded_tokens, dtype=np.int64),
            "style": style_vector.astype(np.float32),
            "speed": np.array([1.0], dtype=np.float32)
        }
        print("\nUsing newer model format (input_ids)")
    else:
        # Older model format
        inputs = {
            input_names[0]: np.array(padded_tokens, dtype=np.int64),
            input_names[1]: style_vector.astype(np.float32),
            input_names[2]: np.array([1.0], dtype=np.float32)
        }
        print(f"\nUsing older model format ({input_names[0]}, {input_names[1]}, {input_names[2]})")
    
    print(f"\nModel inputs:")
    for key, value in inputs.items():
        print(f"  {key}: shape={value.shape}, dtype={value.dtype}")
    
    # Run inference
    print("\nRunning inference...")
    outputs = session.run(None, inputs)
    
    audio = outputs[0]
    print(f"\nGenerated audio:")
    print(f"  Shape: {audio.shape}")
    print(f"  Dtype: {audio.dtype}")
    print(f"  Min: {audio.min():.6f}, Max: {audio.max():.6f}, Mean: {audio.mean():.6f}")
    print(f"  Sample rate: 24000 Hz")
    print(f"  Duration: {len(audio) / 24000:.2f} seconds")
    
    # Save audio
    output_file = script_dir / "test_output.wav"
    sf.write(str(output_file), audio, 24000)
    print(f"\n✓ Audio saved to: {output_file}")
    print(f"  You can play it to compare with Flutter app output")

if __name__ == "__main__":
    # Test tokenization
    tokens, padded_tokens = test_tokenization()
    
    # Test with model if available
    test_with_model()
    
    print("\n" + "=" * 60)
    print("Test completed!")
    print("=" * 60)
    print("\nNext steps:")
    print("1. Compare the tokens above with Flutter app logs")
    print("2. If tokens match, the issue is elsewhere (model, style vector, etc.)")
    print("3. If tokens differ, check tokenizer_vocab.json mapping")
    print("\nTo compare:")
    print("  - Run Flutter app with phrase: \"Because I fell in love.\"")
    print("  - Check logs for 'Token Sequence for Comparison'")
    print("  - Compare tokens with output above")
