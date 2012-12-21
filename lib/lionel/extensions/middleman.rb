module Lionel
  module Extensions
    module Middleman
      class << self
        def registered(app)
          # Let's run our images/ through sprockets just as we do js and css,
          # so we can serve images packaged in engines

          # Inspired by https://github.com/Vasfed/middleman/commit/c9b4edcc0a3fb9fd4da43af78cedd50351479205
          # This may be CRUFT if similar behavior is implemented by middleman
          # itself

          app.after_configuration do
            try_paths = [
              %w{ assets },
              %w{ app },
              %w{ app assets },
              %w{ vendor },
              %w{ vendor assets },
              %w{ lib },
              %w{ lib assets }
            ].inject([]) do |sum, v|
              sum + [File.join(v, 'images')]
            end

            ([root] + ::Middleman.rubygems_latest_specs.map(&:full_gem_path)).each do |root_path|
              try_paths.map {|p| File.join(root_path, p) }.
                select {|p| File.directory?(p) }.
                each {|path| sprockets.append_path(path) }
            end

            # Add our app images to sprockets, too
            sprockets.append_path("#{root}/#{source}/#{images_dir}")

            # Intercept requests to /images and pass to sprockets
            our_sprockets = sprockets
            map("/#{images_dir}")  { run our_sprockets }
          end
        end
        alias :included :registered
      end
    end
  end
end

::Middleman::Extensions.register(:lionel, Lionel::Extensions::Middleman)
