require 'sinatra/base'
require 'json'


class App < Sinatra::Base

  get '/issues/closed' do
    halt 200,  {'Content-Type' => 'text/html'}, issuesToHTML(getIssues('closed'))
  end

  get '/issues/open' do
    halt 200,  {'Content-Type' => 'text/html'}, issuesToHTML(getIssues('open'))
  end

  get '/issues/all' do
    halt 200,  {'Content-Type' => 'text/html'}, issuesToHTML(getIssues('all'))
  end

  def getIssues(scope='all')
    issues = $client.issues(ENV['REPO'], :state=>'all', :sort => 'created', :direction => 'asc')

    ret = []
    issues.each do |i|
      opened = i.created_at
      closed = i.closed_at
      if closed.nil?
        closed = ''
      else
        closed = closed.strftime('%d/%m/%Y')
      end

      milestone =  i.milestone

      if i.milestone?
        milestone = i.milestone.title
      else
        milestone = ""
      end

      labels = i.labels
      label= ''
      if !labels.nil?
        labels.each do |l|
          label = label  + l.name
          if !labels.last == l
            label = label + ','
          end
        end
      else
        label = ""
      end
      tmp = [milestone,label,i.number.to_s,opened.strftime('%d/%m/%Y'),closed]
      if (scope == 'closed' && i.state == 'closed') || (scope == 'open' && i.state == 'open') || (scope == 'all')
        ret << tmp
      end
    end
    return ret
  end

  def issuesToHTML(issues)
    ret = '<table>'
    issues.each do |i|
      ret = ret + '<tr><td>' + i[0] + '</td><td>' + i[1] +  '</td><td>' + i[2] + '</td><td>' + i[3] + '</td><td>' + i[4] + "</td></tr></br>"
    end
    return ret + '</table>'
  end

end


