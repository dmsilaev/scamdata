namespace :db do
    def collections
    [
      { model: "Drug", table: "drugs" },
      { model: "Ingredient", table: "ingredients" },
      { model: "User", table: "users" }
    ]
    end
    task :export => :environment do
        collections.each do |collection|
          table = collection[:table]
          model = collection[:model]
          dir = "db/seed/" + Rails.env
          filename = dir + "/" + table + ".json"
          Dir.mkdir dir unless (Dir.exists? dir)
          Rake::Task["db:model:export"].execute({model: model, filename: filename})
        end
    end
    task :import => :environment do
        collections.each do |collection|
          table = collection[:table]
          model = collection[:model]
          dir = "db/seed/" + Rails.env
          filename = dir + "/" + table + ".json"
          Rake::Task["db:model:import"].execute({model: model, filename: filename})
        end
    end
end
