class Dotty < Formula
  desc "Experimental Scala Compiler"
  homepage "http://dotty.epfl.ch/"
  url "https://github.com/lampepfl/homebrew-brew/releases/download/v0.1-M3/dotty-0.1.1-bin-SNAPSHOT.tar.gz"
  sha256 "e7d05a3b75f3193f282204c02fca8aebf102ff3e48e1368180b5425e23e6594e"
  # mirror "https://www.scala-lang.org/files/archive/scala-2.12.2.tgz"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    rm_f Dir["bin/*.bat"]
    prefix.install "bin", "lib"
  end

  test do
    # test dotc and dotr:
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

    # test dotd:
    Dir.mkdir "#{testpath}/site"
    index_out = testpath/"site"/"index.md"
    index_out.write <<-EOS.undent
    Hello, world!
    =============
    EOS
    shell_output("#{bin}/dotd -siteroot #{testpath}/site #{file}")
    index_file = File.open("#{testpath}/site/_site/index.html", "rb").read
    assert index_file.include? '<h1><a href="#hello-world" id="hello-world">Hello, world!</a></h1>'
  end
end
