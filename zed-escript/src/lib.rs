use zed_extension_api as zed;
use std::path::Path;

mod constants;

struct EscriptExtension;

impl zed::Extension for EscriptExtension {
    fn new() -> Self {
        Self
    }

    fn language_server_command(
        &mut self,
        _language_server_id: &zed::LanguageServerId,
        worktree: &zed::Worktree,
    ) -> Result<zed::Command, String> {
        let node_path = zed::node_binary_path()
            .ok()
            .or_else(|| worktree.which("node"))
            .ok_or_else(|| "Node.js must be installed and available in PATH or via zed::node_binary_path".to_string())?;

        let server_script = "server/out/index.js";
        let extension_path = Path::new(constants::EXTENSION_PATH);
        let server_path = extension_path.join(server_script);

        // Note: We cannot verify if the file exists here because we are running inside a WASM sandbox
        // which may not have access to the absolute path on the host system.
        // We rely on the process spawn to fail if the path is invalid.

        Ok(zed::Command {
            command: node_path,
            args: vec![
                server_path.to_string_lossy().to_string(),
                "--stdio".to_string(),
            ],
            env: Default::default(),
        })
    }
}

zed::register_extension!(EscriptExtension);
