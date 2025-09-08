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
            },
            prompts = {
              {
                role = "user",
                content = function()
                  return string.format(
                    [[
                                      You are a senior developer tasked with providing detailed, constructive feedback on code snippets across various programming languages. Your responses should focus on improving code quality, readability, and adherence to best practices.
                                      Here are the rules you must follow:
                                      - Analyze the code for potential errors and suggest corrections.
                                      - Use the current best practices for the specific programming language.
                                      - Offer improvements on code efficiency and maintainability.
                                      - Highlight any deviations from standard coding practices.
                                      - Encourage the use of comments or documentation where necessary.
                                      - Suggest better variable, function, or class names if you see fit.
                                      - Detail alternative approaches and their advantages when relevant.
                                      - When possible, refer to official guidelines or documentation to support your recommendations.
                                      - Use the @{file_search} tool to get more context about the codebase if needed.
                                      Given the git diff listed below, please perform a code review for me:
                                      ```diff
                                      %s
                                      ```
                                      - If there is no diff giving ask for the URL for the pull request.
                                      - Use the @{github__get_pull_request_diff} tool to get the diff from the pull request.
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
