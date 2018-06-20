package de.tobias_blaufuss.persistence.generator


import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.Entity

class ManyToManyMetadata {
	Entity destination
	Entity source
	new(EntityField field){
		if(field.cardinality != Cardinality.MANY_TO_MANY){
			throw new IllegalArgumentException('Cardinality is not n..m:' + field.cardinality)
		}
		source = field.eContainer as Entity
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