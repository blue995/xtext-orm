package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.persistence.Type
import de.tobias_blaufuss.persistence.persistence.StringType
import de.tobias_blaufuss.persistence.persistence.IntegerType
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.PropertyField
import de.tobias_blaufuss.persistence.persistence.Entity
import de.tobias_blaufuss.persistence.generator.util.EntityFieldUtils
import de.tobias_blaufuss.persistence.persistence.Cardinality

class JavaHibernateUtils {
	extension EntityFieldUtils = new EntityFieldUtils
	
	def getJavaType(Type type) {
		type.javaTypeClass.name
	}
	
	def Class<?> getJavaTypeClass(Type type){
		switch type {
			StringType: return String
			IntegerType: return Integer
		}
	}

	def getColumnName(BackrefField field) {
		return getColumnName(field.name)
	}

	def getColumnName(EntityField field) {
		return getColumnName(field.name)
	}

	def getColumnName(PropertyField field) {
		return getColumnName(field.name)
	}

	def getColumnName(String name) {
		return name.toUpperCase
	}

	def getIdName(Entity entity) {
		return getColumnName('''«entity.name.toUpperCase»_ID''')
	}
	
	def compileType(BackrefField backrefField){
		return backrefField.cardinality.compileType(backrefField.typeName)
	}
	
	def compileType(EntityField entityField){
		return entityField.cardinality.compileType(entityField.entityName)
	}
	
	def compileType(Cardinality cardinality, String typeName){
		if(cardinality.collection){
			return '''Collection<«typeName»>'''
		} else {
			return typeName
		}
	}
	
	def compileRelationshipAnnotation(Cardinality cardinality){
		switch cardinality {
			case MANY_TO_MANY: {
				return "ManyToMany"
			}
			case MANY_TO_ONE: {
				return "ManyToOne"
			}
			case ONE_TO_MANY: {
				return "OneToMany"
			}
			case ONE_TO_ONE: {
				return "OneToOne"
			}
			
		}
	}
}
