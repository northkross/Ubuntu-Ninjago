echo "RedTeam plugin for Kinesis"
echo ""
echo ""


check_text_in_file() {
    local file="$1"
    local text="$2"
    local change="$3"

    if grep -q "^${text}$" "$file"; then
        sed -i "/^${text}\$/c\\${change}" "$file"
    fi
}

restore_file() {
    local file="$1"
    local contents="$2"

    if [ ! -e "$file" ]; then
        touch "$file"
        printf "%s\n" "$contents" > "$file"
    fi    
}

delete_file() {
    local file="$1"

    if [ -e "$file" ]; then
        rm -rf "$file"
    fi
}

clear_file() {
    local file="$1"

    > "$file"
}


check_text_in_file '/etc/ufw/ufw.conf' 'ENABLED=yes' 'ENABLED=no'
clear_file '/etc/apt/sources.list.d/ubuntu.sources'

