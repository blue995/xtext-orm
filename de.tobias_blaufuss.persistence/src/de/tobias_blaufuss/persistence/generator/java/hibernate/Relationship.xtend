package de.tobias_blaufuss.persistence.generator.java.hibernate

import java.util.LinkedList
import java.util.Collection
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.generator.util.EntityFieldUtils

abstract class Relationship {
	extension JavaHibernateUtils = new JavaHibernateUtils
	extension EntityFieldUtils = new EntityFieldUtils
	
	String variableName
	String type
	String annotationName
	
	new(EntityField entityField){
		this.variableName = entityField.name
		this.type = entityField.compileType
		this.annotationName = entityField.cardinality.compileRelationshipAnnotation
	}
	
	new(BackrefField backrefField){
		this.variableName = backrefField.name
		this.type = backrefField.compileType
		this.annotationName = backrefField.cardinality.compileRelationshipAnnotation
	}
	
	
	private def getAttributes(){
		val result = new LinkedList
		appendAttributes(result)
		return result
	}
	private def getAdditionalAnnotations(){
		val result = new LinkedList
		appendAdditionalAnnotations(result)
		return result
	}
	
	def void appendAttributes(Collection<String> attributes)
	def void appendAdditionalAnnotations(Collection<String> attributes)
	
	
	def compile()'''
		@«annotationName»«IF !attributes.empty»(«ENDIF»
			«FOR attribute: attributes»
			«attribute»«IF attributes.last != attribute»,«ELSE»)«ENDIF»
			«ENDFOR»
		«FOR a: additionalAnnotations»«a»«ENDFOR»
		private «type» «variableName»;
	'''
}