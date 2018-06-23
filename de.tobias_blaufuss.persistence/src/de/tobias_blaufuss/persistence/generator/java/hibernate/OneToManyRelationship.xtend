package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.generator.util.EntityFieldUtils
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField
import java.util.Collection
import de.tobias_blaufuss.persistence.generator.util.FieldUtils

class OneToManyRelationship extends Relationship{
	extension EntityFieldUtils = new EntityFieldUtils
	extension FieldUtils = new FieldUtils
	extension JavaHibernateUtils = new JavaHibernateUtils
	
	Boolean isBidirectional
	String mappedBy
	String mappingTarget
	
	new(EntityField entityField){
		super(entityField)
		this.isBidirectional = entityField.bidirectional
		if(this.isBidirectional){
			this.mappedBy = entityField.backrefField.name
		} else {
			this.mappingTarget = entityField.entity.idName
		}
	}
	
	new(BackrefField backrefField){
		super(backrefField)
		this.isBidirectional = true
		this.mappedBy = backrefField.backref.name
		this.mappingTarget = null
	}

	override appendAttributes(Collection<String> attributes) {
		if(isBidirectional){
			attributes.add('''mappedBy = "«mappedBy»"''')
		}
	}
	
	override appendAdditionalAnnotations(Collection<String> annotations) {
		if(isUnidirectional){
			annotations.add('''@JoinColumn(name = "«mappingTarget»")''')
		}	
	}
	
	def isUnidirectional(){
		return !isBidirectional
	}
}