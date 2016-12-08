Herudio
=======
Herudio is a Ruby on Rails application that allows users to plan and hold
courses with many different lessons other users can subscribe to.

Getting Started
---------------
To install the application, clone the repo:

```
$ git clone git://github.com/alessandro1997/herudio.git
```

Then copy and edit the configuration files:

```
$ cp config/database.example.yml config/database.yml
$ cp config/application.example.yml config/application.yml
```

When you're done, set up the database:

```
$ rake db:setup
```

You're all set! You can now start the application with Foreman:

```
$ foreman start
```

Documentation and Support
-------------------------
All documentation is contained in the [GitHub repository](https://github.com/alessandro1997/herudio).
If you need support, you can ping me on Twitter ([@alessandro1997](https://twitter.com/alessandro1997)).

Issues
------
Report any issues on [GitHub](https://github.com/alessandro1997/herudio).

Contributing
------------
1. Fork it (https://github.com/alessandro1997/herudio/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Credits
-------
Herudio is developed and maintained by [Alessandro Desantis](https://github.com/alessandro1997).

License
-------
Herudio is released under the MIT license.
