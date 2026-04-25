import os
from fastmcp import FastMCP
from starlette.responses import JSONResponse
from ai_contained.core.mcp import load_providers

mcp = FastMCP("ai-contained")
load_providers(mcp)

# https://gofastmcp.com/v2/deployment/http#health-checks
@mcp.custom_route("/health", methods=["GET"])
async def health_check(request):
    return JSONResponse({"status": "healthy"})

if __name__ == "__main__":
    mcp.run(
        transport="http",
        host=os.getenv("ADDRESS", "0.0.0.0"),
        port=int(os.getenv("PORT", "8080")),
        show_banner=False,
    )
