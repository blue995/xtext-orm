/*
 * generated by Xtext 2.12.0
 */
package de.tobias_blaufuss.persistence.generator

import com.google.inject.Inject
import de.tobias_blaufuss.persistence.generator.python.sqlalchemy.SQLAlchemyGenerator
import de.tobias_blaufuss.persistence.persistence.PersistenceModel
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.AbstractGenerator
import org.eclipse.xtext.generator.IFileSystemAccess2
import org.eclipse.xtext.generator.IGeneratorContext
import de.tobias_blaufuss.persistence.generator.java.hibernate.JavaHibernateGenerator
import de.tobias_blaufuss.persistence.persistence.JavaConfiuration
import de.tobias_blaufuss.persistence.persistence.PythonConfiguration

/**
 * Generates code from your model files on save.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#code-generation
 */
class PersistenceGenerator extends AbstractGenerator {
	@Inject extension SQLAlchemyGenerator
	@Inject	extension JavaHibernateGenerator
	
	override void doGenerate(Resource resource, IFileSystemAccess2 fsa, IGeneratorContext context) {
		for (e : resource.allContents.toIterable.filter(PersistenceModel)) {
			for(c: e.configs.filter(JavaConfiuration)){
				switch c.orm {
					case HIBERNATE: e.compileHibernateModel(c, resource, fsa, context)
				}
			}
			for(c: e.configs.filter(PythonConfiguration)){
				switch c.orm {
					case SQLALCHEMY: e.compileSQLAlchemyModel(c, resource, fsa, context)
				}
			}
		}
	}
}
