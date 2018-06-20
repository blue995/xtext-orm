package de.tobias_blaufuss.persistence.generator

import de.tobias_blaufuss.persistence.persistence.PersistenceModel
import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.StringType

class PersistenceModelUtils {
	def gatherFieldsWithCardinality(PersistenceModel model, Cardinality cardinality) {
		val allFieldsWithCardinality = model.entities.map[e|e.fields].flatten.filter(EntityField).filter [f |
			f.cardinality == cardinality
		]
		return allFieldsWithCardinality
	}
	
	def resolveStringTypeCount(StringType stringType) {
		if (stringType.count <= 0) {
			return 50
		} else {
			return stringType.count
		}
	}
}