class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  attr_accessible :email, :name, :provider, :uid, :oauth_token, :oauth_expires_at, :password

  has_many :results

  def find_classmates(search)
  	  a = Mechanize.new 
      a.follow_meta_refresh = true

      email = 'aramesh@wharton.upenn.edu'
      password = 'AbhiR2212'

      url = "https://spike.wharton.upenn.edu/index.cfm?login=true"

      params = 'username=aramesh&password=AbhiR2212&submit=Log+in'

      headers = {
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Encoding' => 'gzip,deflate,sdch', 
        'Accept-Language' => 'en-US,en;q=0.8',
        'Cache-Control' => 'no-cache',
        'Connection' => 'keep-alive',
        'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
        'Cookie' => '__unam=d7bc9e4-13fa07c3583-450bc882-1; CFID=80058280; CFTOKEN=32526324; BIGipServerpl_web_wildcard=3892383916.0.0000; QUAKERNETSKINVERSION=spike; __utma=247612227.1069897743.1376610521.1376610521.1376614238.2; __utmc=247612227; __utmz=247612227.1376614238.2.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); JSESSIONID=f030ee63971926c4a2602ad6bbf4681a93c6; __utma=154478970.204545490.1373125560.1376610026.1376680194.4; __utmb=154478970.11.10.1376680194; __utmc=154478970; __utmz=154478970.1376610026.3.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __atuvc=58%7C33',
        'Host' => 'spike.wharton.upenn.edu',
        'Origin' => 'https://spike.wharton.upenn.edu',
        'Pragma' => 'no-cache',
        'Referer' => 'https://spike.wharton.upenn.edu/index.cfm',
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.155 Safari/537.22',
      }

      a.post(url, params, headers)

      section_id = search

      url_2 = "https://spike.wharton.upenn.edu/courses/index.cfm?method=class_list&term=2013C&section_id=" + section_id

      headers_2 = {
        'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
        'Accept-Encoding' => 'gzip,deflate,sdch', 
        'Accept-Language' => 'en-US,en;q=0.8',
        'Cache-Control' => 'no-cache',
        'Connection' => 'keep-alive',
        'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
        'Cookie' => '__unam=d7bc9e4-13fa07c3583-450bc882-1; CFID=80058280; CFTOKEN=32526324; BIGipServerpl_web_wildcard=3892383916.0.0000; QUAKERNETSKINVERSION=spike; __utma=247612227.1069897743.1376610521.1376610521.1376614238.2; __utmc=247612227; __utmz=247612227.1376614238.2.2.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); JSESSIONID=f030ee63971926c4a2602ad6bbf4681a93c6; __utma=154478970.204545490.1373125560.1376610026.1376680194.4; __utmb=154478970.11.10.1376680194; __utmc=154478970; __utmz=154478970.1376610026.3.3.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __atuvc=58%7C33',
        'Host' => 'spike.wharton.upenn.edu',
        'Origin' => 'https://spike.wharton.upenn.edu',
        'Pragma' => 'no-cache',
        'Referer' => 'https://spike.wharton.upenn.edu/index.cfm',
        'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.155 Safari/537.22',
      }

      a.get(url_2, headers_2)

      a.page.parser.css("div.box.profileresult").each do |c|
        Result.create(user_id: self.id, name: c.css("p.single a").text, image_url: c.css("img.avatar.medium")[0]["src"], query: search)
      end
  end


end
