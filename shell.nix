{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs_22
    cmake
    ninja
    git
    python3
  ];

  shellHook = ''
    echo "Welcome to the Escript LSP dev shell!"
    echo "Node.js version: $(node --version)"
    echo "CMake version: $(cmake --version | head -n1)"
  '';
}
