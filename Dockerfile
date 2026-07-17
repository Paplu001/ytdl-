FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
# NOTE: "unzip" is required by the Deno install script below — without it,
# the RUN curl ... | sh step fails on python:3.12-slim (unzip isn't present
# by default in this base image).
RUN apt-get update && apt-get install -y \
    ffmpeg \
    aria2 \
    curl \
    ca-certificates \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install Deno
RUN curl -fsSL https://deno.land/install.sh | sh

# Add Deno to PATH
ENV PATH="/root/.deno/bin:${PATH}"

# Verify Deno installation
RUN deno --version

# Copy Python requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Render assigns the actual port at runtime via the PORT env var (webapp.py
# reads it). This EXPOSE is just documentation for local `docker run`.
EXPOSE 10000

CMD ["python", "webapp.py"]
