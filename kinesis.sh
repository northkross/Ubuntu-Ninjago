#!/bin/bash
touch /tmp/score.json # score json file which will be stuffed in html later

# json manipulation functions
# in the end, json looks like {header:{title:"title", inject:false, timestamp:"..."}, vulns:[{name:"vuln", points:5},null,...]}
_header() {
    local title="$1"
    local injectbool="$2"
    local date=$(date)
    echo -n "{\"header\":{\"title\":\"$title\", \"inject\":$injectbool, \"timestamp\":\"$date\"}, \"vulns\":[" >> /tmp/score.json
}

_append_found() {
    local vuln_name="$1"
    local points="$2"

    echo -n "{\"name\":\"$vuln_name\", \"points\":$points}," >> /tmp/score.json
}

_append_unsolved() {
    echo -n "null," >> /tmp/score.json
}

_terminate(){
    local template_html_file="$1"
    local html_file="$2"

    # reset html file with template
    cat "$template_html_file" > "$html_file" 
    # remove the trailing comma
    sed -i 's/,\([^,]*\)$/ \1/' /tmp/score.json
    # close brackets
    echo "]}" >> /tmp/score.json
    # stuff raw json into html because CORS prevents reading of local files in JS
    sed -i -e "/<!--JSONHERE-->/r /tmp/score.json" -e "/<!--JSONHERE-->/d" "$html_file"

    rm /tmp/score.json
}

# Function to check if text exists in a file
check_text_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    local points="$4"
    
    if grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_text_exists2() {
    local file="$1"
    local text="$2"
    local text2="$3"
    local vuln_name="$4"
    local points="$5"
    
    if grep -q "$text" "$file" && grep -q "$text2" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_text_exists3() {
    local file="$1"
    local text="$2"
    local text2="$3"
    local text3="$4"
    local vuln_name="$5"
    local points="$6"
    
    if grep -q "$text" "$file" && grep -q "$text2" "$file" && grep -q "$text3" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_text_with_threshold() {
  local file="$1"
  local text_prefix="$2"  
  local threshold="$3"    # The maximum or minimum allowed value
  local vuln_name="$4"
  local points="$5"
  local compare="$6"      # "<" or ">"

  grep -oP "^${text_prefix}(\d+)" "$file" | while IFS= read -r match; do
    local value="${match#"$text_prefix"}"

    if [[ "$compare" == "<" ]]; then
      if (( value <= threshold )); then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
      else
        echo "Unsolved Vuln"
        _append_unsolved
      fi
    elif [[ "$compare" == ">" ]]; then
      if (( value >= threshold )); then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
      else
        echo "Unsolved Vuln"
        _append_unsolved
      fi
    else
      echo "Invalid comparison operator: '$compare'"
      return 1
    fi
  done
}


# Function to check if text does not exist in a file
check_text_not_exists() {
    local file="$1"
    local text="$2"
    local vuln_name="$3"
    local points="$4"
    
    if ! grep -q "$text" "$file"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_text_not_exists2() {
    local file="$1"
    local text="$2"
    local text2="$3"
    local vuln_name="$4"
    local file2="$5"
    local points="$6"
    
    if ! grep -q "$text" "$file" && ! grep -q "$text2" "$file2"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
# Function to check if a file exists
check_file_exists() {
    local file="$1"
    local vuln_name="$2"
    local points="$3"
    
    if [ -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

# Function to check if a file has been deleted
check_file_deleted() {
    local file="$1"
    local vuln_name="$2"
    local points="$3"
    
    if [ ! -e "$file" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_file_deleted2() {
    local file="$1"
    local file2="$2"
    local vuln_name="$3"
    local points="$4"
    
    if ! -e "$file" && ! -e "$file2"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_file_deleted3() {
    local file="$1"
    local file2="$2"
    local file3="$3"
    local vuln_name="$4"
    local points="$5"
    
    if ! -e "$file" && ! -e "$file2" && ! -e "$file3"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_file_permissions() {
    local file="$1"
    local expected_permissions="$2"
    local vuln_name="$3"
    local points="$4"
    
    
    # Get the actual permissions of the file in numeric form (e.g., 644)
    actual_permissions=$(stat -c "%a" "$file")
    
    if [ "$actual_permissions" == "$expected_permissions" ]; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

check_file_ownership() { # Thanks Coyne <3
    local file="$1"
    local expected_owner="$2"
    local vuln_name="$3"
    local points="$4"
    
     if getfacl "$file" 2>/dev/null | grep -q "owner: $expected_owner"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

check_packages() {
    local package="$1"
    local vuln_name="$2"
    local points="$3"
    

    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_packages2() {
    local package="$1"
    local package2="$2"
    local vuln_name="$3"
    local points="$4"
    

    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$" && ! dpkg --get-selections | grep -q "^$package2[[:space:]]*install$"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}

check_packages3() {
    local package="$1"
    local package2="$2"
    local package3="$3"
    local vuln_name="$4"
    local points="$5"
    

    if ! dpkg --get-selections | grep -q "^$package[[:space:]]*install$" && ! dpkg --get-selections | grep -q "^$package2[[:space:]]*install$" && ! dpkg --get-selections | grep -q "^$package3[[:space:]]*install$"; then
        echo "Vulnerability fixed: '$vuln_name'"
        _append_found "$vuln_name" "$points"
    else
        echo "Unsolved Vuln"
        _append_unsolved
    fi
}
check_mysql_value_exists() {
    local value="$1"
    local column="$2"
    local DATABASE="$3"
    local TABLE="$4"
    local vuln_name="$5"
    local points="$6"

    local count=0
    output=$(mysql -N -e "SELECT $column FROM $DATABASE.$TABLE;")
    IFS=$'\n' read -ra values <<< "$output"
    for current_value in "${values[@]}"; do
        if [[ "$current_value" == "$value" ]]; then
            count=1
        fi
    done
        if (( count > 1)); then
            echo "Vulnerability fixed: '$vuln_name'"
            _append_found "$vuln_name" "$points"
        else
            echo "Unsolved Vuln"
            _append_unsolved
        fi
    
}
check_mysql_value_not_exists() {
    local value="$1"
    local column="$2"
    local DATABASE="$3"
    local TABLE="$4"
    local vuln_name="$5"
    local points="$6"

    local count=0
    output=$(mysql -N -e "SELECT $column FROM $DATABASE.$TABLE;")
    IFS=$'\n' read -ra values <<< "$output"
    for current_value in "${values[@]}"; do
        if [[ "$current_value" == "$value" ]]; then
            count=1
        fi
    done
        if (( count == 0 )); then
            echo "Vulnerability fixed: '$vuln_name'"
            _append_found "$vuln_name" "$points"
        else
            echo "Unsolved Vuln"
            _append_unsolved
        fi
}
# keep this line at the beginning, input your image metadata here 
# accepts two args: image name, and injects bool (true/false)
_header "Ubuntu Ninjago" "false"



# put vuln checks here, for example: 
check_text_exists "/home/sora/Desktop/Forensics1.txt" "ShatterSpin" "Forensics 1 correct" "1"
check_text_exists2 "/home/sora/Desktop/Forensics2.txt" "kur" "D3cay" "Forensics 2: Hijack" "1"
check_text_exists "/home/sora/Desktop/Forensics2.txt" "RisingDragon" "Forensics 2: Recon" "1"
check_text_exists "/home/sora/Desktop/Forensics2.txt" "Focus" "Forensics 2: Secret" "1"
check_file_permissions "/etc/group" "644" "Permissions on group file fixed" "1"
check_text_not_exists "/etc/group" "nokt" "Forbidden Five member Nokt removed from system" "1"
check_text_not_exists "/etc/group" "rox" "Forbidden Five leader Rox removed from system" "1"
check_text_not_exists "/etc/group" "adm:x:4:syslog,sora,wu,rox,garmadon,lloyd" "Forbidden Five leader Rox is not an administrator" "1"
check_text_not_exists2 "/etc/group" "thunderfang:x:2000:" "thunderfang:x:2000:2000:,,,:/bin/bash" "Hidden user Thunderfang removed from the system" "/etc/passwd" "1"
check_text_exists "/etc/ufw/ufw.conf" "ENABLED=yes" "ufw firewall enabled" "1"
check_text_exists "/etc/ufw/ufw.conf" "LOGLEVEL=high" "ufw firewall loglevel high" "1"
check_text_exists "/etc/default/ufw" "IPV6=yes" "Rules support IPV6" "1"
check_text_exists2 "/etc/ufw/user.rules" "ufw-user-input -p tcp --dport 443 -j ACCEPT" "ufw-user-input -p tcp --dport 80 -j ACCEPT" "ufw allows incoming connections for http and https" "1"
check_text_exists "/etc/ufw/user.rules" "ufw-user-input -p tcp --dport 3306 -j ACCEPT" "ufw allows incoming connections for MySQL" "1"
check_text_exists "/etc/login.defs" "PASS_MAX_DAYS[[:space:]]*90" "Password must be changed after 90 days" "1"
check_text_exists "/etc/login.defs" "LOG_OK_LOGINS[[:space:]]*yes" "logs successful logins" "1"
check_text_exists "/etc/login.defs" "HOME_MODE[[:space:]]*0750" "new home directory permission set to 0750" "1"
check_text_not_exists "/etc/rsyslog.conf" "FileGroup nokt" "nokt is not the file group for logs" "1"
check_text_exists "/etc/rsyslog.conf" 'module(load="imklog" permitnonkernelfacility="on")' "enabled kernel logging support and non-kernel klog messages" "1"
check_text_exists "/etc/host.conf" "multi on" "host is allowed to have multiple addresses" "1"
check_text_not_exists "/etc/host.conf" "nospoof off" "deprecated line removed in host.conf" "1"
check_text_exists "/etc/logrotate.conf" "weekly" "Rotates logs regularly" "1"
check_text_not_exists "/etc/logrotate.conf" "rotate 999" "Does not keep many weeks of backlogs" "1"
check_text_not_exists "/etc/security/pwquality.conf" "minlen = 8" "Minimum password length is 16" "1"
check_text_not_exists "/etc/security/pwquality.conf" "dictcheck = 0" "Checks for dictionary words" "1"
check_text_not_exists "/etc/security/pwquality.conf" "enforcing = 0" "Rejects insecure passwords" "1"
check_text_exists2 "/etc/apt/apt.conf.d/20auto-upgrades" 'APT::Periodic::Update-Package-Lists "1";' 'APT::Periodic::Unattended-Upgrade "1"' "System set to automatically update" "1"
check_file_permissions "/etc/sudoers" "440" "Permissions on sudoers file fixed" "1"
check_text_not_exists "/etc/sudoers" "NOPASSWD" "insecure sudoers rule extinguished" "1"
check_file_deleted "/etc/sudoers.d/.FINDME" "Hidden sudoers file removed" "1"
check_text_with_threshold "/etc/apache2/apache2.conf" "Timeout " "300" "Apache sends and recieves timeout somewhat frequently" "1" "<"
check_text_exists "/etc/apache2/apache2.conf" "LogLevel warn" "Apache log level set to warn" "1"
check_text_exists "/etc/apache2/conf-enabled/security.conf" "ServerTokens Prod" "Server HTTP response header returns the least information" "1"
check_text_exists "/etc/apache2/conf-enabled/security.conf" "ServerSignature Off" "Apache Server Signature Off" "1"
check_text_exists2 "/etc/apache2/conf-enabled/security.conf" "Header unset ETag" "FileETag None" "ETags Disabled" "1"
check_text_exists "/etc/apache2/conf-enabled/security.conf" 'Header set Cache-Control "max-age=' "Cache max age set" "1"
check_text_exists "/etc/apache2/conf-enabled/security.conf" 'Header set X-Content-Type-Options: "nosniff"' "Apache prevents browser from guessing type of file" "1"
check_file_exists "/etc/apache2/mods-enabled/reqtimeout.load" "reqtimout module enabled" "1"
check_file_exists "/etc/apache2/mods-enabled/headers.load" "headers module enabled" "1"
check_file_exists "/etc/apache2/mods-enabled/security2.load" "security2 module enabled" "1"
check_mysql_value_not_exists "kur" "username" "user" "users" "Forbidden Five member Kur removed from the MySQL database" "1"
check_text_exists "/etc/mysql/mysql.conf.d/mysqld.cnf" "port[[:space:]]*= 3306" "MySQL set to port 3306" "1"
check_text_exists2 "/etc/mysql/mysql.conf.d/mysqld.cnf" "bind-address[[:space:]]*= 127.0.0.1" "mysqlx-bind-address[[:space:]]*= 127.0.0.1" "MySQL listens only on localhost" "1"
check_text_exists "/etc/mysql/mysql.conf.d/mysqld.cnf" "auth_socket[[:space:]]*= FORCE_PLUS_PERMANENT" "auth socket on and persists" "1"
check_text_exists "/etc/mysql/mysql.conf.d/mysqld.cnf" "audit_log[[:space:]]*= FORCE_PLUS_PERMANENT" "audit log on and persists" "1"
check_text_exists "/etc/mysql/mysql.conf.d/mysqld.cnf" "mysql_firewall_mode[[:space:]]*= FORCE_PLUS_PERMANENT" "mysql firewall mode on and persists" "1"
check_text_exists2 "/etc/mysql/mysql.conf.d/mysqld.cnf" "password_history[[:space:]]*= 5" "password_reuse_interval[[:space:]]*= 365" "MySQL listens only on localhost" "1"


# keep this line at the end, input the path to score report html here
# accepts two args: path to template html file, and path to actual html file
_terminate "/etc/scorebot/report-template.html" "/home/sora/Desktop/report.html"
