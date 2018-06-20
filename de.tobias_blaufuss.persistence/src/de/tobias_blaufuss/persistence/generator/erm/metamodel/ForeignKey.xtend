package de.tobias_blaufuss.persistence.generator.erm.metamodel

import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.Entity
import de.tobias_blaufuss.persistence.persistence.Field
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.generator.erm.ISQLAlchemyGenerator
import de.tobias_blaufuss.persistence.generator.PythonConstants

class ForeignKey implements ISQLAlchemyGenerator{
	String fkTargetColumn
	String fkConstraintName
	String sourceFkColumn
	
	new(EntityField field){
		this.fkTargetColumn = getFkTargetColumn(field.entityReference.name)
		this.fkConstraintName = getFkConstraintName(field)
		this.sourceFkColumn = getSourceFkColumn(field.name)
	}
	
	new(BackrefField field){
		this.fkTargetColumn = getFkTargetColumn((field.backref.eContainer as Entity).name)
		this.fkConstraintName = getFkConstraintName(field)
		this.sourceFkColumn = getSourceFkColumn(field.name)
	}
	
	private def getFkTargetColumn(String name){
		return '''«name.toLowerCase».«PythonConstants.ID_COLUMN_NAME»'''
	}
	
	private def getFkConstraintName(Field field){
		return '''«PythonConstants.FK_SIGN»_«(field.eContainer as Entity).name.toLowerCase»_«field.name.toLowerCase»'''
	}
	
	private def getSourceFkColumn(String name){
		return '''«name.toLowerCase»_«PythonConstants.ID_COLUMN_NAME»_«PythonConstants.FK_SIGN»'''
	}
	
	def getFkTargetColumn(){
		return this.fkTargetColumn
	}
	
	def getFkConstraintName(){
		return this.fkConstraintName
	}
	
	def getSourceFkColumn(){
		return this.sourceFkColumn
	}
	
	override getSQLAlchemyText() {
		return '''DB.ForeignKey('«fkTargetColumn»', name='«fkConstraintName»')'''
	}
	
}