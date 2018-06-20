package de.tobias_blaufuss.persistence.generator

import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField

class EntityFieldUtils {
	def getBackrefField(EntityField field){
		val referencedEntity = field.entityReference
		val backrefFieldsOfEntityRef = referencedEntity.fields.filter(BackrefField)
		val foundBackrefField = backrefFieldsOfEntityRef.findFirst[bField | bField.backref == field]
		return foundBackrefField
	}
	
	def hasBackrefField(EntityField field){
		return getBackrefField(field) !== null
	}
	
	def getEntityName(EntityField field){
		return field.entityReference.name
	}
}