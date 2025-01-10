# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/.local/bin:${PATH}"

# Update system and install essential packages
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    vim \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    git \
    nodejs \
    npm \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    libpq-dev \
    libjpeg-dev \
    zlib1g-dev \
    libevent-dev \
    libfreetype6-dev \
    xfonts-base \
    xfonts-75dpi \
    unzip \
    && apt-get clean

# Install wkhtmltopdf for Odoo PDF reports
RUN wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.jammy_amd64.deb && \
    dpkg -i wkhtmltox_0.12.6-1.jammy_amd64.deb || true && \
    apt-get install -f -y && \
    rm wkhtmltox_0.12.6-1.jammy_amd64.deb

# Install Odoo dependencies
RUN pip3 install wheel babel decorator docutils ebaysdk \
    feedparser gevent greenlet html2text Jinja2 lxml Mako MarkupSafe mock \
    num2words ofxparse passlib Pillow psutil psycopg2-binary pydot pyparsing \
    PyPDF2 pyserial python-dateutil python-ldap python-openid pytz pyusb \
    qrcode reportlab requests six suds-jurko vobject Werkzeug XlsxWriter xlwt \
    xlrd polib pdfminer.six num2words

# Clone Odoo source code (adjust version as needed)
RUN git clone https://github.com/odoo/odoo.git --depth 1 --branch 16.0 /opt/odoo

# Install JupyterLab
RUN pip3 install jupyterlab

# Add configuration files (optional)
WORKDIR /opt/odoo
COPY ./odoo.conf /etc/odoo.conf

# Expose the required ports
EXPOSE 8069 8888

# Default command to start both Odoo and JupyterLab
CMD ["/bin/bash", "-c", "jupyter lab --ip=0.0.0.0 --no-browser --allow-root & python3 /opt/odoo/odoo-bin -c /etc/odoo.conf"]
