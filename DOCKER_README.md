# Docker Setup for News Portal

This guide explains how to run the News Portal application using Docker and Docker Compose.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) (version 20.10 or higher)
- [Docker Compose](https://docs.docker.com/compose/install/) (version 2.0 or higher)

## Quick Start

### 1. Environment Setup

The `.env` file has been created with default settings. You can modify it if needed:

```env
PUBLIC_API_BASE_URL="https://news-api.mediakautsar.com"
NODE_ENV=development
PORT=4321
HOSTNAME=0.0.0.0
```

### 2. Start the Application

Run the following command in the project root directory:

```bash
docker-compose up
```

Or to run in detached mode (background):

```bash
docker-compose up -d
```

The application will be available at: **http://localhost:4321**

### 3. Stop the Application

To stop the running container:

```bash
docker-compose down
```

## Docker Commands Reference

### Building and Starting

```bash
# Build and start the container
docker-compose up

# Build and start in background
docker-compose up -d

# Rebuild the image (if Dockerfile changes)
docker-compose up --build

# Force recreate containers
docker-compose up --force-recreate
```

### Managing Containers

```bash
# View running containers
docker-compose ps

# View logs
docker-compose logs

# Follow logs in real-time
docker-compose logs -f

# View logs for specific service
docker-compose logs news-portal

# Stop containers
docker-compose stop

# Start stopped containers
docker-compose start

# Restart containers
docker-compose restart

# Stop and remove containers
docker-compose down
```

### Cleaning Up

```bash
# Remove containers and volumes
docker-compose down -v

# Remove all images, containers, and volumes
docker-compose down --rmi all -v

# Prune unused Docker resources
docker system prune -a
```

## Container Architecture

### Port Mapping
- **Host Port**: 4321
- **Container Port**: 4321
- **Access URL**: http://localhost:4321

### Volume Mounts

The following directories are mounted for hot-reloading during development:

- `./src` → `/app/src` (source code)
- `./public` → `/app/public` (static assets)
- `node_modules` (named volume for better performance)

### Healthcheck

The container includes a healthcheck that:
- Checks every 30 seconds
- Times out after 10 seconds
- Retries up to 3 times
- Waits 40 seconds before starting checks

Check health status:
```bash
docker inspect --format='{{json .State.Health}}' news_portal_app
```

## Development Workflow

### Making Code Changes

1. Edit files in `./src` or `./public`
2. Changes are automatically reflected in the container
3. Astro's hot module replacement (HMR) will reload the browser

### Installing New Dependencies

```bash
# Install a new package
docker-compose exec news-portal npm install <package-name>

# Or rebuild the container
docker-compose down
docker-compose up --build
```

### Running Commands Inside Container

```bash
# Open a shell in the container
docker-compose exec news-portal sh

# Run npm commands
docker-compose exec news-portal npm run build
docker-compose exec news-portal npm run preview

# Check Node version
docker-compose exec news-portal node --version
```

## Production Deployment

### Building for Production

```bash
# Build production assets
docker-compose run --rm news-portal npm run build

# Preview production build
docker-compose run --rm news-portal npm run preview
```

### Environment Variables for Production

Update the `.env` file:

```env
PUBLIC_API_BASE_URL="https://your-production-api.com"
NODE_ENV=production
PORT=4321
```

## Troubleshooting

### Port Already in Use

If port 4321 is already in use, modify `docker-compose.yml`:

```yaml
ports:
  - "3000:4321"  # Use port 3000 on host
```

### Container Won't Start

1. Check logs:
   ```bash
   docker-compose logs
   ```

2. Rebuild the image:
   ```bash
   docker-compose up --build
   ```

3. Remove volumes and rebuild:
   ```bash
   docker-compose down -v
   docker-compose up --build
   ```

### Hot Reload Not Working

1. Ensure volume mounts are correct in `docker-compose.yml`
2. Check file permissions
3. Restart the container:
   ```bash
   docker-compose restart
   ```

### Dependencies Issues

If you encounter dependency issues:

```bash
# Remove node_modules volume
docker-compose down -v

# Rebuild and reinstall
docker-compose up --build
```

## File Structure

```
/news_portal
├── Dockerfile              # Container definition
├── .dockerignore          # Files excluded from build context
├── docker-compose.yml     # Service orchestration
├── .env                   # Environment variables
└── DOCKER_README.md       # This file
```

## Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Astro Documentation](https://docs.astro.build/)

## Support

For issues specific to Docker setup, check:
1. Docker daemon is running
2. Ports are not already in use
3. Environment variables are correctly set
4. Volume permissions are correct

For application-specific issues, refer to the main [README.md](./README.md) or [README_NEWS_PORTAL.md](./README_NEWS_PORTAL.md).