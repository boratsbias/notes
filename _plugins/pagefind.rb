# frozen_string_literal: true

Jekyll::Hooks.register :site, :post_write do |site|
  dest = site.dest
  Jekyll.logger.info "Pagefind:", "Indexing #{dest}..."
  unless system("npx", "--yes", "pagefind", "--site", dest)
    Jekyll.logger.warn "Pagefind:", "Indexing failed. Run: npx pagefind --site _site"
  end
end
