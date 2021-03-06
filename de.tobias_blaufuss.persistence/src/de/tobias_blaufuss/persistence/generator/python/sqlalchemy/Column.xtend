package de.tobias_blaufuss.persistence.generator.python.sqlalchemy

import de.tobias_blaufuss.persistence.persistence.Type
import de.tobias_blaufuss.persistence.persistence.PropertyField
import de.tobias_blaufuss.persistence.persistence.StringType
import de.tobias_blaufuss.persistence.persistence.IntegerType
import de.tobias_blaufuss.persistence.persistence.TypeOption
import java.util.List
import de.tobias_blaufuss.persistence.persistence.UniqueOption
import de.tobias_blaufuss.persistence.persistence.NotNullOption
import de.tobias_blaufuss.persistence.generator.python.PythonConstants
import de.tobias_blaufuss.persistence.generator.python.sqlalchemy.ISQLAlchemyGenerator
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.Field
import de.tobias_blaufuss.persistence.persistence.FieldDeclaration

class Column implements ISQLAlchemyGenerator{
	String columnName
	ForeignKey fk
	String typeText
	List<TypeOption> options
	
	new(String columnName, ForeignKey fk, String typeText, Field field){
		this.columnName = columnName
		this.fk = fk
		this.typeText = typeText
		this.options = (field.eContainer as FieldDeclaration).options
	}
	
	new(PropertyField field){
		this(field.name, null, field.type.compilePropertyType, field)
	}
	
	new(BackrefField field){
		this(new ForeignKey(field).sourceFkColumn, new ForeignKey(field), 'Integer', field)
	}
	
	new(EntityField field){
		this(new ForeignKey(field).sourceFkColumn, new ForeignKey(field), 'Integer', field)
	}
	
	private static def compilePropertyType(Type type) {
		switch type {
			StringType: return '''String(«compileStringTypeCount(type)»)'''
			IntegerType: return "Integer"
		}
	}
	
	private static def compileStringTypeCount(StringType stringType) {
		if (stringType.count <= 0) {
			return 50
		} else {
			return stringType.count
		}
	}
	
	private def compileFieldOptions(List<TypeOption> options) {
		if(options.empty) return ''
		return '''«FOR option : options», «option.compileTypeOption»«ENDFOR»'''
	}
	
	private def compileTypeOption(TypeOption option) {
		switch option {
			UniqueOption: return '''unique=«(if(option.unique) PythonConstants.TRUE else PythonConstants.FALSE)»'''
			NotNullOption: return '''nullable=«(if(option.notNull) PythonConstants.FALSE else PythonConstants.TRUE)»'''
		}
	}
	
	override getSQLAlchemyText() {
		val fkText = if(fk === null) '' else ''', «fk.SQLAlchemyText»'''
		return '''
		«columnName» = DB.Column(DB.«typeText»«fkText»«options.compileFieldOptions»)
		'''
	}
	
}