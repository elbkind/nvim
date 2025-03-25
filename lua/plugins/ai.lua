return {
  {
    "Davidyz/VectorCode",
    enabled = false,
    version = "*", -- optional, depending on whether you're on nightly or release
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "VectorCode", -- if you're lazy-loading VectorCode
  },
  {
    "milanglacier/minuet-ai.nvim",
    enabled = false,
    config = function()
      -- -- This uses the async cache to accelerate the prompt construction.
      -- -- There's also the require('vectorcode').query API, which provides
      -- -- more up-to-date information, but at the cost of blocking the main UI.
      -- local vectorcode_cacher = require("vectorcode.cacher")
      -- -- Default configuration
      -- require("vectorcode").setup({
      --   async_opts = {
      --     debounce = 10,
      --     events = { "BufWritePost", "InsertEnter", "BufReadPost" },
      --     exclude_this = true,
      --     n_query = 1,
      --     notify = false,
      --     query_cb = require("vectorcode.utils").make_surrounding_lines_cb(-1),
      --     run_on_register = false,
      --   },
      --   exclude_this = true,
      --   n_query = 1,
      --   notify = true,
      --   timeout_ms = 5000,
      -- })

      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1, -- recommend for local model for resource saving
        -- I recommend beginning with a small context window size and incrementally
        -- expanding it, depending on your local computing power. A context window
        -- of 512, serves as an good starting point to estimate your computing
        -- power. Once you have a reliable estimate of your local computing power,
        -- you should adjust the context window to a larger value.
        context_window = 1024,
        -- provider_options = {
        --   openai_fim_compatible = {
        --     api_key = "TERM",
        --     name = "Ollama",
        --     end_point = "http://localhost:11434/v1/completions",
        --     stream = true,
        --     -- model = "qwen2.5-coder:14b",
        --     model = "qwen2.5-coder:7b",
        --     -- model = "hf.co/bartowski/zed-industries_zeta-GGUF:IQ3_XXS",
        --     optional = {
        --       max_tokens = 56,
        --       top_p = 0.9,
        --     },
        --     template = {
        --       prompt = function(pref, suff)
        --         local prompt_message = ""
        --         for _, file in ipairs(vectorcode_cacher.query_from_cache(0)) do
        --           prompt_message = prompt_message .. "<|file_sep|>" .. file.path .. "\n" .. file.document
        --         end
        --         return prompt_message .. "<|fim_prefix|>" .. pref .. "<|fim_suffix|>" .. suff .. "<|fim_middle|>"
        --       end,
        --       suffix = false,
        --     },
        --   },
        -- },
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            model = "qwen2.5-coder:7b",
            -- model = "deepseek-r1:70b",
            -- model = "hf.co/bartowski/zed-industries_zeta-GGUF:IQ3_XXS",
            optional = {
              max_tokens = 25,
              top_p = 0.9,
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          keymap = {
            -- accept whole completion
            accept = "<A-A>",
            -- accept one line
            accept_line = "<A-a>",
            -- accept n lines (prompts for number)
            accept_n_lines = "<A-z>",
            -- Cycle to prev completion item, or manually invoke completion
            prev = "<A-[>",
            -- Cycle to next completion item, or manually invoke completion
            next = "<A-]>",
            dismiss = "<A-e>",
          },
          show_on_completion_menu = true,
        },
      })
    end,
  },
  { "nvim-lua/plenary.nvim" },
  -- {
  --   "saghen/blink.cmp",
  --   optional = true,
  --   opts = {
  --     keymap = {
  --       ["<A-y>"] = {
  --         function(cmp)
  --           cmp.show({ providers = { "minuet" } })
  --         end,
  --       },
  -- },
  -- sources = {
  --   -- if you want to use auto-complete
  --   default = { "minuet" },
  --   providers = {
  --     minuet = {
  --       name = "minuet",
  --       module = "minuet.blink",
  --       score_offset = 100,
  --     },
  --       },
  --     },
  --   },
  -- },
}
