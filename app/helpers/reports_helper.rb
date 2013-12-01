module ReportsHelper
	def getFamilyKey(familyKeys, numberFamily, dad, mom)
		if dad == nil && mom == nil
			return familyKeys, numberFamily, -1
		end

		if familyKeys.key?(dad)
			if mom != nil
				familyKeys[mom] = familyKeys[dad]
			end
			return familyKeys, numberFamily, familyKeys[dad]
		end
		if familyKeys.key?(mom)
			if dad != nil
				familyKeys[dad] = familyKeys[mom]
			end
			return familyKeys, numberFamily, familyKeys[mom]
		end
			
		if dad == nil
			familyKeys[mom] = numberFamily
			numberFamily += 1
			return familyKeys, numberFamily, familyKeys[mom]
		elsif mom == nil
			familyKeys[dad] = numberFamily
			numberFamily += 1
			return familyKeys, numberFamily, familyKeys[dad]
		else
			familyKeys[dad] = numberFamily
			familyKeys[mom] = numberFamily
			numberFamily += 1
			return familyKeys, numberFamily, familyKeys[dad]
		end
	end

	def normalizeYear(date)
		return Date.strptime("{ %d, %d, %d }" % [2000, date.month, date.day], "{ %Y, %m, %d }")
	end
end