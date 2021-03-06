# encoding: utf-8
module SimpleBot
  module Utils
    def dollar_to_real(query)
      exchange = open("http://finance.yahoo.com/d/quotes.csv?e=.csv&f=sl1d1t1&s=USDBRL=X").read.split(",")[1]
      amount = Float(query.gsub(",", ".")) rescue 1
      "R$ %.2f" % (amount.to_f * exchange.to_f)
    rescue Exception => error
      "Não consegui saber a cotação"
    end

    def agendatech
      events = JSON.parse(open("http://www.agendatech.com.br/rss/feed.json").read)
      events.select! do |event|
        event["evento"]["estado"] == "SP" && event["evento"]["nome"].match(/guru/i)
      end

      event = events.first["evento"]
      date = event["data"].match(/(?<year>[0-9]{4})-(?<month>[0-9]{2})-(?<day>[0-9]{2})/)
      time = event["descricao"].match(/(?<hours>[0-9]?[0-9]:[0-9][0-9])/)

      message = "O próximo evento do Guru-SP está cadastrado para #{date[:day]}/#{date[:month]}/#{date[:year]}"
      message << " às #{time[:hours]}" if time
    rescue
      "Nenhum evento do Guru-SP cadastrado no Agendatech"
    end
  end
end
