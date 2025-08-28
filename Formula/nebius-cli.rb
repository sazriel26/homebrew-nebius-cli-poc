class NebiusCli < Formula
  desc "Nebius Cloud Public CLI"
  homepage "https://docs.nebius.com/cli/"
  license :cannot_represent

  livecheck do
    url "https://storage.eu-north1.nebius.cloud/cli/release/stable"
    regex(/^(.+)$/i)
  end

  on_macos do
    on_arm do
      version "0.12.105" # @github-actions-macos-latest@
      url "https://storage.eu-north1.nebius.cloud/cli/release/#{version}/darwin/arm64/nebius", using: :nounzip
    end
    on_intel do
      version "0.12.105" # FIXME: @github-actions-macos-latest@ but not exactly
      url "https://storage.eu-north1.nebius.cloud/cli/release/#{version}/darwin/x86_64/nebius", using: :nounzip
    end
  end

  on_linux do
    on_arm do
      version "0.12.105" # FIXME: @github-actions-ubuntu-latest@ but not exactly
      url "https://storage.eu-north1.nebius.cloud/cli/release/#{version}/linux/arm64/nebius", using: :nounzip
    end
    on_intel do
      if Hardware::CPU.is_64_bit?
        version "0.12.105" # FIXME: @github-actions-ubuntu-latest@
        url "https://storage.eu-north1.nebius.cloud/cli/release/#{version}/linux/x86_64/nebius", using: :nounzip
      end
    end
  end

  def install
    # Only one binary to link
    bin.install "nebius"

    # FIXME: official binary has not eXecution mode as expected (Homebrew 4.1.22-55-gd68e3e5)
    # [https://docs.brew.sh/Formula-Cookbook#bininstall-foo]
    chmod(0555, bin/"nebius")

    # Install shell completions
    generate_completions_from_executable(bin/"nebius", "completion", base_name: "nebius")
  end

  def caveats
    <<~EOS
      Consult homepage: #{homepage}
    EOS
  end

  test do
    assert_match "#{version.to_s}", shell_output("#{bin}/nebius version")
  end
end
