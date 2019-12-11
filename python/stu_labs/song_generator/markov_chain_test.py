from markov_chain import words


def test_words():
    raw_text = "The Quick? Brown foX jumps over the Red,, lazy.. dog!"
    words_seq = words(raw_text)
    assert("quick" in words_seq)
    assert("brown" in words_seq)
    assert(words_seq[0] == "the")


if __name__ == "__main__":
    test_words()