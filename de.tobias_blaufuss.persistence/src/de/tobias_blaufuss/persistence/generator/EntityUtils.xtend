package de.tobias_blaufuss.persistence.generator

import de.tobias_blaufuss.persistence.persistence.Entity
import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.BackrefField

class EntityUtils {
	def getEntityFieldsWithCardinality(Entity entity, Cardinality cardinality){
		return entity.fields.filter(EntityField).filter[f | f.cardinality == cardinality]
	}
	
	def hasEntityFieldsOfCardinality(Entity entity, Cardinality cardinality){
		return entity.fields.filter(EntityField).exists[f | f.cardinality == cardinality]
	}
	
	def getBackrefFields(Entity entity){
		return entity.fields.filter(BackrefField)
	}
	
	def hasBackrefFields(Entity entity){
		return !getBackrefFields(entity).empty
	}
}