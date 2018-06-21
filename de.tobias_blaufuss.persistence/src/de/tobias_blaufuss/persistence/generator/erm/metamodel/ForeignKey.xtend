package de.tobias_blaufuss.persistence.generator.erm.metamodel

import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.Field
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.generator.erm.ISQLAlchemyGenerator
import de.tobias_blaufuss.persistence.generator.PythonConstants
import com.google.inject.Inject
import de.tobias_blaufuss.persistence.generator.FieldUtils

class ForeignKey implements ISQLAlchemyGenerator{
	private static FieldUtils fu = new FieldUtils
	
	String fkTargetColumn
	String fkConstraintName
	String sourceFkColumn
	
	new(EntityField field){
		this.fkTargetColumn = getFkTargetColumn(field.entityReference.name)
		this.fkConstraintName = getFkConstraintName(field)
		this.sourceFkColumn = getSourceFkColumn(field.name)
	}
	
	new(BackrefField field){
		this.fkTargetColumn = getFkTargetColumn((fu.getEntity(field.backref)).name)
		this.fkConstraintName = getFkConstraintName(field)
		this.sourceFkColumn = getSourceFkColumn(field.name)
	}
	
	private def getFkTargetColumn(String name){
		return '''«name.toLowerCase».«PythonConstants.ID_COLUMN_NAME»'''
	}
	
	private def getFkConstraintName(Field field){
		return '''«PythonConstants.FK_SIGN»_«(fu.getEntity(field)).name.toLowerCase»_«field.name.toLowerCase»'''
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