# docker push ghcr.io/MarkusGnigler/n4d:latest
docker buildx build `
    --platform linux/amd64,linux/arm64,linux/arm/v7 `
    --tag ghcr.io/markusgnigler/n4d:latest `
    --push `
    .

exit 0