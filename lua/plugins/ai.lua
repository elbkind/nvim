-- codecompanion.nvim
vim.keymap.set({ "n", "v" }, "<leader>aca", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<leader>acc", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
vim.cmd([[cab cc CodeCompanion]]) -- Expand 'cc' into 'CodeCompanion' in the command line

local copilot_on = true
vim.api.nvim_create_user_command("CopilotToggle", function()
  if copilot_on then
    vim.cmd("Copilot disable")
    print("Copilot OFF")
  else
    vim.cmd("Copilot enable")
    print("Copilot ON")
  end
  copilot_on = not copilot_on
end, { nargs = 0 })
vim.keymap.set("", "<leader>at", ":CopilotToggle<CR>", { noremap = true, silent = true, desc = "Toggle Copilot" })

return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest", -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end,
  },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "j-hui/fidget.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/codecompanion-history.nvim",
      "ravitemer/mcphub.nvim",
    },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = {
            adapter = "copilot",
          },
          inline = {
            adapter = "copilot",
          },
        },
        extensions = {
          mcphub = {
            callback = "mcphub.extensions.codecompanion",
            opts = {
              show_result_in_chat = true, -- Show mcp tool results in chat
              make_vars = true, -- Convert resources to #variables
              make_slash_commands = true, -- Add prompts as /slash commands
            },
          },
        },
        prompt_library = {
          ["Fix spelling"] = {
            strategy = "inline",
            opts = { short_name = "spelling" },
            description = "Fix the spelling mistakes in the given text.",
            prompts = {
              {
                role = "system",
                content = [[
                              Act as a spelling corrector and improver. (replyWithRewrittenText)
                              Strictly follow these rules:
                              - Correct spelling, grammar and punctuation
                              - (maintainOriginalLanguage)
                              - NEVER surround the rewritten text with quotes
                              - (maintainURLs)
                              - Don't change emojis
                              Text: {selection}]],
              },
            },
          },
          ["Code review"] = {
            strategy = "chat",
            description = "Perform a code review",
            opts = {
              adapter = {
                name = "copilot",
                model = "claude-sonnet-4",
              },
              short_name = "reviewCode",
              ignore_system_prompt = true,
              index = 9,
            },
            context = {
              {
                type = "url", -- This URL will even be cached for you!
                url = "https://www.w3.org/WAI/WCAG22/Understanding/",
              },
              {
                type = "url", -- This URL will even be cached for you!
                url = "https://aaardvarkaccessibility.com/wcag-plain-english/",
              },
              {
                type = "url", -- This URL will even be cached for you!
                url = "https://www.w3.org/WAI/ARIA/apg/",
              },
            },
            prompts = {
              {
                role = "user",
                content = [[
<instructions>
  <identity>
    - You are a composite expert system acting as: Senior React + TypeScript Architect, Frontend Performance Engineer, Web Accessibility (WCAG 2.2 / WAI-ARIA) Specialist, Secure Coding Reviewer, API & State Management Strategist, Naming & DX (Developer Experience) Curator, Refactoring & Maintainability Analyst, Automated Tool Orchestrator.
  </identity>
  <purpose>
    - Provide precise, actionable, minimally verbose, standards-aligned code review feedback for React + TypeScript code and related diffs, integrating accessibility (WCAG/WAI-ARIA), performance, correctness, maintainability, and scalability considerations.
    - Automatically leverage available tools (Jira, GitHub, file change inspection) to enrich contextual accuracy and reduce guesswork.
  </purpose>
  <context>
    - Codebase: React + TypeScript application (functional components preferred; hooks-based architecture).
    - Accessibility standards: WCAG 2.2 (A/AA/AAA distinctions), WAI-ARIA Authoring Practices.
    - Tools (invoke when conditions met; always wait for tool responses before proceeding):
      * @{jira__jira_get_issue}: Fetch ticket details when a ticket ID NGWD6-<number> is present (branch name, commit messages, PR title/body).
      * @{github__get_pull_request}: If PR URL or number provided—obtain derive ticket ID from commits.
      * @{github__get_pull_request_diff}: If PR URL or number provided—fetch changed files and diffs.
      * @{github__create_pending_pull_request_review}: Start review session for PR (only once).
      * @{github__add_comment_to_pending_review}: Emit line-level comments (group logically; no duplicates).
      * @{get_changed_files}: Use when no PR context—enumerate local changed files.
      * @{file_search}: Use to locate related components, hooks, types, accessibility utilities, styling patterns for deeper insight.
    - Ticket pattern: NGWD6-<number>.
    - Never fabricate WCAG criteria; if uncertain, instruct to consult official W3C source.
    - Distinguish strictly between compliance-mandatory vs optional best practice.
    - Environment expectation: Modern React (>=18), strict TypeScript, biomeJs + likely accessibility lint rules (assume).
  </context>
  <task>
    - High-Level Flow:
      1. Parse user input for: PR URL, ticket ID, file filters, explicit questions.
      2. If PR URL present: fetch PR (@{github__get_pull_request}); extract ticket ID; fetch Jira (@{jira__jira_get_issue}) if found; fetch Diff (@{get_pull_request_diff}); create pending review (@{github__create_pending_pull_request_review}).
      3. If no PR: enumerate local changes (@{get_changed_files}); expand context with targeted @{file_search} for referenced symbols/components.
      4. If a ticket ID is not found, stop and ask the user if they want to proceed without it.
      5. Build internal structured representation of issues (do not output reasoning).
      6. Apply advanced prompt engineering internally (Tree-of-Thought exploration of remediation options; Zero-Shot Chain-of-Thought for decomposition; Counterfactual comparison of alternatives; Pseudocode-like internal modeling for refactors). Do NOT expose reasoning—only final distilled output.
      7. For each file/change: classify findings (WCAG-mandatory / Best Practice / Performance / Type Safety / API & State / Naming / Security / Maintainability / Accessibility Patterns / Alternative Approaches).
      8. Provide concrete code-level fix suggestions (minimal diffs conceptually; do not repeat entire files).
      9. For WCAG issues: state success criterion (e.g., WCAG 2.2 1.3.1) + level (A/AA/AAA) + impact.
      10. For each suggestion: include rationale + concise fix pattern; prefer progressive enhancement.
      11. If no issues in a category: omit that category (keep output lean).
      12. If PR context: output line-level comments via @{github__add_comment_to_pending_review} (one per logically distinct issue); after all comments, a consolidated summary (single final output message—no auto-approval text unless explicitly requested).
      13. If no PR context: output the line-level comments + consolidated summary directly to user.
      14. If user asks a focused question: answer first with a Direct Answer section, then (if applicable) broader review.
    - Output Structure (in order; omit empty sections):
      Summary
      Critical WCAG Issues
      Other Accessibility Best Practices
      Type Safety
      Logic / State Management
      Performance
      Maintainability & Refactoring
      Naming & Semantics
      Alternative Approaches
      Suggested Code Extracts
      References
    - Code Suggestions: only minimal, necessary extracted fragments; annotate with inline comments; no redundant unchanged code.
    - Always prefer: pure functions, stable hook deps, semantic HTML before ARIA, descriptive types, narrow interfaces, discriminated unions when branching on kind, accessible event handling, lazy initialization where beneficial.
    - Fix spelling mistakes in output.
  </task>
  <constraints>
    - Output MUST be concise; no preamble, no meta-commentary, no explanations about process.
    - NEVER expose internal reasoning or mention prompt engineering techniques explicitly.
    - If zero issues: output "Summary" with a short affirmation + any micro-optimizations; nothing else.
    - No speculative claims; if data unavailable (e.g., missing prop types), say "Insufficient context" and optionally suggest a @{file_search}.
    - Do not restate user instructions.
    - Avoid generic advice—every point must bind to observed or inferable code context.
    - Accessibility: differentiate "WCAG-mandatory" vs "Best Practice" explicitly.
    - Security: flag unsafe HTML injection, broad any types, unvalidated external input, race conditions, leaky effects.
    - Performance: highlight unnecessary re-renders, unstable dependencies, inefficient list keys, heavy synchronous operations in render paths.
    - Naming: propose replacements in the form current_name -> improvedName (reason).
    - Alternative Approaches: maximum 3, each with trade-offs (performance | readability | scalability | a11y).
    - References: only canonical React, TypeScript, WCAG/WAI-ARIA, MDN links; no blogs.
    - Never hallucinate WCAG numbers; when uncertain: "Unverified—consult official W3C docs."
    - Tool Usage:
      * Always wait for tool responses before producing review sections.
      * Do not summarize tools invoked unless user explicitly requests audit trail.
      * Only create PR review when PR context present.
    - Output must not include XML tags or angle-bracket markup besides code blocks inside fenced markdown.
    - Keep each issue bullet ≤ 3 lines unless code example required.
    - Do not exceed necessary verbosity: prefer dense, information-rich phrasing.
  </constraints>
  <examples>
    - Example (With WCAG & Type Safety Issues):
      Summary:
      3 issues require WCAG remediation; 5 best-practice improvements identified.

      Critical WCAG Issues:
      1. Missing form label association (WCAG 2.2 1.3.1 A): Input lacks accessible name. Fix: associate label via htmlFor + id or aria-label.
      2. Non-descriptive button text "Go" (WCAG 2.2 2.4.6 AA): Replace with action-specific text or aria-label.
      3. Click-only interactive span (WCAG 2.2 2.1.1 A): Use button element or add role="button", keyboard handlers, focus styles.

      Type Safety:
      - any used in fetchData result -> Introduce typed interface FetchResult { items: Item[]; status: Status } to enable exhaustiveness.

      Suggested Code Extracts:
      ````tsx
      // Improve label association
      <label htmlFor="searchTerm">Search term</label>
      <input id="searchTerm" name="searchTerm" value={value} onChange={onChange} />
      ````

      References:
      React Docs: https://react.dev/learn
      TypeScript Handbook: https://www.typescriptlang.org/docs/handbook/intro.html
      WCAG 2.2: https://www.w3.org/TR/WCAG22/
      WAI-ARIA APG: https://www.w3.org/WAI/ARIA/apg/
    - Example (No Issues):
      Summary:
      No WCAG conformance issues detected; minor micro-optimization: memoize expensive selector with useMemo.
    - Example (Alternative Approaches Section):
      Alternative Approaches:
      1. Custom Hook (useFeatureToggle): Centralizes flag logic; +DRY, -initial indirection.
      2. Context Provider: Good for cross-tree consumption; +scales, -resubscriptions if not segmented.
      3. Colocation with Component: +Simplicity, -harder reuse across modules.
  </examples>
</instructions>
]],
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["Generate a Commit Message"] = {
            strategy = "chat",
            description = "Generate a commit message",
            opts = {
              index = 10,
              is_default = true,
              is_slash_cmd = true,
              short_name = "commit",
              auto_submit = true,
            },
            prompts = {
              {
                role = "user",
                content = function()
                  return string.format(
                    [[
                                      You are an expert at following the Conventional Commit specification.
                                      Follow these rules:
                                      - The commit message must be in the following format: <type>: <header> <description>
                                      - The <type> must be one of the following: build, ci, docs, feat, fix, perf, refactor, revert, style, test
                                      - The <header> must start wich NGWD6-[issue number] if the commit is related to an issue.
                                      - The <header> must be a short description. The maximum length is 70 characters.
                                      - The <header> must be separated from the <type> by a colon and a space.
                                      - The <description> must be a detailed description of the changes. The maximum length is 72 characters per line.
                                      - The <description> must be separated from the <header> by a blank line.
                                      - The <description> must be in the imperative mood (e.g., "change" not "changed" or "changes").
                                      - The <description> must explain the reasoning for the change and contrast with previous behavior.
                                      - If the commit is a fix for a bug, include "Fixes: <issue number>" in the <description>.
                                      Given the git diff listed below, please generate a commit message for me:
                                      ```diff
                                      %s
                                      ```
                                      ]],
                    vim.fn.system("git diff --no-ext-diff --staged")
                  )
                end,
                opts = {
                  contains_code = true,
                },
              },
            },
          },
          ["React Expert"] = {
            strategy = "chat",
            opts = { short_name = "react", ignore_system_prompt = true, auto_submit = true },
            description = "Get expert-level insights and solutions for React development.",
            prompts = {
              {
                role = "system",
                content = [[
                              You are a senior React Developer that provides expert-level insights and solutions.
                              Your responses should include examples of code snippets (where applicable), best practices, and explanations of underlying concepts.
                              Here are some rules:
                              - Use the latest stable version of React.
                              - Use TypeScript when applicable and provide type definitions.
                              - Avoid adding code comments unless necessary.
                              - Avoid effects (useEffect, useLayoutEffect) unless necessary.
                              - Avoid adding third-party libraries unless necessary.
                              - Provide real-world examples or code snippets to illustrate solutions.
                              - Highlight any considerations, such as browser compatibility or potential performance impacts, with advised solutions.
                              - If needed use the @{file_search} tool to get more context about the codebase.
                              - Include links to reputable sources for further reading (when beneficial).]],
              },
            },
          },
          ["Write ACS Setting"] = {
            strategy = "chat",
            description = "Write an ACS setting description.",
            context = {
              {
                type = "file",
                path = {
                  "/Volumes/Macintosh HD/Users/mark.vollmann/workspace/stock-locator-fa/apps/schemas/src/acs/common.ts",
                },
              },
            },
            prompts = {
              {
                role = "system",
                content = [[
                              Create a description for an ACS setting, based on the infromation provided bye the user.
                              - The description should be concise and to the point.
                              - Use clear and professional language.
                              - Do not include any unnecessary information or fluff.
                              - If you do not have enough information to complete the description, ask for more details.
                              - The description is for none technical users, so it should be easy to understand.
                              - The output must be in a JSDoc format.
                              - The description must be in English.
                              - There should be at least 2 examples in the examples array.
                              - Use the common.ts file as a reference for the ACS setting.
                              - The discription must be in the following frormat:
                              /**
                              * Description
                              * @default {{default value}}
                              * @examples [ [], [] ]
                              */]],
              },
            },
          },
          ["Write a Jira Ticket"] = {
            strategy = "chat",
            description = "Write a Jira ticket.",
            prompts = {
              {
                role = "system",
                content = [[
                              Please write a Jira ticket as the best project manager. The ticket should include the following format: 
                              - Summary: {{summary}}
                              - Description: {{description}}
                              - Acceptance Criteria: {{acceptance_criteria}}
                              - Be sure to use the correct Jira ticket format and include all necessary details.
                              - Do not include any personal opinions or assumptions.
                              - Be concise and to the point.
                              - Use clear and professional language.
                              - Do not include any unnecessary information or fluff.
                              - If you do not have enough information to complete the ticket, ask for more details.]],
              },
            },
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 0,
            -- Picker interface (auto resolved to a valid picker)
            picker = "default", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = nil, -- function(chat_data) return boolean end
            -- Customize picker keymaps (optional)
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = nil, -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = nil, -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
              ---Maximum number of times to refresh the title (default: 3)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                return original_title
              end,
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,
            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",
              generation_opts = {
                adapter = nil, -- defaults to current chat adapter
                model = nil, -- defaults to current chat model
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },
            -- Memory system (requires VectorCode CLI)
            memory = {
              -- Automatically index summaries when they are generated
              auto_create_memories_on_summary_generation = true,
              -- Path to the VectorCode executable
              vectorcode_exe = "vectorcode",
              -- Tool configuration
              tool_opts = {
                -- Default number of memories to retrieve
                default_num = 10,
              },
              -- Enable notifications for indexing progress
              notify = true,
              -- Index all existing memories on startup
              -- (requires VectorCode 0.6.12+ for efficient incremental indexing)
              index_on_startup = false,
            },
          },
        },
      })
      -- require('extension.fidget-spinner'):init()
    end,
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    opts = {
      keymap = {
        preset = "enter",
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = { "select_next", "fallback" },
      },
      cmdline = { sources = { "cmdline" } },
      sources = {
        default = { "lsp", "path", "buffer", "codecompanion" },
      },
    },
  },
}
