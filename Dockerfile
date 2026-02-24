FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    KIVY_NO_ARGS=1

RUN apt-get update && \
    apt-get install -y rsync && \
    apt-get install -y --no-install-recommends git libgomp1 && \
    rm -rf /var/lib/apt/lists/*

# Runtime/build dependencies commonly required by Kivy on Debian-based images.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libgl1 \
    libgles2 \
    libegl1 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libsm6 \
    libmtdev1 \
    libglib2.0-0 \
    libjpeg62-turbo \
    libpng16-16 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt ./
RUN pip install --upgrade pip && pip install -r requirements.txt

COPY . .

# Expect host data to be mounted at /data (pairs.json + images, output masks).
CMD ["python", "annotate_polygon.py", "--pairs-json", "/data/pairs.json", "--mask-out", "/data/masks"]
