package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.persistence.PropertyField
import de.tobias_blaufuss.persistence.persistence.StringType
import de.tobias_blaufuss.persistence.generator.util.PersistenceModelUtils

class PropertyColumn{
	extension JavaHibernateUtils = new JavaHibernateUtils
	extension PersistenceModelUtils = new PersistenceModelUtils
	
	PropertyField propertyField
	ColumnAnnotation columnAnnotation
	
	new(PropertyField propertyField){
		this.propertyField = propertyField
		this.columnAnnotation = new ColumnAnnotation(propertyField)
	}
	
	def compile()'''
		«IF propertyField.type instanceof StringType»@Size(max = «(propertyField.type as StringType).resolveStringTypeCount»)«ENDIF»
		«columnAnnotation.compile»
		private «propertyField.type.javaType» «propertyField.name»;
	'''
}