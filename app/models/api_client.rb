# encoding: utf-8

class ApiClient

  def self.post(url, options = {})
    response = nil
    3.times do |i|
      response = begin
        RestClient.post(url, options)
      rescue => e
        puts "{失败}#{i}连接异常：#{url} #{options} #{e.to_s}"
        nil
      end
      break if response
      sleep 1
    end

    if response.nil?
      puts "{失败} ApiClient.post response返回nil：#{url} #{options}"
      return nil
    end
    full_url = [url, URI.encode_www_form(options)].join("?")
    ApiClient::Result.new(response, full_url)
  end

  def self.get(url, options = {})
    response = nil
    3.times do |i|
      response = begin
        RestClient.get(url, {params: options})
      rescue => e
        puts "{失败}#{i}连接异常：#{url} #{options} #{e.to_s}"
        nil
      end
      break if response
      sleep 1
    end
    if response.nil?
      puts "{失败} ApiClient.get response返回nil：#{url} #{options}"
      return nil
    end
    full_url = [url, URI.encode_www_form(options)].join("?")
    ApiClient::Result.new(response, full_url)
  end

  class Result

    attr_accessor :success, :msg, :url, :body, :res

    def initialize(response, url = '')
      puts "【#{Time.now.to_s}】 访问API接口：#{url}"
      if !response.nil? && response.respond_to?(:body) && response.body != ""
        begin
          json = JSON.parse response.body
          result = json.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
          self.msg = result[:msg] || result[:desc]
          self.success = result[:success]
          self.body = result # 返回信息hash
        rescue Exception => e
          self.success = false
        end
        self.url = url
      else
        self.success = false
        puts "{失败}ApiClient::Result.new"
      end
      self.res = response
      puts "返回：#{response.force_encoding('UTF-8')}"
    end

    # 判断接口返回是否成功
    def success?
      success.to_s == 'true'
    end

    # 获取返回信息body的所有key
    def get(key)
      body[key.to_sym]
    end

    # 返回信息的结果内容
    def rs
      body[:result]
    end

    # 取返回的结果key
    def result_key(key)
      body[:result][key.to_s]
    end
  end

end