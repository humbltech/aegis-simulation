#!/bin/bash
# Aegis Simulation - Codespace Startup Script

set -e

echo ""
echo "============================================"
echo "  Aegis Incident Simulation Environment"
echo "============================================"
echo ""

# Check for GROQ_API_KEY
if [ -z "$GROQ_API_KEY" ]; then
    echo "WARNING: GROQ_API_KEY not set!"
    echo ""
    echo "To run simulations, you need a free Groq API key:"
    echo "  1. Get key: https://console.groq.com/keys"
    echo "  2. Run: export GROQ_API_KEY=gsk_your_key"
    echo "  3. Run: make incidents-up && make incident INCIDENT=replit"
    echo ""
else
    # Create .env file
    echo "GROQ_API_KEY=${GROQ_API_KEY}" > .env
    echo "API key configured in .env"

    # Wait for Docker to be ready
    echo "Waiting for Docker..."
    timeout 30 bash -c 'until docker info >/dev/null 2>&1; do sleep 1; done' || {
        echo "Docker not ready. Start manually with: make incidents-up"
        exit 0
    }

    echo "Starting incident simulation containers..."
    docker compose -f incidents/docker-compose.incidents.yml up -d

    echo ""
    echo "============================================"
    echo "  Environment Ready!"
    echo "============================================"
    echo ""
    echo "Incident Agents:"
    echo "  Replit DB Agent:   http://localhost:8010"
    echo "  Kiro Infra Agent:  http://localhost:8011"
    echo "  EchoLeak Agent:    http://localhost:8012"
    echo "  Cost Loop Agent:   http://localhost:8013"
    echo "  Copilot RCE Agent: http://localhost:8014"
    echo ""
    echo "Run an incident simulation:"
    echo "  make incident INCIDENT=replit"
    echo "  make incident INCIDENT=echoleak"
    echo "  make incident INCIDENT=cost-loop"
    echo ""
fi
