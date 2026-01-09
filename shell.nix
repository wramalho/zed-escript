{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_22
    cmake
    ninja
    git
    python3
    rustup
  ] ++ (if pkgs.stdenv.isDarwin then [
    pkgs.darwin.apple_sdk.frameworks.CoreServices
    pkgs.darwin.apple_sdk.frameworks.Security
    pkgs.libiconv
  ] else []);

  shellHook = ''
    echo "Welcome to the Escript LSP dev shell!"
    echo "Node.js version: $(node --version)"
    echo "CMake version: $(cmake --version | head -n1)"

    if command -v rustup >/dev/null; then
        echo "Rustup is available."
        echo "Ensure you have the WASM target installed for Zed extensions:"
        echo "  rustup target add wasm32-wasi"
        # Check for wasm32-wasi or wasm32-wasip1
        if rustup target list --installed | grep -q "wasm32-wasi"; then
             echo "  -> wasm32-wasi target detected."
        elif rustup target list --installed | grep -q "wasm32-wasip1"; then
             echo "  -> wasm32-wasip1 target detected."
        else
             echo "  WARNING: wasm32-wasi target NOT detected. Zed extension compilation may fail."
        fi
    else
        echo "WARNING: rustup not found. Zed requires Rust installed via rustup to compile extensions."
    fi
  '';
}
