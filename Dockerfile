# Latest stable Python on Debian slim (Linux)
FROM python:3.12-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    LANG=C.UTF-8

# System deps for cloning, downloading, and extracting
RUN apt-get update && apt-get install -y --no-install-recommends \
      git ca-certificates curl unzip xz-utils tar \
    && rm -rf /var/lib/apt/lists/*

# Base working directory
WORKDIR /opt

ARG CACHE_BUST=1

# --- Clone BugLens (with submodules) ---
RUN git clone --recursive https://github.com/seclab-ucr/BugLens.git \
 && cd BugLens && git submodule update --init --recursive

# Optional: Python deps for BugLens if present
RUN bash -lc 'cd /opt/BugLens/app && pip install --no-cache-dir -r requirements.txt'

# --- Paths & URLs ---
ENV RES_DIR=/opt/resources \
    MSM_DIR=/opt/msm-android-10 \
    CODEQL_ZIP_URL=https://github.com/github/securitylab/releases/download/qualcomm-msm-codeql-database/msm-4.4-revision-2017-May-07--08-33-56.zip \
    MSM_TGZ_URL=https://android.googlesource.com/kernel/msm/+archive/f3a84757f21f0ea23cbd6aed7391d806638c0d20.tar.gz \
    MSM_EXTRA_TGZ_URL=https://android.googlesource.com/kernel/msm-extra/+archive/ed716fd749931264bb9dde8d8b1434446568b8c9.tar.gz

RUN mkdir -p "$RES_DIR" "$MSM_DIR"

# --- Download & extract CodeQL Qualcomm MSM 4.4 database snapshot ---
RUN curl -L -o "$RES_DIR/msm-4.4-codeql.zip" "$CODEQL_ZIP_URL" \
 && unzip -q "$RES_DIR/msm-4.4-codeql.zip" -d "$RES_DIR/msm-4.4-codeql" \
 && rm "$RES_DIR/msm-4.4-codeql.zip"

# --- Build Suture snapshot as "../msm-android-10" by merging msm and msm-extra ---
# Note: +archive tarballs have no top-level folder; extract directly into $MSM_DIR.
RUN curl -L "$MSM_TGZ_URL"        | tar -xz -C "$MSM_DIR" \
 && curl -L "$MSM_EXTRA_TGZ_URL"  | tar -xz -C "$MSM_DIR"

# Set default workdir to the BugLens repo
WORKDIR /opt/BugLens

CMD ["/bin/bash"]