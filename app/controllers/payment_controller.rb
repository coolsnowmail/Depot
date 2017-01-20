class PaymentController < ApplicationController
  skip_before_action :authorize
  def call
    require 'rest-client'
    require "net/https"
    require 'yandex_money/api'
    require 'open-uri'
    require 'json'
    require 'pp'
    require "httparty"
    require "recursive-open-struct"
    inst_id = YandexMoney::ExternalPayment.get_instance_id("A4752F68455E7E705FF566BD0E3B6FE6DA4AAFEFA324A5ADC8DB8F6665D8325A")
    instance_id = inst_id.instance_id
    api = YandexMoney::ExternalPayment.new(instance_id)
    response = api.request_external_payment({
      pattern_id: "p2p",
      to: "410014868634611",
      amount_due: "10",
      message: "test"
    })
    if response.status == "success"
      request_id = response.request_id
    else
      # throw exception
    end
    api = YandexMoney::ExternalPayment.new(instance_id)
    result = api.process_external_payment({
      request_id: request_id,
      ext_auth_success_uri: "http://localhost:3000",
      ext_auth_fail_uri: "http://example.com/fail"
    })
    # RestClient.post res.acs_uri, res.acs_params.to_json
    # Тут нужно отправить пост запрос на адрес result.acs_uri с данными result.acs_params
  end
end