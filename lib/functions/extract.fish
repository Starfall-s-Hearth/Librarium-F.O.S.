# lib/functions/extract.fish
#
# Extracts any archive file passed as an argument.

function extract
    if not test -f "$argv[1]"
        echo "Error: file '$argv[1]' not found."
        return 1
    end

    switch "$argv[1]"
        case '*.tar.bz2' '*.tbz2'
            tar xjf "$argv[1]"
        case '*.tar.gz' '*.tgz'
            tar xzf "$argv[1]"
        case '*.tar.xz'
            tar xf "$argv[1]"
        case '*.zip' '*.jar'
            unzip "$argv[1]"
        case '*.rar'
            unrar x "$argv[1]"
        case '*'
            echo "Error: unknown archive format for '$argv[1]'"
            return 1
    end
end
