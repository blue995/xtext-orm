package de.tobias_blaufuss.persistence.generator

import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.PersistenceModel
import de.tobias_blaufuss.persistence.persistence.StringType

class PersistenceModelUtils {
	def Iterable<EntityField> gatherFieldsWithCardinality(PersistenceModel model, Cardinality cardinality) {
		val allFieldsWithCardinality = model.entities
			.map[e | e.fieldDeclarations]
			.flatten
			.map[fd | fd.field]
			.filter(EntityField)
			.filter [f |
				f.cardinality == cardinality
			]
		return allFieldsWithCardinality
	}
	
	def Integer resolveStringTypeCount(StringType stringType) {
		if (stringType.count <= 0) {
			return 50
		} else {
			return stringType.count
		}
	}
}