MY_BLOG_URL = 'YOUR_BLOG_URL_THAT_IS_ASSOCIATED_WITH_YOUR_AKISMET_API_KEY'
AKISMET_KEY = 'YOUR_AKISMET_API_KEY'

# These are probably OK to leave as they are
AKISMET_COMMENT_CHECK_URL = "http://#{AKISMET_KEY}.rest.akismet.com/1.1/comment-check"
AKISMET_SPAM_REPORT_URL = "#{AKISMET_KEY}.rest.akismet.com/1.1/submit-spam"
AKISMET_HAM_REPORT_URL = "#{AKISMET_KEY}.rest.akismet.com/1.1/submit-ham"