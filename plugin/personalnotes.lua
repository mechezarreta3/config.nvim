-- Function to open (or create) a note file.
local function open_note_file()
  -- Get the full path of the current file in the active buffer.
  local current_file = vim.api.nvim_buf_get_name(0)
  if current_file == "" then
    print("No file associated with the current buffer!")
    return
  end

  -- Extract the directory and filename from the current file path.
  local dir = vim.fn.fnamemodify(current_file, ":p:h")
  local filename = vim.fn.fnamemodify(current_file, ":t")

  -- Define the notes directory within the current file's directory
  local notes_dir = dir .. "/.notes"

  -- If the .notes directory doesn't exist, create it (with parents if needed)
  if vim.fn.isdirectory(notes_dir) == 0 then
    vim.fn.mkdir(notes_dir, "p")
  end

  -- Construct the note file's name.
  -- This example simply appends "_note.md" to the filename.
  local note_filename = filename .. "_note.md"
  local note_filepath = notes_dir .. "/" .. note_filename

  -- Open a vertical split with the note file.
  -- If the file does not exist, Neovim will open an empty buffer which will be
  -- saved as the new file written.
  vim.cmd("rightbelow vsplit " .. vim.fn.fnameescape(note_filepath))
end

-- Map a key to call function in normal mode
vim.keymap.set("n", "<space>tn", open_note_file, { silent = true })
