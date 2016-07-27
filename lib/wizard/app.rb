def say_custom(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "\033[0m" + "  #{text}" end
	def say_loud(tag, text); say "\033[1m\033[36m" + tag.to_s.rjust(10) + "  #{text}" + "\033[0m" end
	def say_recipe(name); say "\033[1m\033[36m" + "recipe".rjust(10) + "\033[0m" + "  Running #{name} recipe..." end
	def say_wizard(text); say_custom('composer', text) end

	def ask_wizard(question)
	  ask "\033[1m\033[36m" + ("option").rjust(10) + "\033[1m\033[36m" + "  #{question}\033[0m"
	end

	def whisper_ask_wizard(question)
	  ask "\033[1m\033[36m" + ("choose").rjust(10) + "\033[0m" + "  #{question}"
	end

	def yes_wizard?(question)
	  answer = ask_wizard(question + " \033[33m(y/n)\033[0m")
	  case answer.downcase
	    when "yes", "y"
	      true
	    when "no", "n"
	      false
	    else
	      yes_wizard?(question)
	  end
	end

	def no_wizard?(question); !yes_wizard?(question) end

	def multiple_choice(question, choices)
	  say_custom('option', "\033[1m\033[36m" + "#{question}\033[0m")
	  values = {}
	  choices.each_with_index do |choice,i|
	    values[(i + 1).to_s] = choice[1]
	    say_custom( (i + 1).to_s + ')', choice[0] )
	  end
	  answer = whisper_ask_wizard("Enter your selection:") while !values.keys.include?(answer)
	  values[answer]
	end
say_wizard("\033[1m\033[36m" + "" + "\033[0m")

say_wizard("\033[1m\033[36m" + ' _____       _ _' + "\033[0m")
say_wizard("\033[1m\033[36m" + "|  __ \\     \(_\) |       /\\" + "\033[0m")
say_wizard("\033[1m\033[36m" + "| |__) |__ _ _| |___   /  \\   _ __  _ __  ___" + "\033[0m")
say_wizard("\033[1m\033[36m" + "|  _  /\/ _` | | / __| / /\\ \\ | \'_ \| \'_ \\/ __|" + "\033[0m")
say_wizard("\033[1m\033[36m" + "| | \\ \\ (_| | | \\__ \\/ ____ \\| |_) | |_) \\__ \\" + "\033[0m")
say_wizard("\033[1m\033[36m" + "|_|  \\_\\__,_|_|_|___/_/    \\_\\ .__/| .__/|___/" + "\033[0m")
say_wizard("\033[1m\033[36m" + "                             \| \|   \| \|" + "\033[0m")
say_wizard("\033[1m\033[36m" + "                             \| \|   \| \|" + "\033[0m")
say_wizard("\033[1m\033[36m" + '' + "\033[0m")
say_wizard("\033[1m\033[36m" + "If you like Rails Composer, will you support it?" + "\033[0m")
say_wizard("\033[1m\033[36m" + "You can help by purchasing our tutorials." + "\033[0m")
say_wizard("Need help? Ask on Stack Overflow with the tag \'railsapps.\'")
say_wizard("Your new application will contain diagnostics in its README file.")