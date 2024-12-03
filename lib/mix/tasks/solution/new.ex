defmodule Mix.Tasks.Solution.New do
  use Mix.Task

  @shortdoc "Generates a new solution template"

  def run(args) do
    {opts, _, _} = OptionParser.parse(args, switches: [year: :string, day: :string])
    year = opts[:year] || to_string(Date.utc_today().year)
    day = opts[:day] || to_string(Date.utc_today().day |> Integer.to_string() |> String.pad_leading(2, "0"))
    day = String.pad_leading(day, 2, "0")

    solution_path = "lib/solutions/#{year}/#{day}.exs"
    content = """
    defmodule Solution do
      def read do
        "data/#{year}/#{day}.txt"
        |> File.read!()
        |> String.split(~r{\\n}, trim: true)
      end

      def part_1(input) do
        input
      end

      def part_2(input) do
        input
      end

      def main do
        data = read()

        IO.puts("Part I: " <> part_1(data))
        IO.puts("Part II: " <> part_2(data))
      end
    end

    Solution.main()
    """

    File.mkdir_p!("lib/solutions/#{year}")
    File.write!(solution_path, content)
    Mix.shell().info("Created solution file at #{solution_path}")

    data_path = "data/#{year}/#{day}.txt"
    File.mkdir_p!("data/#{year}")
    Mix.shell().info("Created data file at #{data_path}")
    File.write!(data_path, "")
  end
end
