docker buildx build `
    --platform linux/amd64,linux/arm64,linux/arm/v7 `
    --tag registry.bit-shifter.at/ngind:latest `
    --push `
    .

exit 0