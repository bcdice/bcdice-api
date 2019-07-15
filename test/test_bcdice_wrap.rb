# frozen_string_literal: true

require "test/unit"

require_relative "../lib/bcdice_wrap.rb"

class BCDiceWrapTest < Test::Unit::TestCase
  data("単純な四則演算", ["C(1+2-3*4/5)", true])
  data("括弧を含む四則演算", ["C(1+(2-3*4/(5/6))-7)", true])
  data("計算コマンドの後に文字列が存在する場合（空白あり）", ["C(10+5) mokekeke", true])
  data("計算コマンドの後に文字列が存在する場合（空白なし）", ["C(10+5)mokekeke", false])
  data("Cの後に数字のみが続く場合", ["C42", false])
  data("括弧が閉じられていない場合", ["C(1+2", false])
  data("空白で始まる場合", [" C(1+2)", false])
  def test_seem_to_be_calc?(data)
    input, expected = data
    assert_equal(expected, BCDice.seem_to_be_calc?(input))
  end
end
