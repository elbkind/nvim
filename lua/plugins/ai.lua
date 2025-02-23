return {

  -- {
  --   "olimorris/codecompanion.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --   },
  --   sources = {
  --     per_filetype = {
  --       codecompanion = { "codecompanion" },
  --     },
  --   },
  -- },
  {
    "milanglacier/minuet-ai.nvim",
    config = function()
      require("minuet").setup({
        provider = "openai_fim_compatible",
        n_completions = 1, -- recommend for local model for resource saving
        -- I recommend beginning with a small context window size and incrementally
        -- expanding it, depending on your local computing power. A context window
        -- of 512, serves as an good starting point to estimate your computing
        -- power. Once you have a reliable estimate of your local computing power,
        -- you should adjust the context window to a larger value.
        context_window = 4096,
        provider_options = {
          openai_fim_compatible = {
            api_key = "TERM",
            name = "Ollama",
            end_point = "http://localhost:11434/v1/completions",
            model = "qwen2.5-coder:14b",
            -- model = "qwen2.5-coder:7b",
            -- model = "hf.co/bartowski/zed-industries_zeta-GGUF:IQ3_XXS",
            optional = {
              max_tokens = 56,
              top_p = 0.9,
            },
          },
        },
        -- provider_options = {
        --   openai_fim_compatible = {
        --     api_key = "TERM",
        --     name = "Ollama",
        --     end_point = "http://localhost:11434/v1/completions",
        --     -- model = "qwen2.5-coder:7b",
        --     -- model = "deepseek-r1:70b",
        --     model = "hf.co/bartowski/zed-industries_zeta-GGUF:IQ3_XXS",
        --     optional = {
        --       max_tokens = 25,
        --       top_p = 0.9,
        --     },
        --   },
        -- },
        virtualtext = {
          -- auto_trigger_ft = { "typescript", "javascript", "java" },
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
  -- optional, if you are using virtual-text frontend, nvim-cmp is not
  -- required.
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ["<A-y>"] = {
          function(cmp)
            cmp.show({ providers = { "minuet" } })
          end,
        },
      },
      sources = {
        -- if you want to use auto-complete
        default = { "minuet" },
        providers = {
          minuet = {
            name = "minuet",
            module = "minuet.blink",
            score_offset = 100,
          },
        },
      },
    },
  },
  -- { "hrsh7th/nvim-cmp" },
}
