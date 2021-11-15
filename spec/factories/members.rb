FactoryBot.define do
  factory :member do
    factory :alan_smith do
      first_name { 'Alan' }
      last_name { 'Smith' }
      url { 'https://news.mit.edu/2019/answer-life-universe-and-everything-sum-three-cubes-mathematics-0910' }
    end

    factory :becky_smith do
      first_name { 'Becky' }
      last_name { 'Smith' }
      url { 'https://famous-teas-blog' }
      h1 { ['Famous teas around the world'] }
      h2 { ['Earl Grey', 'Herbal', 'Ginger Lemon'] }
      h3 { ['Kettles'] }
    end

    factory :bob_test do
      first_name { 'Bob' }
      last_name { 'Test' }
      url { 'https://the-big-bang-theory.com/rock-paper-scissors-lizard-spock/' }
    end

    factory :carol_test do
      first_name { 'Alan' }
      last_name { 'Test' }
      url { 'https://famous-teas' }
      h1 { ['Famous teas'] }
      h2 { ['Chamomile', 'Matcha', 'How to make the best tea in the world!'] }
      h3 { ['Why the Brits love their teas', 'Kettles are awesome'] }
    end
  end
end
