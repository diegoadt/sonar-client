# encoding: utf-8

module Sonar
  module UserGroup
    class ReservedGroupName < StandardError
      def initialize(name)
        msg = "Name '#{name}' is reserved and cannot be used."
        super(msg)
      end
    end

    CREATE_USERGROUP_ENDPOINT = "/api/user_groups/create"
    RM_USERGROUP_PERMISSION_ENDPOINT = "/api/permissions/remove_group"

    RESERVED_NAMES = %w(anyone)

    # Validates user and pass authentication
    # @param name [String] Name of group
    # @param description [String] optional
    # @return [Hashie::Mash] with attribute group -> <Hashie::Mash id="00" membersCount=0 name="name">
    def create_usergroup(name:, description: nil)
      fail ReservedGroupName, name if RESERVED_NAMES.include? name

      options = basic_authenticated_options
      options[:name] = name
      options[:description] = description unless description.nil?

      post(CREATE_USERGROUP_ENDPOINT, options)
    end

    ##
    # Remove a permission from a group
    #
    # @param permission [String]
    # => Possible values for global permissions: admin, profileadmin, gateadmin, shareDashboard, scan, provisioning
    # => Possible values for project permissions user, admin, issueadmin, codeviewer, scan
    #
    # @param group_name [String]
    # => Group name or 'anyone' (case insensitive)
    # => Example value: sonar-administrators
    #
    # @param group_id [String]
    # => Group id
    # => Example value: 42
    #
    # @param project_key [String]
    # => Project key
    # => Example value: my_project
    #
    # @param project_id [String]
    # => Project id
    # => Example value: ce4c03d6-430f-40a9-b777-ad877c00aa4d
    #
    # @return [String] ""
    def remove_usergroup_permission(permission:, group_name: nil, group_id: nil, project_key: nil, project_id: nil)
      options = basic_authenticated_options
      options[:permission] = permission
      options[:groupName] = group_name unless group_name.nil?
      options[:groupId] = group_id unless group_id.nil?
      options[:projectKey] = project_key unless project_key.nil?
      options[:projectId] = project_id unless project_id.nil?

      post(RM_USERGROUP_PERMISSION_ENDPOINT, options)
    end
  end
end
