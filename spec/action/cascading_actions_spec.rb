module CascadingActions
  class OnboardUser < Enkel::Action
    def initialize(email:, organization_name:)
      @email = email
      @organization_name = organization_name
    end

    def call
      create_user = CreateUser.call!(email: @email)
      create_organization = CreateOrganization.call!(name: @organization_name)
      notify_admins =
        NotifyAdmins.call!(
          user: create_user.data,
          organization: create_organization.data[:organization]
        )

      respond user: create_user.data,
              organization: create_organization.data,
              notify_admins: notify_admins.data
    end
  end

  class CreateUser < Enkel::Action
    def initialize(email:)
      @email = email
    end

    def call
      if @email == "valid@gmail.com"
        respond email: @email
      else
        error email: "invalid email"
      end
    end
  end

  class CreateOrganization < Enkel::Action
    def initialize(name:)
      @name = name
    end

    def call
      if @name == "valid_name"
        respond name: @name
      else
        error name: "invalid name"
      end
    end
  end

  class NotifyAdmins < Enkel::Action
    def initialize(user:, organization:)
      @user = user
      @organization = organization
    end

    def call
      respond "Admins notified"
    end
  end
end

RSpec.describe CascadingActions::OnboardUser do
  context "when given valid params" do
    it "creates a user" do
      response =
        described_class.call!(
          email: "valid@gmail.com",
          organization_name: "valid_name"
        )

      expect(response.success?).to be(true)
      expect(response.status).to eq(:ok)
      expect(response.data).to eq(
        user: {
          email: "valid@gmail.com"
        },
        organization: {
          name: "valid_name"
        },
        message: "Admins notified"
      )
    end
  end
end
