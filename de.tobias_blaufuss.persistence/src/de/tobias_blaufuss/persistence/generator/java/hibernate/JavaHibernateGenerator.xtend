package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.persistence.PersistenceModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import de.tobias_blaufuss.persistence.persistence.Entity
import com.google.inject.Inject
import de.tobias_blaufuss.persistence.generator.util.EntityUtils
import de.tobias_blaufuss.persistence.persistence.PropertyField
import de.tobias_blaufuss.persistence.persistence.StringType
import de.tobias_blaufuss.persistence.persistence.IntegerType
import de.tobias_blaufuss.persistence.persistence.Type
import de.tobias_blaufuss.persistence.persistence.JavaConfiuration

class JavaHibernateGenerator {
	@Inject extension EntityUtils
	
	def compileHibernateModel(PersistenceModel model, JavaConfiuration config, Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context){
		val packageAsPath = config.pkg.replace('.', '/')
		val path = String.join('/', config.path, packageAsPath)
		for(entity: model.entities){
			fsa.generateFile('''«path»/«entity.name».java''', entity.compileEntity(config.pkg))
		}
	}
	
	def compileEntity(Entity entity, String pkg)'''
	package «pkg»;
	
	public class «entity.name» {
		// Properties
		«FOR propertField: entity.propertyFields»
		«propertField.compilePropertyField»
		«ENDFOR»
	}
	'''
	
	def compilePropertyField(PropertyField propertyField)'''
		private «propertyField.type.javaType» «propertyField.name»;
	'''
	
	def getJavaType(Type type){
		switch type {
			StringType: return String.name
			IntegerType: return Integer.name
		}
		
	}
}