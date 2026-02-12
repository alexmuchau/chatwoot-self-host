set -e

echo ">> Copying tunnel config and credentials..."
cp /home/alekkdev/Documents/chatwoot-self-host/config.yml /etc/cloudflared/chatwoot.yml
cp /home/alekkdev/.cloudflared/bddd6dfe-dd20-4ee1-9d9c-916eea829a04.json /etc/cloudflared/

echo ">> Creating systemd service..."
cat > /etc/systemd/system/cloudflared-chatwoot.service << 'EOF'
[Unit]
Description=Cloudflare Tunnel - Chatwoot
After=network-online.target
Wants=network-online.target

[Service]
TimeoutStartSec=15
Type=notify
ExecStart=/usr/bin/cloudflared --no-autoupdate --config /etc/cloudflared/chatwoot.yml tunnel run
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

echo ">> Enabling and starting service..."
systemctl daemon-reload
systemctl enable cloudflared-chatwoot.service
systemctl start cloudflared-chatwoot.service

echo ">> Done! Checking status:"
systemctl status cloudflared-chatwoot.service --no-pager