class Caesar
  def caesar_cipher(message, shift)
    dictionary = "abcdefghijklmnopqrstuvwxyz"
    dictionary_upper = dictionary.upcase
    shifted_dictionary = dictionary[shift..25] + dictionary[0..shift-1]
    shifted_upper = shifted_dictionary.upcase
    encrytped_message = ""

    message.each_char do |char|
        if !dictionary.index(char)
        encrytped_message += char
        elsif
        shifted_index = dictionary.index(char)
        encrypted_letter = shifted_dictionary[shifted_index]
        encrytped_message += encrypted_letter
        end
    end

    encrytped_message_upper = ""
    encrytped_message.each_char do |char|
        if !dictionary_upper.index(char)
        encrytped_message_upper += char
        elsif
        shifted_index = dictionary_upper.index(char)
        encrypted_letter = shifted_upper[shifted_index]
        encrytped_message_upper += encrypted_letter
        end
    end

    return encrytped_message_upper
    
  end
end
