# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
set :stage, :production

role :app, %w{huyang@local.dev}
role :web, %w{huyang@local.dev}
role :db,  %w{huyang@local.dev}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server 'local.dev', user: 'huyang', roles: %w{web app db}#, my_property: :my_value


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
  forward_agent: false,
  #auth_methods: %w(password),
  port: 2222
}
#
# And/or per server (overrides global)
# ------------------------------------
server 'local.dev',
   user: 'huyang',
   roles: %w{web app db},
   ssh_options: {
     user: 'huyang', # overrides user setting above
     keys: %w(/Users/huyang/.ssh/id_rsa.pub),
     forward_agent: false,
     auth_methods: %w(publickey),
     #password: '\\' #my password is \
   }
