package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.generator.util.FieldUtils
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.NotNullOption
import de.tobias_blaufuss.persistence.persistence.PropertyField
import de.tobias_blaufuss.persistence.persistence.TypeOption
import de.tobias_blaufuss.persistence.persistence.UniqueOption
import java.util.Collection
import java.util.LinkedList
import de.tobias_blaufuss.persistence.persistence.BackrefField

final class ColumnAnnotation {
	extension FieldUtils = new FieldUtils
	extension JavaHibernateUtils = new JavaHibernateUtils
	
	Collection<TypeOption> options
	String columnName
	
	new(EntityField entityField){
		this.options = entityField.declaration.options
		this.columnName = entityField.columnName
	}
	
	new(PropertyField propertyField){
		this.options = propertyField.declaration.options
		this.columnName = propertyField.columnName
	}
	
	new(BackrefField backrefField){
		this.options = backrefField.declaration.options
		this.columnName = backrefField.columnName
	}
	
	private def getAttributes(){
		val result = new LinkedList
		result.add('''name = "«columnName»"''')
		for(option: options){
			switch option{
				UniqueOption: result.add('''unique = true''')
				NotNullOption: result.add('''nullable = false''')
			}
		}
		return result
	}
	
	def compile()'''
		@Column«IF !attributes.empty»(«ENDIF»
			«FOR attribute: attributes»
			«attribute»«IF attributes.last != attribute»,«ELSE»)«ENDIF»
			«ENDFOR»
	'''
}