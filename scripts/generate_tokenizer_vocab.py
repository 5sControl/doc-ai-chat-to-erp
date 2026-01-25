import json

def build_vocab():
    vocab = {
        "$": 0,
        ";": 1,
        ":": 2,
        ",": 3,
        ".": 4,
        "!": 5,
        "?": 6,
        "\u00a1": 7,
        "\u00bf": 8,
        "\u2014": 9,
        "\u2026": 10,
        "\"": 11,
        "\u00ab": 12,
        "\u00bb": 13,
        "\u201c": 14,
        "\u201d": 15,
        " ": 16,
    }

    # Uppercase letters A-Z
    offset = 17
    for code in range(ord("A"), ord("Z") + 1):
        vocab[chr(code)] = offset
        offset += 1

    # Lowercase letters a-z
    for code in range(ord("a"), ord("z") + 1):
        vocab[chr(code)] = offset
        offset += 1

    # Sample IPA characters
    ipa_chars = {
        "\u0251": 69,
        "\u0250": 70,
        "\u0252": 71,
        "\u0254": 76,
        "\u00e6": 72,
        "\u00f0": 81,
    }
    vocab.update(ipa_chars)

    return vocab


def main():
    vocab = build_vocab()
    with open("assets/tokenizer_vocab.json", "w", encoding="utf-8") as f:
        json.dump(vocab, f, indent=2, ensure_ascii=True, sort_keys=False)
    print(f"Tokenizer vocabulary generated with {len(vocab)} entries.")


if __name__ == "__main__":
    main()
