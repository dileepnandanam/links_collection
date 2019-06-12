{

  "manifest_version": 2,
  "name": "add_link",
  "version": "1.0",

  "description": "Adds current page url to xlinks.herokuapp.com",

  "content_scripts": [
    {
      "matches": ["*://*.mozilla.org/*"],
      "js": ["add_link.js", "jquery.js"]
    }
  ]

}