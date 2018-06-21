package de.tobias_blaufuss.persistence.generator.python.sqlalchemy

import com.google.inject.Inject
import de.tobias_blaufuss.persistence.generator.python.PythonConstants
import de.tobias_blaufuss.persistence.generator.util.EntityFieldUtils
import de.tobias_blaufuss.persistence.generator.util.EntityUtils
import de.tobias_blaufuss.persistence.generator.util.PersistenceModelUtils
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.Entity
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.PersistenceModel
import de.tobias_blaufuss.persistence.persistence.PropertyField
import de.tobias_blaufuss.persistence.persistence.PythonConfiguration
import java.util.LinkedList
import java.util.regex.Pattern
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class SQLAlchemyGenerator {
	@Inject extension EntityFieldUtils
	@Inject extension PersistenceModelUtils
	@Inject extension EntityUtils
	
	def compileSQLAlchemyModel(PersistenceModel model, PythonConfiguration config, Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context){
		val path = compilePythonModules(config, fsa)
		fsa.generateFile('''«path»/«extractModuleName(config)».py''', model.compileSQLAlchemyModel)
	}
	
	def extractModuleName(PythonConfiguration config){
		return config.fileName.split(Pattern.quote(".")).last
	}
	
	def compilePythonModules(PythonConfiguration config, IFileSystemAccess2 fsa){
		val modules = new LinkedList
		modules.addAll(config.fileName.split(Pattern.quote(".")))
		val lastModule = modules.last
		modules.remove(lastModule)
		var basePath = config.path
		for(module : modules){
			basePath = String.join('/', basePath, module)
			generatePythonModule(basePath, module, fsa)
		}
		return basePath
	}
	
	def generatePythonModule(String path, String module, IFileSystemAccess2 fsa){
		fsa.generateFile('''«path»/__init__.py''', '')
	}
	
	
	def compileSQLAlchemyModel(PersistenceModel model)'''
		from app_vars import CONTAINER
		DB = CONTAINER.bundle.db
		
		«compileManyToManySecondaryTables(model)»
		
		«FOR entity : model.entities»
			class «entity.name»(DB.Model):
				__tablename__ = '«entity.name.toLowerCase»'
				id = DB.Column(DB.Integer, primary_key=True)
				
				«IF entity.hasPropertyFields»«PythonConstants.COMMENT» Attributes
				«FOR property: entity.propertyFields»
					«property.compilePropertyField»
				«ENDFOR»
				«ENDIF»
				«IF entity.hasEntityFieldsOfCardinality(Cardinality.ONE_TO_MANY)»
				
				«PythonConstants.COMMENT» Relationships: 1..n
				«FOR property: entity.getEntityFieldsWithCardinality(Cardinality.ONE_TO_MANY)»
					«property.compileEntityField»
				«ENDFOR»
				«ENDIF»
				«IF entity.hasEntityFieldsOfCardinality(Cardinality.MANY_TO_ONE)»
				
				«PythonConstants.COMMENT» Relationships: n..1
				«FOR property: entity.getEntityFieldsWithCardinality(Cardinality.MANY_TO_ONE)»
					«property.compileEntityField»
				«ENDFOR»
				«ENDIF»
				«IF entity.hasEntityFieldsOfCardinality(Cardinality.MANY_TO_MANY)»
				
				«PythonConstants.COMMENT» Relationships: n..m
				«FOR property: entity.getEntityFieldsWithCardinality(Cardinality.MANY_TO_MANY)»
				«property.compileEntityField»
				«ENDFOR»
				«ENDIF»
				«IF entity.hasBackrefFields»
				
				«PythonConstants.COMMENT» Backref
				«FOR backrefField: entity.backrefFields»
				«backrefField.compileBackrefField»
				«ENDFOR»
				«ENDIF»
				
				def get_id(self):
					return self.id
					
					
		«ENDFOR»
	'''
	
	def compilePropertyField(PropertyField property) '''
		«new Column(property).SQLAlchemyText»
	'''
	
	def compileBackrefField(BackrefField field)'''
		«new Column(field).SQLAlchemyText»
	'''
	
	def compileEntityField(EntityField field){
		return '''
		«IF field.cardinality == Cardinality.MANY_TO_ONE»
		«new Column(field).SQLAlchemyText»
		«ENDIF»
		«field.name» = DB.relationship('«field.entityName»'«field.compileEntityFieldOptions»)
		'''
	}
	
	def compileEntityFieldOptions(EntityField field){
		val result = new LinkedList
		if(field.hasBackrefField) result.add(''', backref='«field.backrefField.name»' ''')
		
		switch field.cardinality {
			case MANY_TO_ONE: result.add(''', foreign_keys=[«new ForeignKey(field).sourceFkColumn»]''')
			case MANY_TO_MANY: result.add(''', secondary=«new ManyToManyMetadata(field).tableName»''')
			default: {
			}
		}
		result.reduce[p1, p2| p1.concat(p2)]
	}



	def compileManyToManySecondaryTables(PersistenceModel model) {
		val manyToManyRelations = gatherFieldsWithCardinality(model, Cardinality.MANY_TO_MANY)
		val result = new LinkedList
		for (relation : manyToManyRelations) {
			val details = new ManyToManyMetadata(relation)
			result.add('''
				«details.tableName» = DB.Table('«details.relationName»', DB.Model.metadata,
														  «details.source.compileMergeTableRelationship»,
														  «details.destination.compileMergeTableRelationship»)
			''')
		}

		return '''
			«FOR str : result»
				«str»
				
			«ENDFOR»
		'''
	}

	def compileMergeTableRelationship(Entity entity) '''
		DB.Column('«entity.name.toLowerCase»_id',
				  DB.Integer,
				  DB.ForeignKey('«entity.name.toLowerCase».id'),
				  nullable=False)
	'''
}