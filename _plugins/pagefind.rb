# frozen_string_literal: true

Jekyll::Hooks.register :site, :post_write do |site|
  dest = site.dest
  root = site.source
  local = File.expand_path("node_modules/.bin/pagefind", root)

  cmd = if File.executable?(local)
          [local]
        else
          Jekyll.logger.warn "Pagefind:",
                             "Local pagefind not found. Run: npm install"
          ["npx", "--yes", "pagefind"]
        end

  Jekyll.logger.info "Pagefind:", "Indexing #{dest}..."
  success = system(*cmd, "--site", dest)

  next if success

  Jekyll.logger.error "Pagefind:", "Indexing failed."
  Jekyll.logger.error "Pagefind:", "Fix: npm install && npm run build:search"
  raise "Pagefind indexing failed. Search will not work until the index is rebuilt."
end
