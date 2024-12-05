defmodule Mix.Tasks.Solution.New do
  use Mix.Task

  @shortdoc "Generates a new solution template"

  def safe_file_write(path, content) do
    case File.write(path, content, [:exclusive]) do
      :ok ->
        IO.puts("File created and content written successfully.")

      {:error, :eexist} ->
        IO.puts("File already exists. Aborting operation.")

      {:error, reason} ->
        IO.puts("Failed to write to the file. Reason: #{inspect(reason)}")
    end
  end

  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [year: :string, day: :string])
    year = opts[:year] || to_string(Date.utc_today().year)

    day =
      opts[:day] ||
        to_string(Date.utc_today().day |> Integer.to_string() |> String.pad_leading(2, "0"))

    day = String.pad_leading(day, 2, "0")

    solution_path = "lib/solutions/#{year}/#{day}.exs"

    content = """
    defmodule Solution do
      import Common.Input
      import Common.Output

      def parse_input(input) do
        input
      end

      def part_1(input) do
        input
      end

      def part_2(input) do
        input
      end

      def main do
        data = read_input(#{year}, #{day}) |> parse_input()

        IO.inspect(data)

        # pretty_print(1, &part_1/1, data)
        # pretty_print(2, &part_2/1, data)
      end
    end

    Solution.main()
    """

    File.mkdir_p!("lib/solutions/#{year}")
    safe_file_write(solution_path, content)
    Mix.shell().info("Created solution file at #{solution_path}")

    data_path = "data/#{year}/#{day}.txt"
    File.mkdir_p!("data/#{year}")
    Mix.shell().info("Created data file at #{data_path}")
    safe_file_write(data_path, "")
  end
end
