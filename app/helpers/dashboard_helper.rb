module DashboardHelper
  def GetImage(filename)
    unless filename.nil?
      case File.extname(filename).to_s().to_lf
        when ".docx",".doc"
          return "documentIcon.png"
        when ".jpg",".jpeg",".png",".bmp",".gif",".jfif",".exif",".tiff" , ".raw" , ".ppm" , ".pgm" , ".pbm" , ".pnm" , ".cgm" , ".svg" , ".pns" , ".jps"
          return "imageIcon.png"
        when ".pdf"
          return "pdfIcon.png"
        when ""
          return "folderIcon.png"
        else
          return "documentIcon.png"
      end
    else
      return "folderIcon.png"
    end
  end
  def GetImage_Large(filename)
    unless filename.nil?
      case File.extname(filename).to_s().to_lf
        when ".docx",".doc"
          return "fileIcon-Large.png"
        when ".jpg",".jpeg",".png",".bmp",".gif",".jfif",".exif",".tiff" , ".raw" , ".ppm" , ".pgm" , ".pbm" , ".pnm" , ".cgm" , ".svg" , ".pns" , ".jps"
          return "imageIcon-Large.png"
        when ".pdf"
          return "fileIcon-Large.png"
          #return "pdfIcon-Large.png"
        when ""
          return "folderIcon-Large.png"
        else
          return "fileIcon-Large.png"
      end
    else
      return "folderIcon-Large.png"
    end
  end
  def GetClass(filename)
    unless filename.nil?
      case File.extname(filename).to_s().to_lf
        when ".docx",".doc"
          return "wordFile"
        when ".jpg",".jpeg",".png",".bmp",".gif",".jfif",".exif",".tiff" , ".raw" , ".ppm" , ".pgm" , ".pbm" , ".pnm" , ".cgm" , ".svg" , ".pns" , ".jps"
          return "imageFile"
        when ".pdf"
          return "imageFile"
        when ""
          return "folderFile"
        else
          return "folderFile"
      end
    else
      return "folderFile"
    end
  end
  def distance_of_time_in_hours_and_minutes(from_time, to_time)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    dist = to_time - from_time
    minutes = (dist.abs / 60).round
    hours = minutes / 60
    days = hours / 24
    minutes = minutes - (hours * 60)
    hours = hours - (days * 24)
    words = dist <= 0 ? '' : '-'
    if days > 0
      words << "#{days} #{days > 1 ? 'days' : 'day' } and "
    else
      words = ''
    end
    words << "#{hours} #{hours > 1 ? 'hours' : 'hour' } and " if hours > 0
    words << "#{minutes} #{minutes == 1 ? 'minute' : 'minutes' }"
  end
end
