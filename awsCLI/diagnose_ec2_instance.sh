#!/bin/bash

# Diagnóstico rápido para instancias EC2
# Autor: Francisco Boll

# Colores
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

separator() {
  echo -e "${CYAN}----------------------------- $1 -----------------------------${NC}"
}

# 1. Información del sistema
separator "SISTEMA"
echo "Hostname: $(hostname)"
echo "Uptime:"
uptime
echo

# 2. CPU y Memoria
separator "CPU Y MEMORIA"
echo "Uso de CPU y procesos más pesados:"
ps aux --sort=-%cpu | head -n 10
echo
echo "Uso de RAM:"
free -m
echo

# 3. Disco
separator "DISCO"
df -h
echo
echo "Directorios pesados en /var (top 10):"
du -sh /var/* 2>/dev/null | sort -hr | head -n 10
echo

# 4. Red
separator "RED"
echo "Interfaces de red:"
ip a
echo
echo "Conectividad (ping a 8.8.8.8):"
ping -c 4 8.8.8.8
echo
echo "Puertos abiertos:"
ss -tuln
echo

# 5. Servicios principales
separator "SERVICIOS"
for service in nginx apache2 docker sshd; do
  echo -e "\nEstado del servicio $service:"
  systemctl is-active --quiet $service && echo "${service} está ACTIVO" || echo "${service} está INACTIVO"
done
echo

# 6. Logs recientes del sistema
separator "LOGS DEL SISTEMA"
journalctl -n 20 --no-pager
echo

# 7. Últimos logs del kernel
separator "DMESG"
dmesg | tail -n 10
echo

# 8. Información de seguridad
separator "USUARIOS Y ACCESOS"
whoami
id
last -a | head
echo

# 9. Reglas de firewall
separator "FIREWALL (iptables)"
sudo iptables -L -n -v
echo

echo -e "${GREEN}Diagnóstico completado.${NC}"
