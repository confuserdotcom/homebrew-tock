# Homebrew formula for tock. make formula renders it from this template
# (v5.4.0, ecf5d427c2ff60050bf7f450d28976ff0d633e214b3582cc0bfaad410b135d1d); the release attaches the result. It goes in the tap
# repo homebrew-tock as Formula/tock.rb:
#   brew tap confuserdotcom/tock && brew trust confuserdotcom/tock
#   brew install tock && tock setup
class Tock < Formula
  desc "Time tracker that lives in your menu bar and notch"
  homepage "https://github.com/confuserdotcom/tock"
  url "https://github.com/confuserdotcom/tock/releases/download/v5.4.0/tock-v5.4.0-src.tar.gz"
  sha256 "ecf5d427c2ff60050bf7f450d28976ff0d633e214b3582cc0bfaad410b135d1d"
  license "MIT"

  depends_on "go" => :build

  def install
    # Go's caches inside the build folder: the build may not write to ~.
    ENV["GOPATH"] = buildpath/".gopath"
    ENV["GOCACHE"] = buildpath/".gocache"
    target = OS.mac? ? "dist-mac" : "dist-linux"
    system "make", target, "PREFIX=#{prefix}", "VERSION=v5.4.0"
  end

  def caveats
    <<~EOS
      Finish installing with:
        tock setup
      Run it again after each brew upgrade tock: it puts the new version in place.
      On macOS it makes a code-signing certificate that stays on this Mac (macOS
      asks for your password once), so Accessibility and Screen Recording stay
      granted across updates.
    EOS
  end

  test do
    assert_match "tock v5.4.0", shell_output("#{bin}/tock version")
  end
end
