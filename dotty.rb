class Dotty < Formula
  desc "Experimental Scala Compiler"
  homepage "http://dotty.epfl.ch/"
  url "https://github.com/lampepfl/homebrew-brew/releases/download/v0.1-M1/dotty-0.1.1-bin-SNAPSHOT.zip"
  sha256 "d5091aea45679c28774bb2039847a36a7c1f2a1abbe4ae9f79bf669afbca0232"
  # mirror "https://www.scala-lang.org/files/archive/scala-2.12.2.tgz"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install "bin", "lib"
  end

  test do
    file = testpath/"Test.scala"
    file.write <<-EOS.undent
      object Test {
        def main(args: Array[String]) = {
          println(s"${2 + 2}")
        }
      }
    EOS

    shell_output("#{bin}/dotc #{file}")
    out = shell_output("#{bin}/dotr Test").strip

    assert_equal "4", out
  end
end
