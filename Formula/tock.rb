# Homebrew formula for tock. make formula renders it from this template
# (v5.2.0, 00eca0795643e0142210596f7d7dd5e7f0909b33d9f327ec2cac35fce9c5a6a9); the release attaches the result. It goes in the tap
# repo homebrew-tock as Formula/tock.rb:
#   brew install confuserdotcom/tock/tock && tock setup
class Tock < Formula
  desc "Time tracker that lives in your menu bar and notch"
  homepage "https://github.com/confuserdotcom/tock"
  url "https://github.com/confuserdotcom/tock/releases/download/v5.2.0/tock-v5.2.0-src.tar.gz"
  sha256 "00eca0795643e0142210596f7d7dd5e7f0909b33d9f327ec2cac35fce9c5a6a9"
  license "MIT"

  depends_on "go" => :build

  def install
    # Go's caches inside the build folder: the build may not write to ~.
    ENV["GOPATH"] = buildpath/".gopath"
    ENV["GOCACHE"] = buildpath/".gocache"
    target = OS.mac? ? "dist-mac" : "dist-linux"
    system "make", target, "PREFIX=#{prefix}", "VERSION=v5.2.0"
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
    assert_match "tock v5.2.0", shell_output("#{bin}/tock version")
  end
end
