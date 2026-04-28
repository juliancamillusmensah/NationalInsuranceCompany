# Free Hosting Deployment Guide

This project can be deployed to several free hosting platforms using Docker.

## Quick Start

### Option 1: Render.com (Easiest)

1. Push code to GitHub
2. Go to [render.com](https://render.com) → "New Web Service"
3. Connect your GitHub repo
4. Select **Docker** runtime
5. Deploy!

**Note:** Free tier spins down after 15 min inactivity (cold start ~30s).

---

### Option 2: Fly.io

```bash
# Install flyctl
# Windows: winget install Flyio.flyctl
# Mac: brew install flyctl
# Linux: curl -L https://fly.io/install.sh | sh

# Login and deploy
fly auth login
fly launch --dockerfile Dockerfile
fly volumes create nic_data --size 1
fly deploy
```

---

### Option 3: Railway.app

1. Push code to GitHub
2. Go to [railway.app](https://railway.app)
3. New Project → Deploy from GitHub repo
4. Railway auto-detects Dockerfile

**Note:** $5 free trial credit, then requires payment.

---

### Option 4: Oracle Cloud Always Free (Best Long-term)

1. Sign up at [cloud.oracle.com/free](https://cloud.oracle.com/free)
2. Create an ARM-based Compute instance (Ampere)
3. SSH into the VM:

```bash
# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# Clone and deploy
git clone <your-repo>
cd NationalInsuranceCompany
docker-compose up -d
```

4. Open port 8080 in Security List
5. Access at `http://<vm-ip>:8080`

**Benefits:** Truly free forever, 4 cores + 24GB RAM, always-on.

---

## Database Persistence

SQLite database is stored at `/data/nic_database.db`. Each platform handles persistence differently:

- **Render:** Uses disk mount at `/data`
- **Fly.io:** Uses volume mount at `/data`
- **Railway:** Uses volume (paid feature) or in-container (resets on deploy)
- **Oracle Cloud:** Persistent VM storage

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `JAVA_OPTS` | JVM options | `-Xmx512m -Xms256m` |
| `TZ` | Timezone | `UTC` |

## Important Notes

1. **Resend Email:** For email to work, update `email_from_address` in Email Settings to use a verified domain or `onboarding@resend.dev` for testing.

2. **Paystack:** Update API keys in Paystack Settings after deployment.

3. **First Admin:** Use the System Creator login to create the first admin, or use the invitation system.

4. **HTTPS:** Fly.io and Render provide HTTPS automatically. For Oracle Cloud, use Cloudflare or set up Nginx + Let's Encrypt.

## Troubleshooting

**Port binding errors:** Ensure app listens on `0.0.0.0:8080`, not just `localhost`.

**Database locked:** SQLite doesn't handle concurrent writes well. For high traffic, consider migrating to PostgreSQL.

**Memory issues:** Adjust `JAVA_OPTS` in the Dockerfile or docker-compose.yml.
