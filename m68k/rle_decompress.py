def rle_decompress(input):
    """Run-length decompression: decompress count+character format.

    Examples:
    - "3A4B4C" -> "AAABBBBCCCC"
    - "9a1a" -> "aaaaaaaaaa"
    .
    - Buffer size for the decompressed message -- `0x40`, starts from `0x00`.
    - End of input -- new line.

    Python example args:
        input (str): The input string containing compressed data to decompress.

    Returns:
        tuple: A tuple containing the decompressed string and the remaining input.
    """
    line, rest = read_line(input, 0x80)
    if line is None:
        return [overflow_error_value], rest

    if not line:
        return "", rest

    try:
        decompressed = []
        i = 0

        while i < len(line):
            if i + 1 >= len(line):
                return [-1], rest  # Invalid format: missing character after count

            # Read count (should be digit 1-9)
            if not line[i].isdigit() or line[i] == "0":
                return [-1], rest  # Invalid count

            count = int(line[i])
            char = line[i + 1]

            # Add repeated character
            decompressed.append(char * count)
            i += 2

        result = "".join(decompressed)
        if len(result) + 1 > 0x40:  # +1 for null terminator
            return [overflow_error_value], rest

        return cstr(result, 0x40)[0], rest

    except Exception:
        return [-1], rest


assert rle_decompress('3A4B4C\n') == ('AAABBBBCCCC', '')
assert rle_decompress('9a1a\n') == ('aaaaaaaaaa', '')
assert rle_decompress('1A1B1C\n') == ('ABC', '')
