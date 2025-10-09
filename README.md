# Encryption
This repository is for encrypting software on a per-file basis.

## Execute command
`sudo sh  create_encrypted_software.sh ~/YOUR/WORK_DIR 1G`

## When decrypting and actually executing
` gnome-terminal --maximize -- sudo bash -ic "/usr/bin/mkdir -p ~/YOUR/WORK_DIR && /usr/sbin/cryptsetup luksClose encrypted-software 2>/dev/null || true && /usr/sbin/cryptsetup luksOpen /opt/encrypted_software.luks encrypted-software --key-file=/root/.luks-keys/software.key && /usr/bin/mount /dev/mapper/encrypted-software ~/YOUR/WORK_DIR && source ~/YOUR/WORK_DIR/Exec.sh; exec bash"
`

