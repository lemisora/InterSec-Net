#!/usr/bin/env bash

echo "Este script servirá para configurar el cortafuegos de FirewallD + Fail2Ban en AlmaLinux 10"

if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ser ejecutado como administrador"
    exit 1
fi


# Resumen de los puertos a bloquear
# - 80 : HTTP
# - 443 : HTTPS
# - 22 : SSH

# Para instalar fail2ban y firewall-cmd (en caso de no tenerlo preinstalado) desde los repositorios
function instalar_dependencias() {
    echo "Instalando Firewall"
    dnf install firewalld -y

    echo "Instalando Fail2Ban"
    dnf install fail2ban fail2ban-firewalld -y
}

#################
# Sección de habilitado de reglas de FirewallD y de fail2ban
#################

# Para habilitar las reglas de FirewallD que bloqueen el acceso a los puertos
function habilitar_reglas_firewall_cmd(){
    echo "Habilitando reglas de FirewallD"

}

function habilitar_reglas_fail2ban() {
    echo "Habilitando reglas de Fail2Ban"

}

# Para habilitar todos los servicios necesarios
# - firewalld
# - fail2ban
# - httpd
# - sshd
function habilitar_servicios() {
    echo "Habilitando los servicios"
    systemctl start --now firewalld
    systemctl start --now fail2ban
    systemctl start --now httpd
    systemctl start --now sshd
}

#################
# Sección de inhabilitado de reglas de FirewallD y de fail2ban
#################
function deshabilitar_reglas_firewall_cmd() {
    echo "Deshabilitando reglas de FirewallD"
}
function deshabilitar_reglas_fail2ban() {
    echo "Deshabilitando reglas de Fail2Ban"
}

# Para deshabilitar servicios de fail2ban y cambiar a reglas permisivas para firewall-cmd
function deshabilitar_seguridad() {
    echo "Deteniendo servicios de seguridad..."
    systemctl stop --now fail2ban

}


####################
# Consultar estado de servicios
####################
function consultar_status(){
    systemctl status --all --no-pager \
        fail2ban \
        firewalld \
        httpd \
        sshd
}

######
# Loop principal
######

while true; do
    echo ""
    echo "========================================"
    echo "   CONFIGURACIÓN INICIAL PARA DEFENSA    "
    echo "========================================"
    echo "1) Instalar las herramientas fail2ban, firewall-cmd."
    echo "2) Habilitar los servicios (firewalld, fail2ban, httpd, sshd)"
    echo "3) Consultar estado de los servicios con systemd"
    echo "4) Aplicar las reglas de firewalld"
    echo "5) Aplicar las reglas de fail2ban"
    echo "6) Aplicar todas las reglas de fail2ban, firewalld"
    echo "7) Deshabilitar fail2ban"
    echo "8) Deshabilitar reglas de firewalld"
    echo "9) Deshabilitar todos los servicios de seguridad"
    echo "0) Salir"
    echo "========================================"
    read -p "Seleccione una opción [0-9]: " opcion

    case $opcion in
        1) instalar_dependencias;;
        2) habilitar_servicios;;
        3) consultar_status;;
        4) ;;
        5) ;;
        6) ;;
        7) ;;
        8) ;;
        9) ;;
        0)  echo "Saliendo..."
            exit 0
            ;;
        *)  echo "Opción inválida"
            ;;
    esac
done
