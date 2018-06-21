package de.tobias_blaufuss.persistence.generator.python.sqlalchemy

import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.Entity
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.generator.util.FieldUtils

class ManyToManyMetadata {
	private static FieldUtils fu = new FieldUtils
	
	Entity destination
	Entity source
	new(EntityField field){
		if(field.cardinality != Cardinality.MANY_TO_MANY){
			throw new IllegalArgumentException('Cardinality is not n..m:' + field.cardinality)
		}
		source = fu.getEntity(field)
		destination = field.entityReference
	}
	
	def getSource(){
		return this.source
	}
	
	def getDestination(){
		return this.destination
	}
	
	def getSrcDestStr(){
		return'''«source.name»_«destination.name»'''
	}
	
	def getTableName(){
		return '''«srcDestStr.toUpperCase»_TABLE'''
	}
	
	def getRelationName(){
		return '''«srcDestStr.toLowerCase»'''
	}
	
	

}