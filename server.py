import os
from fastmcp import FastMCP
from ai_contained.core.mcp import load_providers

mcp = FastMCP("ai-contained")
load_providers(mcp)

if __name__ == "__main__":
    mcp.run(
        transport="http",
        host=os.getenv("ADDRESS", "0.0.0.0"),
        port=int(os.getenv("PORT", "8080")),
        show_banner=False,
    )
