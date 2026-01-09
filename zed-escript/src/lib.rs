use zed_extension_api as zed;
use std::fs;

struct EscriptExtension {
}

impl zed::Extension for EscriptExtension {
    fn new() -> Self {
        Self {
        }
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

        // We look for the server in the current working directory, which for a Dev Extension
        // is the root of the extension folder.
        let current_dir = std::env::current_dir()
            .map_err(|e| format!("Failed to get current directory: {}", e))?;

        let server_path = current_dir.join(server_script);

        if !server_path.exists() {
             return Err(format!(
                "Server script not found at {:?}. Please ensure the extension is installed correctly with the 'server' directory.",
                server_path
            ));
        }

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
