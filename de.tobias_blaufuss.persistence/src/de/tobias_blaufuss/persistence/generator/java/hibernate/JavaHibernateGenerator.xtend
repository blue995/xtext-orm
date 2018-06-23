package de.tobias_blaufuss.persistence.generator.java.hibernate

import com.google.inject.Inject
import de.tobias_blaufuss.persistence.generator.util.EntityFieldUtils
import de.tobias_blaufuss.persistence.generator.util.EntityUtils
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
		«new ManyToOneRelationship(entityField).compile»
	'''
	
	def compileManyToManyEntityField(EntityField entityField)'''
		«new ManyToManyRelationship(entityField).compile»
	'''
	
	def compileBackrefField(BackrefField backrefField)'''
		«IF backrefField.cardinality == Cardinality.ONE_TO_MANY»
		«new OneToManyRelationship(backrefField).compile»
		«ENDIF»
		«IF backrefField.cardinality == Cardinality.MANY_TO_ONE»
		«new ManyToOneRelationship(backrefField).compile»
		«ENDIF»
		«IF backrefField.cardinality == Cardinality.MANY_TO_MANY»
		«new ManyToOneRelationship(backrefField).compile»
		«ENDIF»
	'''
}