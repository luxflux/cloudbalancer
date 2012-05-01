class CloudBalancer::LoadBalancer
  class ServiceNodes < Array

    include CloudBalancer::LoadBalancer::FindNameMixin

  end
end
