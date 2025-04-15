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

check_text_in_file '/etc/ufw/ufw.conf' 'ENABLED=yes' 'ENABLED=no'
