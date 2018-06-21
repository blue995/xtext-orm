package de.tobias_blaufuss.persistence.generator

import de.tobias_blaufuss.persistence.persistence.Field
import de.tobias_blaufuss.persistence.persistence.FieldDeclaration
import de.tobias_blaufuss.persistence.persistence.Entity
import java.util.Collection
import de.tobias_blaufuss.persistence.persistence.TypeOption

class FieldUtils {
	def Collection<TypeOption> getTypeOptions(Field field){
		val declaration = field.declaration
		return declaration.options
	}
	
	def FieldDeclaration getDeclaration(Field field){
		return field.eContainer as FieldDeclaration
	}
	
	def Entity getEntity(Field field){
		val declaration = field.declaration
		println(declaration)
		val entity = declaration.eContainer as Entity
		println(entity)
		return entity
	}
}