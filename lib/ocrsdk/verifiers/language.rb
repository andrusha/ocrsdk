module OCRSDK::Verifiers::Language
  # http://ocrsdk.com/documentation/specifications/recognition-languages/
  LANGUAGES = [:afrikaans, :albanian, :aymara, :azeri_latin, :basque, :bemba, 
    :blackfoot, :breton, :bugotu, :bulgarian, :buryat, :chamorro, :corsican,
    :crimean_tatar, :croatian, :crow, :czech, :dutch, :dutch_belgian, :english,
    :eskimo_latin, :esperanto, :estonian, :evenki, :faeroese, :fijian, :finnish,
    :french, :frisian, :gaelic_scottish, :gagauz, :galician, :ganda, :german,
    :german_law, :german_luxembourg, :german_medical, :german_new_spelling_law,
    :greek, :hani, :hausa, :hebrew, :hungarian, :icelandic, :interlingua, :italian,
    :japanese, :kabardian, :kasub, :kawa, :kikuyu, :kirgiz, :kongo, :korean_hangul,
    :koryak, :kpelle, :lak, :lappish, :latvian, :lezgin, :macedonian, :malay, :malinke, 
    :maltese, :mansi, :maori, :mari, :maya, :miao, :minankabaw, :mohawk, :nenets, :nogay, 
    :norwegian_bokmal, :norwegian_nynorsk, :nyanja, :occidental, :old_english, :old_french, 
    :old_german, :papiamento, :pidgin_english, :polish, :portuguese_brazilian, 
    :portuguese_standard, :provencal, :quechua, :romanian, :romanian_moldavia, :romany, 
    :rundi, :russian, :samoan, :selkup, :serbian_cyrillic, :shona, :sioux, :slovenian, 
    :somali, :spanish, :sunda, :tabassaran, :tagalog, :tahitian, :tajik, :tatar, :tinpo, 
    :tun, :turkish, :uighur_cyrillic, :ukrainian, :uzbek_cyrillic, :visayan].freeze

  def language_to_s(language)
    language.to_s.camelize
  end

  def language_to_sym(language)
    language.underscore.to_sym
  end

  def supported_language?(language)
    language = language_to_sym language  if language.kind_of? String

    LANGUAGES.include? language
  end

  def languages_to_s(languages)
    languages = languages.map(&method(:language_to_s))
    
    unless languages.map(&method(:supported_language?)).all?
      raise OCRSDK::UnsupportedLanguage
    else
      languages
    end
  end
end
