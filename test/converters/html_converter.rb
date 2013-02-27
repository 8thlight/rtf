require File.expand_path(File.dirname(__FILE__)+'/../helper_tests')
require 'rtf'
require 'rtf/converters'

class HTMLConverterTest < Test::Unit::TestCase
  def setup
    @html = <<-HTML
    <html>
      <head>
        <title>Test</title>
      </head>
      <body>
        <h1>Hello!</h1>
        <p>Hi</p><br/><p>Bye</p>

        <ul>
          <li>lists</li>
          <li>are</li>
          <li>fun</li>
        </ul>

        <table>
          <thead>
            <tr>
              <th>Me</th> <th> or </th> <th> me </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Hi</td><td>Hello</td><td><strong>HI</strong></td>
            </tr>
          </tbody>
        </table>

      </body>
    </html>
    HTML
  end

  def test_converts_html
    response = RTF::Converters::HTML.new("<h1>Hi</h1>").to_rtf
    assert(response.match(/{\\b\\fs44\nHi\n}\n{\\line}/))
  end

  def test_converts_empty_table_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table></table>").to_rtf
    end
  end

  def test_converts_table_with_single_row_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table><tr></tr></table>").to_rtf
    end
  end

  def test_converts_table_with_headers_and_no_rows_or_cells_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table><tr><th>first</th><th>second</th></tr></table>").to_rtf
    end
  end

  def test_converts_tables_with_thead_and_tbody_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table>
                                  <thead>
                                    <tr>
                                      <th>first</th><th>second</th>
                                    </tr>
                                  </thead>
                                  <tbody>
                                    <tr>
                                      <td>bill</td><td>bob</td>
                                    </tr>
                                  </tbody>
                                 </table>").to_rtf
    end
  end

  def test_converts_table_with_no_cells_without_failure
    assert_nothing_raised do
      RTF::Converters::HTML.new("<table>
                                  <tr><td>hi</td></tr>
                                  <tr></tr>
                                </table>").to_rtf
    end
  end

  def test_converts_html_file_with_table
    response = RTF::Converters::HTML.new(setup).to_rtf
    assert(response.match(/\n\\trowd\\tgraph100\n\\cellx300\n\\cellx600\n\\cellx900\n\\pard\\intbl\n\n\\cell\n\\pard\\intbl\n\n\\cell\n\\pard\\intbl\n\n\\cell\n\\row\n\\trowd\\tgraph100\n\\cellx300\n\\cellx600\n\\cellx900\n\\pard\\intbl\nHi\n\\cell\n\\pard\\intbl\nHello\n\\cell\n\\pard\\intbl\n{\\b\nHI\n}\n\\cell\n\\lastrow\n\\row\n}/))
  end

end
