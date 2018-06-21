package de.tobias_blaufuss.persistence.generator.util

import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.Cardinality

class EntityFieldUtils {
	extension EntityUtils = new EntityUtils
	extension FieldUtils = new FieldUtils
	
	def BackrefField getBackrefField(EntityField field){
		val referencedEntity = field.entityReference
		referencedEntity.backrefFields
		val backrefFieldsOfEntityRef = referencedEntity.backrefFields
		val foundBackrefField = backrefFieldsOfEntityRef.findFirst[bField | bField.backref == field]
		return foundBackrefField
	}
	
	def Boolean hasBackrefField(EntityField field){
		return getBackrefField(field) !== null
	}
	
	def String getEntityName(EntityField field){
		return field.entityReference.name
	}
	
	def String getTypeName(BackrefField backrefField){
		return backrefField.backref.entity.name
	}
	
	def Cardinality getCardinality(BackrefField backrefField){
		switch backrefField.backref.cardinality {
			case MANY_TO_MANY: {
				return Cardinality.MANY_TO_MANY
			}
			case MANY_TO_ONE: {
				return Cardinality.ONE_TO_MANY
			}
			case ONE_TO_MANY: {
				return Cardinality.MANY_TO_ONE
			}
			case ONE_TO_ONE: {
				return Cardinality.ONE_TO_ONE
			}
		}
	}
	
	def Boolean isCollection(Cardinality cardinality){
		return cardinality == Cardinality.ONE_TO_MANY || cardinality == Cardinality.MANY_TO_MANY
	}
}