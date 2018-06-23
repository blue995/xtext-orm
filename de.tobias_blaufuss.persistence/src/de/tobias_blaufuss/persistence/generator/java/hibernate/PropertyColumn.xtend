package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.persistence.PropertyField

class PropertyColumn{
	extension JavaHibernateUtils = new JavaHibernateUtils
	
	PropertyField propertyField
	ColumnAnnotation columnAnnotation
	
	new(PropertyField propertyField){
		this.propertyField = propertyField
		this.columnAnnotation = new ColumnAnnotation(propertyField)
	}
	
	def compile()'''
		«columnAnnotation.compile»
		private «propertyField.type.javaType» «propertyField.name»;
	'''
}