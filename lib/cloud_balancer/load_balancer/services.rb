class CloudBalancer::LoadBalancer
  class Services < Array

    include CloudBalancer::LoadBalancer::FindNameMixin

  end
end
