defmodule Swoosh.Attachment do
  @moduledoc """
  Struct representing an attachment in an email.
  """

  defstruct filename: nil, content_type: nil, path: nil, file_content: nil

  @type t :: %__MODULE__{}

  @doc ~S"""
  Creates a new Attachment

  Examples:

      Attachment.new("/path/to/attachment.png")
      Attachment.new("/path/to/attachment.png", filename: "image.png")
      Attachment.new("/path/to/attachment.png", filename: "image.png", content_type: "image/png")
      Attachment.new(params["file"]) # Where params["file"] is a %Plug.Upload
  """
  @spec new(binary, Keyword.t) :: %__MODULE__{}
  def new(path, opts \\ [])

  if Code.ensure_loaded?(Plug) do
    def new(
      %Plug.Upload{
        filename: filename,
        content_type: content_type,
        path: path
      },
      opts
    ) do
      new(
        path,
        Keyword.merge(
          [filename: filename, content_type: content_type],
          opts
        )
      )
    end
  end

  def new(path, opts) do
    filename = opts[:filename] || Path.basename(path)
    content_type = opts[:content_type] || MIME.from_path(path)
    file_content = opts[:file_content] || nil
    if is_nil(file_content) do
      %__MODULE__{path: path, filename: filename, content_type: content_type}
    else
      %__MODULE__{path: path, filename: filename, file_content: file_content, content_type: content_type}
    end
  end
end
