FROM python:3.12-slim

ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    aria2 \
    curl \
    ca-certificates \
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

# Render uses PORT environment variable
EXPOSE 10000

CMD ["python", "webapp.py"]
