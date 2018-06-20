/*
 * generated by Xtext 2.12.0
 */
package de.tobias_blaufuss.persistence

import org.eclipse.xtext.service.SingletonBinding
import de.tobias_blaufuss.persistence.generator.EntityFieldUtils
import de.tobias_blaufuss.persistence.generator.PersistenceModelUtils
import de.tobias_blaufuss.persistence.generator.EntityUtils

/**
 * Use this class to register components to be used at runtime / without the Equinox extension registry.
 */
class PersistenceRuntimeModule extends AbstractPersistenceRuntimeModule {
	@SingletonBinding
	def Class<EntityFieldUtils> bindEntityFieldUtils() {
		return EntityFieldUtils
	}
	
	@SingletonBinding
	def Class<PersistenceModelUtils> bindPersistenceModuleUtils() {
		return PersistenceModelUtils
	}
	
	@SingletonBinding
	def Class<EntityUtils> bindEntityUtils(){
		return EntityUtils
	}
}
