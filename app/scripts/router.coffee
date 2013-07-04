# Router.
define ["app", "modules/common", "modules/login", "modules/user", "modules/group", "modules/session"], (app, common, login, user, group, session) ->

  # Defining the application router, you can attach sub routers here.
  Router = Backbone.Router.extend
    routes:
      "": "index"
      "login": "login"
      "logout": "logout"
      "group/:gid": "group"
      "group/:gid/session/:sid": "session"

    index: ->
      layout = app.useLayout 'layouts/main'
      layout.setViews
        "#navbar": new common.Views.NavbarView()
        "#content": new user.Views.LayoutView
          views:
            "#details": new user.Views.GroupView()
      layout.render()

    login: ->
      layout = app.useLayout 'layouts/main'
      layout.setViews
        "#navbar": new common.Views.NavbarView()
        "#content": new login.Views.LoginView()
      layout.render()

    logout: ->
      common.logout()

    group: (gid)->
      CycleCollection = group.Models.CycleCollection.extend gid: gid
      collection = new CycleCollection()
      collection.fetch()
      layout = app.useLayout 'layouts/main'
      layout.setViews
        "#navbar": new common.Views.NavbarView()
        "#content": new group.Views.LayoutView
          views:
            "#sidebar": new group.Views.CycleView(collection: collection)
            "#details": new group.Views.SessionView(collection: new group.Models.SessionCollection([]))

      layout.render()

    session: (gid, sid)->
      SessionCollection = session.Models.TestCollection.extend
        gid: gid
        sid: sid
      collection = new SessionCollection()
      collection.fetch()

      layout = app.useLayout 'layouts/main'
      layout.setViews
        "#navbar": new common.Views.NavbarView()
        "#content": new session.Views.LayoutView
          views:
            # "#sidebar": new group.Views.CycleView(collection: collection)
            "#details": new session.Views.TestView(collection: collection)
            "#sidebar": new session.Views.SidebarView()

      layout.render()

  Router
