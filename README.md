# 群智企业教练 MCP Server（Co-wisdom Coaching MCP）

[群智企业教练（Co-wisdom Coaching）](https://www.cw-coach.com/) 官方公开只读 **Model Context Protocol (MCP)** 服务，让 Claude、Cursor、VS Code、Codex、Cherry Studio 等 AI 客户端实时查询群智的高管教练、系统性团队教练、ICF 认证课程、公开活动及官网专业文章。

- **在线文档与资源导航（GitHub Pages）**：<https://eason-h.github.io/co-wisdom-coaching-mcp/>
- **群智企业教练官网**：<https://www.cw-coach.com/>

---

## 接口信息

| 项目 | 说明 |
| --- | --- |
| Endpoint URL | `https://www.cw-coach.com/mcp` |
| 传输协议（Transport） | `streamable-http`（无状态 JSON 模式） |
| 身份验证（Auth） | 无需鉴权（公开只读） |
| 服务名称（`serverInfo.name`） | `co-wisdom-coaching`（`v0.1.0`） |
| 支持的协议版本 | `2025-11-25`、`2025-06-18`、`2025-03-26`、`2024-11-05` |
| 工具权限特性 | 全部工具均标注 `readOnlyHint: true`、`destructiveHint: false`、`idempotentHint: true` |

---

## 可用工具（Tools）

| 工具名称 | 功能说明 | 参数 |
| --- | --- | --- |
| `list_coaching_services` | 查询群智的企业教练、ICF 认证课程、公开活动与公益教练服务入口 | `service_id`（可选）：`executive_coaching`、`team_coaching`、`coaching_leadership`、`icf_training`、`public_events`、`welfare_coaching`；省略则返回全部服务 |
| `search_coaching_articles` | 实时搜索群智官网公开文章、课程信息或活动公告 | `keyword`（可选，关键词，省略时返回近期文章）、`collection`（`all` \| `activity` \| `course`，默认 `all`）、`limit`（`1`–`10`，默认 `5`） |
| `get_coaching_article` | 按搜索结果返回的文章编号读取官网正文摘录与原文链接 | `article_id`（必填，来自 `search_coaching_articles` 结果的数字 `entity_id`） |

### 示例提问（Prompts）

接入 MCP 后，你可以直接在对话中这样提问：

- 「帮我查群智有哪些 ICF 认证课程」
- 「群智最近有什么公开活动、体验课或沙龙」
- 「群智的一对一高管教练和系统性团队教练分别面向什么场景」
- 「帮我搜索群智官网关于 Peter Hawkins 5C 模型的文章并读一下重点内容」

---

## 客户端接入配置

### Claude Code

```bash
claude mcp add --transport http co-wisdom-coaching https://www.cw-coach.com/mcp
```

完整脚本见 [`examples/claude-code.sh`](examples/claude-code.sh)。

### Claude Desktop

编辑 Claude Desktop 配置文件（macOS 位于 `~/Library/Application Support/Claude/claude_desktop_config.json`），通过 `mcp-remote` 桥接远程 Streamable HTTP 服务：

```json
{
  "mcpServers": {
    "co-wisdom-coaching": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://www.cw-coach.com/mcp"
      ]
    }
  }
}
```

示例文件见 [`examples/claude-desktop-config.json`](examples/claude-desktop-config.json)。

### Cursor

在 `~/.cursor/mcp.json`（或项目级 `.cursor/mcp.json`）中添加：

```json
{
  "mcpServers": {
    "co-wisdom-coaching": {
      "url": "https://www.cw-coach.com/mcp"
    }
  }
}
```

示例文件见 [`examples/cursor-mcp.json`](examples/cursor-mcp.json)。

### VS Code

在工作区 `.vscode/mcp.json` 中添加：

```json
{
  "servers": {
    "co-wisdom-coaching": {
      "type": "http",
      "url": "https://www.cw-coach.com/mcp"
    }
  }
}
```

示例文件见 [`examples/vscode-mcp.json`](examples/vscode-mcp.json)。

### OpenAI Codex CLI

在 `~/.codex/config.toml` 中添加：

```toml
[mcp_servers.co-wisdom-coaching]
url = "https://www.cw-coach.com/mcp"
```

示例文件见 [`examples/codex-config.toml`](examples/codex-config.toml)。

### Cherry Studio

在 **设置 → MCP 服务器 → 添加服务器** 中填写：

- **名称**：`co-wisdom-coaching`（或 `群智企业教练`）
- **类型**：`streamableHttp`（流式传输 HTTP）
- **URL**：`https://www.cw-coach.com/mcp`

---

## 快速测试（`curl`）

发送 `initialize` 与 `tools/list` 请求验证连通性（完整脚本见 [`examples/curl-test.sh`](examples/curl-test.sh)）：

```bash
curl -s -X POST https://www.cw-coach.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "MCP-Protocol-Version: 2025-06-18" \
  -d '{
    "jsonrpc": "2.0",
    "id": 1,
    "method": "initialize",
    "params": {
      "protocolVersion": "2025-06-18",
      "capabilities": {},
      "clientInfo": { "name": "curl-test", "version": "1.0.0" }
    }
  }'

curl -s -X POST https://www.cw-coach.com/mcp \
  -H "Content-Type: application/json" \
  -H "Accept: application/json, text/event-stream" \
  -H "MCP-Protocol-Version: 2025-06-18" \
  -d '{
    "jsonrpc": "2.0",
    "id": 2,
    "method": "tools/list"
  }'
```

---

## 关于群智企业教练

[群智企业教练（Co-wisdom Coaching）](https://www.cw-coach.com/) 由 **ICF MCC 大师级教练吴彦群（Karen）** 创立，是 **ICF（国际教练联合会）官方授权认证课程机构**，也是 **Peter Hawkins 系统性团队教练理论在中国的独家战略合作伙伴**。

- 已服务 **500+** 企业客户（包括微软、雀巢、正泰等）
- 培养 **1000+** PCC 水平教练，累计交付 **50000+** 教练小时

### 核心服务与课程入口

- 企业教练服务：[一对一高管教练](https://www.cw-coach.com/one-on-one-executive-coaching/)、[系统性团队教练](https://www.cw-coach.com/corporate-coaching-team-coaching/)、[教练型领导力](https://www.cw-coach.com/corporate-coaching-leadership-development/)
- ICF 认证课程：[CITO® 企业教练认证课](https://www.cw-coach.com/cito-corporate-coaching/)、[系统性团队教练认证课](https://www.cw-coach.com/systemic-team-coaching/)、[心理动力学高管教练认证课](https://www.cw-coach.com/psychodynamic-executive-coaching/)、[MCC 大师级教练认证课](https://www.cw-coach.com/co-wisdom-coaching-icf-mcc-masterclass-2025/)、[Mentor 督导认证课](https://www.cw-coach.com/mentor-coaching-icf-certification-cce-program/)
- 活动与百科：[体验课、沙龙与直播](https://www.cw-coach.com/activity-center/)、[什么是教练](https://www.cw-coach.com/what-is-coach/)、[ICF 教练认证指南](https://www.cw-coach.com/icf-certification-explained/)

---

## 相关链接

- **群智企业教练官网**：<https://www.cw-coach.com/>
- **项目介绍主页（GitHub Pages）**：<https://eason-h.github.io/co-wisdom-coaching-mcp/>
- **AI 站点摘要（`llms.txt`）**：<https://www.cw-coach.com/llms.txt>
- **MCP Registry 元数据**：[`server.json`](server.json)
- **Well-Known Server Card 参考配置**：[`server-card.json`](server-card.json)

---

## English Overview

**Co-wisdom Coaching MCP** is the official public read-only remote Model Context Protocol (MCP) server for [Co-wisdom Coaching (群智企业教练)](https://www.cw-coach.com/), a leading executive and systemic team coaching organization in China founded by ICF MCC Master Certified Coach Karen Wu (吴彦群) and the exclusive strategic partner of Peter Hawkins Systemic Team Coaching in China.

- **Endpoint**: `https://www.cw-coach.com/mcp`
- **Transport**: Streamable HTTP (`streamable-http`), stateless JSON, no authentication required
- **Tools**: `list_coaching_services`, `search_coaching_articles`, `get_coaching_article` (all marked `readOnlyHint: true`)
- **Documentation & Resource Directory**: <https://eason-h.github.io/co-wisdom-coaching-mcp/>

---

## License

[MIT](LICENSE)
