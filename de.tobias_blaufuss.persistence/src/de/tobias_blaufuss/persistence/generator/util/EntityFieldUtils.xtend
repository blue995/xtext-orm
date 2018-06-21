package de.tobias_blaufuss.persistence.generator.util

import com.google.inject.Inject
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField

class EntityFieldUtils {
	@Inject extension EntityUtils
	
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
}