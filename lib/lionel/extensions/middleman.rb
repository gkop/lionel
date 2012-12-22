module Lionel
  module Extensions
    module Middleman
      class Options < Struct.new(:engines_with_images); end

      class << self
        def registered(app, &block)
          options = Options.new([])
          yield options if block_given?
          # Let's run our images/ through sprockets just as we do js and css,
          # so we can serve images packaged in engines

          # Inspired by https://github.com/Vasfed/middleman/commit/c9b4edcc0a3fb9fd4da43af78cedd50351479205
          # This may be CRUFT if similar behavior is implemented by middleman
          # itself
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

          app.after_configuration do
            ::Middleman.rubygems_latest_specs.select { |g|
              options.engines_with_images.include?(g.name)
            }.map(&:full_gem_path).each do |root_path|
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

          app.build_config do
            # Copy over engined images to build/images/
            FileUtils.mkdir_p "#{root}/build/images"
            ::Middleman.rubygems_latest_specs.select { |g|
              options.engines_with_images.include?(g.name)
            }.map(&:full_gem_path).each do |root_path|
              try_paths.map {|p| File.join(root_path, p) }.
                select {|p| File.directory?(p) }.
                each do |path|
                  FileUtils.cp_r Dir[path+"/*"], "#{root}/build/images"
              end
            end
          end

          # ugly hack around current_path being nil when executing path helpers
          if defined? ::Middleman::Extensions::RelativeAssets
            ::Middleman::Extensions::RelativeAssets::InstanceMethods.module_eval do
              alias_method :old_asset_url, :asset_url

              def asset_url(path, prefix="")
                old_asset_url(path, prefix)
              rescue Exception => ex
                "#{prefix}/#{path}"
              end
            end
          end
        end

        alias :included :registered
      end
    end
  end
end

::Middleman::Extensions.register(:lionel, Lionel::Extensions::Middleman)
