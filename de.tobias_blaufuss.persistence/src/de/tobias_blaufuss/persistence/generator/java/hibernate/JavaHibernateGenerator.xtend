package de.tobias_blaufuss.persistence.generator.java.hibernate

import com.google.inject.Inject
import de.tobias_blaufuss.persistence.generator.util.EntityFieldUtils
import de.tobias_blaufuss.persistence.generator.util.EntityUtils
import de.tobias_blaufuss.persistence.generator.util.FieldUtils
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.Cardinality
import de.tobias_blaufuss.persistence.persistence.Entity
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.JavaConfiuration
import de.tobias_blaufuss.persistence.persistence.PersistenceModel
import de.tobias_blaufuss.persistence.persistence.PropertyField
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext

class JavaHibernateGenerator {
	@Inject extension EntityUtils
	@Inject extension EntityFieldUtils
	@Inject extension FieldUtils
	@Inject extension JavaHibernateUtils
	
	def compileHibernateModel(PersistenceModel model, JavaConfiuration config, Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context){
		val packageAsPath = config.pkg.replace('.', '/')
		val path = String.join('/', config.path, packageAsPath)
		for(entity: model.entities){
			fsa.generateFile('''«path»/«entity.name».java''', entity.compileEntity(config.pkg))
		}
	}
	
	def compileEntity(Entity entity, String pkg)'''
	package «pkg»;
	
	import javax.persistence.*;
	import java.util.*;
	
	@Entity(name = "«entity.name»")
	@Table(name = "«entity.name.toUpperCase»")
	public class «entity.name» {
		@Id
		@GeneratedValue
		@Column(name = "«entity.idName»", nullable = false)
		private Long id;
		«IF entity.hasPropertyFields»
		
		// Properties
		«FOR propertField: entity.propertyFields»
		«propertField.compilePropertyField»
		
		«ENDFOR»
		«ENDIF»
		«IF entity.hasEntityFieldsOfCardinality(Cardinality.ONE_TO_MANY)»
		
		// 1..n Relationships
		«FOR entityField: entity.getEntityFieldsWithCardinality(Cardinality.ONE_TO_MANY)»
		«entityField.compileOneToManyEntityField»
		
		«ENDFOR»
		«ENDIF»
		«IF entity.hasEntityFieldsOfCardinality(Cardinality.MANY_TO_MANY)»
		
		// n..m Relationships
		«FOR entityField: entity.getEntityFieldsWithCardinality(Cardinality.MANY_TO_MANY)»
		«entityField.compileManyToManyEntityField»
		
		«ENDFOR»
		«ENDIF»
		«IF entity.hasEntityFieldsOfCardinality(Cardinality.MANY_TO_ONE)»
		
		// n..1 Relationships
		«FOR entityField: entity.getEntityFieldsWithCardinality(Cardinality.MANY_TO_ONE)»
		«entityField.compileManyToOneEntityField»
		
		«ENDFOR»
		«ENDIF»
		«IF entity.hasBackrefFields»
		
		// Back populations
		«FOR backrefField: entity.backrefFields»
		«backrefField.compileBackrefField»
		
		«ENDFOR»
		«ENDIF»
		
		«FOR field: entity.propertyFields»
		public «field.type.javaType» get«field.name.toFirstUpper»(){
			return this.«field.name»;
		}
		
		public void set«field.name.toFirstUpper»(«field.type.javaType» «field.name»){
			this.«field.name» = «field.name»;
		}
		
		«ENDFOR»
		«FOR field: entity.entityFields»
		public «field.compileType» get«field.name.toFirstUpper»(){
			return this.«field.name»;
		}

		public void set«field.name.toFirstUpper»(«field.compileType» «field.name»){
			this.«field.name» = «field.name»;
		}
		
		«ENDFOR»
		«FOR field: entity.backrefFields»
		public «field.compileType» get«field.name.toFirstUpper»(){
			return this.«field.name»;
		}

		public void set«field.name.toFirstUpper»(«field.compileType» «field.name»){
			this.«field.name» = «field.name»;
		}
		«ENDFOR»
	}
	'''
	
	def compilePropertyField(PropertyField propertyField)'''
		«new PropertyColumn(propertyField).compile»
	'''
	
	def compileOneToManyEntityField(EntityField entityField)'''
		«new OneToManyRelationship(entityField).compile»
	'''
	
	def compileManyToOneEntityField(EntityField entityField)'''
		«new ManyToOneRelationShip(entityField).compile»
	'''
	
	def compileManyToManyEntityField(EntityField entityField)'''
		@JoinTable(name = "«entityField.entity.name.columnName»_«entityField.entityName.columnName»", joinColumns = {
			@JoinColumn(name = "«entityField.entity.idName»", referencedColumnName = "«entityField.entity.idName»")}, inverseJoinColumns = {
			@JoinColumn(name = "«entityField.entityReference.idName»", referencedColumnName = "«entityField.entityReference.idName»")})
		@ManyToMany
		private Collection<«entityField.entityName»> «entityField.name»;
	'''
	
	def compileBackrefField(BackrefField backrefField)'''
		«IF backrefField.backref.cardinality == Cardinality.MANY_TO_ONE»
		«new OneToManyRelationship(backrefField).compile»
		«ENDIF»
		«IF backrefField.backref.cardinality == Cardinality.ONE_TO_MANY»
		«new ManyToOneRelationShip(backrefField).compile»
		«ENDIF»
	'''
	
	def compileType(EntityField entityField){
		if(entityField.cardinality.collection){
			return '''Collection<«entityField.entityName»>'''
		} else {
			return entityField.entityName
		}
	}
	
	def compileType(BackrefField backrefField){
		if(backrefField.cardinality.collection){
			return '''Collection<«backrefField.typeName»>'''
		} else {
			return backrefField.typeName
		}
	}

}