class AddSiteDesc < ActiveRecord::Migration[5.2]
  def up
    Ad.create(body: %{
      <div class='site-desc'>Save links to best content you see online (videos, blogs, text, pdf, anything). You can use our Firefox add-on <a href='https://addons.mozilla.org/en-US/firefox/addon/save-link-to-xlinks/'>here</a> to easily add links.</div>
    })
  end

  def down
    Ad.unscoped.first.destroy
  end
end
