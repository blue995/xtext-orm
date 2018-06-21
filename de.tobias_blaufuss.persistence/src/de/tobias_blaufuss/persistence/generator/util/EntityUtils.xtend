package de.tobias_blaufuss.persistence.generator.util

import de.tobias_blaufuss.persistence.persistence.Entity
import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.Field
import de.tobias_blaufuss.persistence.persistence.PropertyField

class EntityUtils {
	def getEntityFieldsWithCardinality(Entity entity, Cardinality cardinality){
		return getFields(EntityField, entity).filter[f | f.cardinality == cardinality]
	}
	
	def hasEntityFieldsOfCardinality(Entity entity, Cardinality cardinality){
		return getFields(EntityField, entity).filter(EntityField).exists[f | f.cardinality == cardinality]
	}
	
	def getBackrefFields(Entity entity){
		return getFields(BackrefField, entity)
	}
	
	def hasBackrefFields(Entity entity){
		return !getBackrefFields(entity).empty
	}
	
	def getPropertyFields(Entity entity){
		return getFields(PropertyField, entity)
	}
	
	def hasPropertyFields(Entity entity){
		return !getPropertyFields(entity).empty
	}
	
	private static def <T extends Field> getFields(Class<T> fieldClass, Entity entity){
		return entity.fieldDeclarations.map[fd | fd.field].filter(fieldClass)
	}
}