FactoryGirl.define do
  factory :match do
    date_time { FFaker::Time.datetime }
    identifier { FFaker::IdentificationBR.cnpj }
  end
end
