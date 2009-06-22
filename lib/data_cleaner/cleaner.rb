module DataCleaner
  class Cleaner
    MAPPING = {
      :name => Faker::Name,
      :first_name => Faker::Name,
      :last_name => Faker::Name,
      :name_prefix => [Faker::Name, :prefix],
      :name_suffix => [Faker::Name, :suffix],
      
      :phone_number => Faker::PhoneNumber,
      
      :city => Faker::Address,
      :city_prefix => Faker::Address,
      :city_suffix => Faker::Address,
      :secondary_address => Faker::Address,
      :street_address => Faker::Address,
      :street_name => Faker::Address,
      :street_suffix => Faker::Address,
      :uk_country => Faker::Address,
      :uk_county => Faker::Address,
      :uk_postcode => Faker::Address,
      :us_state => Faker::Address,
      :us_state_abbr => Faker::Address,
      :zip_code => Faker::Address,
      
      :domain_name => Faker::Internet,
      :domain_suffix => Faker::Internet,
      :domain_word => Faker::Internet,
      :email => Faker::Internet,
      :free_email => Faker::Internet,
      :user_name => Faker::Internet,
      
      :bs => Faker::Company,
      :catch_phrase => Faker::Company,
      :company_name => [Faker::Company, :name],
      :company_suffix => [Faker::Company, :suffix],
      
      :paragraph => Faker::Lorem,
      :paragraphs => Faker::Lorem,
      :sentence => Faker::Lorem,
      :sentences => Faker::Lorem,
      :words => Faker::Lorem,
    }
    
    def clean(object)
      clean!(object.dup)
    end
    
    def clean!(object)
      format = Formats.formats[object.class.name]
      
      format.attributes.each do |pair|
        attribute, arguments = pair
        
        object.send(:"#{attribute}=", replacement(arguments, object))
      end
      object
    end
    
    private
    def replacement(args, object)
      args = args.dup
      first = args.shift
      
      case first
      when String
        first
      when Symbol
        args.map! {|arg| if arg.is_a?(Proc) then arg.call(object) end || arg}
        data(first, *args)
      when Array
        first.map do |e|
          e = [e] unless e.is_a?(Array)
          replacement(e, object)
        end.join
      when Proc
        first.call(object)
      end
    end
    
    def data(type, *args)
      result = MAPPING[type]
      
      klass, method = result
      method ||= type
      
      klass.send(method, *args)
    end
    
  end
end