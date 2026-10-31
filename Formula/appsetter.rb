class Appsetter < Formula
  desc "View and set default apps for file types and URL schemes on macOS"
  homepage "https://github.com/SebAnton/appsetter"
  url "https://github.com/SebAnton/appsetter/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "449965692964773863d903d80af3052b7c72c04d126c8cab7ddcd28b3ee4ef89"
  license "MIT"

  depends_on xcode: ["15.0", :build]
  depends_on :macos

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release", "--product", "appsetter"
    bin_path = Utils.safe_popen_read("swift", "build", "--configuration", "release", "--show-bin-path").chomp
    bin.install "#{bin_path}/appsetter"
  end

  def caveats
    <<~EOS
      macOS asks you to confirm every default-app change in a dialog; reading defaults never prompts.
      Agents: run `appsetter guide` for the JSON contract.
    EOS
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/appsetter --version").strip
    assert_match "Using appsetter as an agent", shell_output("#{bin}/appsetter guide")
  end
end
