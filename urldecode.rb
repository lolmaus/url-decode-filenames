# Скрипт копирует все файлы и папки из одного места в другое (указываются внизу), при этом переименовывает их, заменяя urlencode на человеческий

require 'find'
require 'fileutils'
require 'iconv'
require 'cgi'

# Метод конвертации строки. Руби под виндой чудит с cp1251/utf8.
def url_dec(str)
  Iconv.conv("CP1251", "UTF-8", CGI::unescape(str))
end

# Собственно скрипт
def copy_tree(orig_dir, new_dir)

  # Перебираем все файлы и папки в указанной директории, оперируя с полным именем каждого
  Find.find(orig_dir) do |path|

    # Получаем путь относительно исходной папки
    relative_parentname = path.gsub(orig_dir, '').gsub(File.basename(path),'')

    # Игнорируем саму исходную папку
    next if not relative_parentname

    # Декодируем относительный путь и имя
    fixed_relative_parentname = url_dec(relative_parentname)
    fixed_basename = url_dec(File.basename(path))

    # Если имеем дело с папкой, создаем её исправленную копию
    if File.directory?(path)
      FileUtils.mkdir( new_dir + fixed_relative_parentname + fixed_basename )
    # Если с файлом — копируем его, исправляя имя
    elsif File.file?(path)
      FileUtils.copy_file(path, new_dir + fixed_relative_parentname + fixed_basename )
    end

  end
end

# Запускаем
copy_tree('W:\var\vhosts\wiki.alfamb.ru\data\pages', 'C:\pages')
