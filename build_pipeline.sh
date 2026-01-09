#!/bin/bash
set -e

# Build the LSP server
echo "Building LSP server..."
npm install
npm run build

# Verify server build
if [ ! -f server/out/index.js ]; then
    echo "Error: Server build failed. server/out/index.js not found."
    exit 1
fi

# Package the server (mocking a release artifact)
echo "Packaging server..."
# We remove the tarball creation as it's not needed for the immediate "dev extension" usage
# but useful if we were to publish. I'll keep it as an artifact but won't commit it.
tar -czf escript-lsp-server.tar.gz server/out server/node_modules package.json

# Prepare Zed extension
echo "Preparing Zed extension..."
# We copy the server into the extension folder so it's bundled.
# The Rust extension logic expects 'server/out/index.js' in the current working directory
# of the extension (which should be the root of the extension folder).

mkdir -p zed-escript/server
cp -r server/out zed-escript/server/
cp -r server/node_modules zed-escript/server/
cp package.json zed-escript/server/

echo "Zed extension source is ready in 'zed-escript/'."
echo ""
echo "To install in Zed:"
echo "1. Open Zed."
echo "2. Open the Command Palette (Cmd+Shift+P)."
echo "3. Type 'zed: install dev extension'."
echo "4. Select the 'zed-escript' directory created by this script."
echo ""
echo "Note: You must have 'node' installed and available in your PATH for the extension to work,"
echo "or Zed must be able to find it."
