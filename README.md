
# Sequel Generate Slug

[![Gem Version](https://badge.fury.io/rb/sequel-generate-slug.svg)](https://badge.fury.io/rb/sequel-generate-slug)

Sequel Generate Slug is a plugin automatically generates a URL-friendly slug for your [Sequel](https://github.com/jeremyevans/sequel) model instances. By default, it uses the `title` column as the source and stores the generated `slug` in the slug column. It can also use an additional column to create unique slugs.

### Usage

```ruby
class MyModel < Sequel::Model
  plugin :generate_slug
end
```

### Configuration

You can customize the slug column, source column, and additional column:

```ruby
class MyModel < Sequel::Model
  plugin :generate_slug, column: :slug, source: :title, additional: :custom_identifier
end
```

Here we connect the plugin to the `Post` model, specify that we want to use the `slug` column to store the generated slugs, and also specify that the attribute `title` will be the source for generating the slug, and the `identifier` attribute will be used for additional uniqueness.

After connecting the plugin and creating a model record, you can get the generated slug by calling the `slug` method:

```ruby
post = Post.create(title: 'Hello World', identifier: 'abcdef')
post.slug # => 'hello-world'
```

If you create another record with the same attribute values for title and identifier, the slug will be appended with a unique number:

```ruby
post = Post.create(title: 'Hello World', identifier: 'abcdef')
post.slug # => 'hello-world-abcdef'
```

In case all the generated slugs are already taken, the plugin will generate a unique number for the slug:
    
```ruby
post = Post.create(title: 'Hello World', identifier: 'abcdef')
post.slug # => 'hello-world-abcdef-1'
```

If you update a post's title and it no longer conflicts with any other titles, the slug will be regenerated based on the new title:

```ruby
post.update(title: 'Hello World Again', identifier: 'abcdef')
post.slug # => 'hello-world-again'
```

#### Options:

The GenerateSlug plugin has the following options:

`column`: The name of the column in which the generated slugs will be stored. By default, the **slug** column is used.

`source`: The name of the attribute that will be used to generate the slug. By default, the **title** attribute is used.

`additional`: The name of the attribute that will be used for slug uniqueness. By default, the **identifier** column is used.

#### Testing:

The RSpec library is used to test the GenerateSlug plugin. To run the tests, you need to execute the command:

```bash
bundle exec rspec
```

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'sequel-generate-slug'
```

And then execute:

```bash
$ bundle install
```

## Contributing

We welcome and appreciate contributions from the community to help improve and expand our software. If you're interested in contributing, please follow these steps:

1. **Fork the repository**: Create a fork of the main repository by clicking the "Fork" button in the top-right corner of this page.

2. **Clone your fork**: Clone your fork to your local machine by running `git clone https://github.com/andrewzhuk/sequel-generate-slug.git`.

3. **Create a branch**: Before making any changes, create a new branch for your contribution by running `git checkout -b <branch_name>`.

4. **Make your changes**: Make the necessary changes or additions to the codebase. Please ensure that your changes are consistent with the overall coding style and structure of the project.

5. **Test your changes**: Before submitting your contribution, make sure to thoroughly test your changes to ensure that they do not introduce any new bugs or issues.

6. **Commit your changes**: Once your changes have been tested, commit them to your branch by running `git commit -m "A brief description of your changes"`.

7. **Push your changes**: Push your changes to your fork on GitHub by running `git push origin <branch_name>`.

8. **Create a pull request**: Finally, navigate to the main repository's "Pull Requests" tab, and click the "New Pull Request" button. Select your fork and branch as the source, and create a descriptive title and summary for your contribution. Click "Create Pull Request" to submit your changes for review.

## License

Sequel Generate Slug is released under the [MIT License](https://opensource.org/licenses/MIT).

This means that you are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the project's software without restriction, provided that the above copyright notice and this license notice appear in all copies.

Please note that the Sequel Generate Slug is provided "as is" and without warranty of any kind, express or implied. The project's contributors shall not be liable for any damages or liabilities arising from the use or inability to use the project's software. Use at your own risk.