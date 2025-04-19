#!/bin/bash
# Please give around ~5 minutes for the raw to update
# Scorebot for 2025 Ubuntu Ninjago
echo " "
echo " "
echo "NOTE: Please allow up to 5 minutes for scorebot updates & injects."
echo "Scorebot version: v1"
echo "Injects: NO"

check_text_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    
    if grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
check_text_exists2() {
    local file="$1"
    local text="$2"
    local text2="$3"
    local vuln_name="$4"
    
    if grep -q "$text" "$file" && grep -q "$text2" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
check_text_exists3() {
    local file="$1"
    local text="$2"
    local text2="$3"
    local text3="$4"
    local vuln_name="$5"
    
    if grep -q "$text" "$file" && grep -q "$text2" "$file" && grep -q "$text3" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
        count=count+1
    else
        echo "Unsolved Vuln"
    fi
}
# Function to check if text does not exist in a file
check_text_not_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    
    if ! grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
check_text_not_exists2() {
    local file="$1"
    local text="$2"
    local text2="$3"
    local vuln_name="$4"
    local file2="$5"
    
    if ! grep -q "$text" "$file" && ! grep -q "$text2" "$file2"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
# Function to check if a file exists
check_file_exists() {
    local file="$1"
    local vuln_name="$2"
    
    if [ -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

# Function to check if a file has been deleted
check_file_deleted() {
    local file="$1"
    local vuln_name="$2"
    
    if [ ! -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'" 
    else
        echo "Unsolved Vuln"
    fi
}
check_file_deleted2() {
    local file="$1"
    local file2="$2"
    local vuln_name="$3"
    
    if ! -e "$file" && ! -e "$file2"; then
        echo "Vulnerability fixed: '$vuln_name'" 
    else
        echo "Unsolved Vuln"
    fi
}
check_file_deleted3() {
    local file="$1"
    local file2="$2"
    local file3="$3"
    local vuln_name="$4"
    
    if ! -e "$file" && ! -e "$file2" && ! -e "$file3"; then
        echo "Vulnerability fixed: '$vuln_name'" 
    else
        echo "Unsolved Vuln"
    fi
}
check_file_permissions() {
    local file="$1"
    local expected_permissions="$2"
    local vuln_name="$3"
    
    # Get the actual permissions of the file in numeric form (e.g., 644)
    actual_permissions=$(stat -c "%a" "$file")
    
    if [ "$actual_permissions" == "$expected_permissions" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

check_file_ownership() { # Thanks Coyne <3
    local file="$1"
    local expected_owner="$2"
    local vuln_name="$3"
     if getfacl "$file" 2>/dev/null | grep -q "owner: $expected_owner"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

check_packages() {
    local package="$1"
    local vuln_name="$2"
    

    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}
check_packages2() {
    local package="$1"
    local package2="$2"
    local vuln_name="$3"
    

    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$" && ! dpkg --get-selections | grep -q "^$package2[[:space:]]*install$"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}

check_packages3() {
    local package="$1"
    local package2="$2"
    local package3="$3"
    local vuln_name="$4"
    

    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$" && ! dpkg --get-selections | grep -q "^$package2[[:space:]]*install$" && ! dpkg --get-selections | grep -q "^$package3[[:space:]]*install$"; then
        echo "Vulnerability fixed: '$vuln_name'"
    else
        echo "Unsolved Vuln"
    fi
}


echo " "
echo "Dallas Ubuntu Ninjago"
echo " "

check_text_exists "/home/sora/Desktop/Forensics1.txt" "ShatterSpin" "Forensics 1 correct"

check_text_not_exists "/etc/group" "nokt" "Forbidden Five member Nokt removed from system"
check_text_not_exists "/etc/group" "rox" "Forbidden Five leader Rox removed from system"
check_text_not_exists "/etc/group" "adm:x:4:syslog,sora,wu,rox,garmadon,lloyd" "Forbidden Five leader Rox is not an administrator"
check_text_not_exists2 "/etc/group" "thunderfang:x:2000:" "thunderfang:x:2000:2000:,,,:/bin/bash" "Hidden user Thunderfang removed from the system" "/etc/passwd"
check_text_exists "/etc/ufw/ufw.conf" "ENABLED=yes" "ufw firewall enabled"
check_text_exists "/etc/ufw/ufw.conf" "LOGLEVEL=high" "ufw firewall loglevel high"
check_text_exists2 "/etc/ufw/user.rules" "ufw-user-input -p tcp --dport 443 -j ACCEPT" "ufw-user-input -p tcp --dport 80 -j ACCEPT" "ufw allows incoming connections for http and https"
check_text_exists "/etc/ufw/user.rules" "ufw-user-input -p tcp --dport 3306 -j ACCEPT" "ufw allows incoming connections for MySQL"
check_text_exists "/etc/login.defs" "PASS_MAX_DAYS[[:space:]]*90" "Password must be changed after 90 days"
check_text_exists "/etc/login.defs" "LOG_OK_LOGINS[[:space:]]*yes" "logs successful logins"
check_text_exists "/etc/login.defs" "HOME_MODE[[:space:]]*0750" "new home directory permission set to 0750"
