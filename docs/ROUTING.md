# CraftX
> Craft Training for Busy Developers

## URL Structure

### Site
- /join
- /login
- /logout
- /@{username} (public)

### Content
- /learn
    - /{course}
    - /{course}/{lesson}

```
/learn/modern-php-development-for-craftcms
/learn/plugin-development-for-craftcms/understanding-routing
```

- /browse
    - /courses
    - /lessons
    - /reviews (Beyond MVP)
        - /plugins
        - /services
        - /websites
    - /interviews (Beyond MVP)
        - /designers
        - /developers
- /search
    - ?q=search
    - /results

### Dashboard
- /@{username} (protected)
    - /profile
    - /settings
    - /subscription

### Blog
- /blog
    - /{entry}
    - /search?q=search (Beyond MVP)
    - /categories (Beyond MVP)
    - /topics

### Shop (Beyond MVP)
- /shop
    - /shirts
    - /stickers
