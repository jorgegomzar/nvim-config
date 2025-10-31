return {
  get_venv_python = function()
    local venv = os.getenv "VIRTUAL_ENV" or os.getenv "CONDA_PREFIX"
    if venv then
      return venv .. "/bin/python3"
    else
      return "python3"
    end
  end,
}
