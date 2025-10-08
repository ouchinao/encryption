# Encryption
This repository is for encrypting software on a per-file basis.

## Execute command
`sudo sh  create_encrypted_software.sh ~/YOUR/WORK_DIR 1G`

## When decrypting and actually executing
` gnome-terminal --maximize -- bash -ic "sudo bash -c 'mkdir -p ~/YOUR/WORK_DIR && cryptsetup luksClose encrypted-software 2>/dev/null || true cryptsetup luksOpen /opt/encrypted_software.luks encrypted-software --key-file=/root/.luks-keys/software.key && mount /dev/mapper/encrypted-software ~/YOUR/WORK_DIR && source ~/YOUR/WORK_DIR/EXE.sh' ; bash" `

