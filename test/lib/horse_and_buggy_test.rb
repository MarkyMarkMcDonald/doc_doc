require 'test_helper'

module DocDoc
  class HorseAndBuggyTest < ::Minitest::Test
    def test_road_is_closed_eh_for_connection_error
      horse_and_buggy = HorseAndBuggy.new(0)
      assert(horse_and_buggy.road_closure('http://will-never-exist.example'))
    end

    def test_road_is_closed_eh_for_page_not_found
      horse_and_buggy = HorseAndBuggy.new(0)
      assert(horse_and_buggy.road_closure('https://github.com/markymarkmcdonald/project-does-not-exist'))
    end

    def test_road_is_closed_eh_for_open_road
      horse_and_buggy = HorseAndBuggy.new(0)
      assert(!horse_and_buggy.road_closure('https://google.com'))
    end

    def test_road_is_closed_eh_for_winding_closed_road
      horse_and_buggy = HorseAndBuggy.new(0)
      assert(horse_and_buggy.road_closure('http://www.github.com/markymarkmcdonald/redirect-to-nonexistant-project'))
    end
  end
end
