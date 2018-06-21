/*
 * generated by Xtext 2.12.0
 */
package de.tobias_blaufuss.persistence.validation

import com.google.inject.Inject
import de.tobias_blaufuss.persistence.generator.EntityUtils
import de.tobias_blaufuss.persistence.generator.FieldUtils
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.PersistencePackage
import org.eclipse.xtext.validation.Check

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class PersistenceValidator extends AbstractPersistenceValidator {
	@Inject extension FieldUtils
	@Inject extension EntityUtils
	
	@Check(FAST)
	def checkValidBackrefFieldType(BackrefField field){
		val entityOfField = field.entity
		val referencedEntity = field.backref.entityReference
		if(entityOfField != referencedEntity){
			error('''The type of the referenced field («referencedEntity.name») does not equal the type of this entity («entityOfField.name»)''', field, PersistencePackage.Literals.BACKREF_FIELD__BACKREF)
		}
		if(field.backref.unidirectional){
			error('''The referenced field must be specified as bidirectional.''', field, PersistencePackage.Literals.BACKREF_FIELD__BACKREF)
		}
	}
	
	@Check(FAST)
	def checkValidBidirectionalEntityFieldType(EntityField field){
		if(field.unidirectional) return
		
		val referencedEntity = field.entityReference
		val backrefField = referencedEntity.backrefFields.findFirst[bf | bf.backref == field]
		if(backrefField === null){
			error('''The referenced entity has no backref field to this entity field which indicates a unidirectional relationship. Change the relationship to unidirection or specify a backref field in the referenced entity.''', field, PersistencePackage.Literals.ENTITY_FIELD__ENTITY_REFERENCE)
		}
	}
	
	@Check(FAST)
	def checkValidUnidirectionalEntityFieldType(EntityField field){
		if(field.bidirectional) return
		
		val referencedEntity = field.entityReference
		val backrefField = referencedEntity.backrefFields.findFirst[bf | bf.backref == field]
		if(backrefField !== null){
			error('''The referenced entity specified a backref field to this entity field which indicates a bidirectional relationship. Change the relationship to bidirectional or remove the backref field of the referenced entity.''', field, PersistencePackage.Literals.ENTITY_FIELD__ENTITY_REFERENCE)
		}
	}
}
