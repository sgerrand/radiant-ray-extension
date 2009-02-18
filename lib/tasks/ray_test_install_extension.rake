namespace :ray do
  namespace :test do
    task :install do
      test_install_extension
    end
  end
end

def test_install_extension
  extensions = [
    "page-group-permissions",
    "admin_breadcrumbs",
    "admin_tree_structure",
    "aggregation",
    "application_theme",
    "audio_player",
    "banner-rotator",
    "blog",
    "blogtags",
    "breadcrumb-list",
    "browser",
    "can-haz-error",
    "comments",
    "compress-css-filter",
    "concurrent_draft",
    "conditional-tags",
    "copy-move",
    "dashboard",
    "database_form",
    "dav",
    "default-page-parts",
    "directory",
    "drafts",
    "dynamic-grouping",
    "dynamic-image",
    "email-page",
    "enkodertags",
    "event-calendar",
    "exception-notification",
    "extensions",
    "fast_snippet",
    "featured_pages",
    "file-browser",
    "file-system",
    "file-system-mirror",
    "file_based_layout",
    "find_fu",
    "first-reorder",
    "flash_content",
    "flickrtags",
    "fragment-cacher",
    "gmaps",
    "gorilla-blog",
    "greedy-page",
    "header_authorize",
    "help",
    "help_inline",
    "help_use_cases",
    "image-rotator",
    "import-export",
    "import-mephisto",
    "index-page",
    "iphone",
    "jargon",
    "jump-page",
    "language-switch",
    "language_redirect",
    "leads",
    "legacy_path_handler",
    "link-roll",
    "linksmanager",
    "location",
    "mail-to",
    "mailer",
    "markdown",
    "metaweblog",
    "movies",
    "multi-site",
    "multi-site-hacks",
    "navigation_tags",
    "nested-layouts",
    "news",
    "page-attachments",
    "page-edit-dates",
    "page-event",
    "page-preview",
    "page_attachments_xsendfile",
    "page_group_rbac_migrator",
    "page_list_view",
    "page_meta",
    "page_preview",
    "page_redirect",
    "page_review_process",
    "page_versioning",
    "paginate",
    "paperclipped",
    "parameterized-snippets",
    "portfolio",
    "quiz",
    "ratings",
    "rbac_base",
    "rbac_page_edit",
    "rbac_snippets",
    "redcloth4",
    "redirecting-fnf-page",
    "reg-exp-urls",
    "related-content",
    "reorder",
    "rerender_text",
    "rss-feed",
    "sass-filter",
    "scheduler",
    "search",
    "search_multi_site",
    "sectionalize",
    "seo_help",
    "settings",
    "share-layouts",
    "shopping-trike",
    "sibling-tags",
    "simple-password",
    "simple-product-manager",
    "site_watcher",
    "smer",
    "snippet-trees",
    "sns",
    "sns-minifier",
    "sns-sass-filter",
    "sns_file_system",
    "sound-manager",
    "spreedly",
    "subscriber-lists",
    "summarize",
    "super-export",
    "tags",
    "tags-too",
    "tags_multi_site",
    "templates",
    "textile-auto-fragment-ids",
    "textile-toolbar",
    "textile_editor",
    "thirty-boxes",
    "top-level-page",
    "translator",
    "trike-tags",
    "twitter",
    "upcoming-events",
    "upload-manager",
    "user_home",
    "utility-tags",
    "vapor",
    "variables",
    "wmd-filter",
    "wordpress_link_saver",
    "invisible_pages",
    "change_author",
    "code_ray",
    "categories",
    "fckeditor",
    "atom-import",
    "polls",
    "flickr_thumbnails",
    "wrappits"
  ]
  extensions.each do |extension|
    begin
      sh "rake ray:extension:install name=#{extension} --trace"
    rescue Exception => error
      puts "FAILED!\n#{error}"
      exit
    end
  end
end