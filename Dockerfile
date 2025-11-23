FROM dspace/dspace-angular:dspace-9_x

# Pre-configure environment variables for your domain
ENV DSPACE_UI_SSL=false \
    DSPACE_UI_HOST=elibrary.dimtmw.com \
    DSPACE_UI_PORT=80 \
    DSPACE_UI_NAMESPACE=/ \
    DSPACE_REST_SSL=false \
    DSPACE_REST_HOST=api.elibrary.dimtmw.com \
    DSPACE_REST_PORT=80 \
    DSPACE_REST_NAMESPACE=/server

EXPOSE 4100