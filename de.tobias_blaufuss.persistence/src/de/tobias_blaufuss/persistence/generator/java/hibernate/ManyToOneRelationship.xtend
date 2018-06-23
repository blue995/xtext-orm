package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.generator.util.FieldUtils
import de.tobias_blaufuss.persistence.persistence.BackrefField
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.persistence.NotNullOption
import de.tobias_blaufuss.persistence.persistence.TypeOption
import java.util.Collection

class ManyToOneRelationship extends Relationship{
	extension JavaHibernateUtils = new JavaHibernateUtils
	extension FieldUtils = new FieldUtils
	
	String mappingTarget
	Collection<TypeOption> options
	
	new(EntityField entityField){
		super(entityField)
		this.mappingTarget = entityField.entityReference.idName
		this.options = entityField.declaration.options
	}
	
	new(BackrefField backrefField){
		super(backrefField)
		this.mappingTarget = backrefField.backref.entity.idName
		this.options = backrefField.declaration.options
	}
	
	override appendAttributes(Collection<String> attributes) {
		for(option: options){
			switch option{
				NotNullOption: attributes.add('''optional = false''')
			}
		}
	}
	
	override appendAdditionalAnnotations(Collection<String> annotations) {
		annotations.add('''@JoinColumn(name = "«mappingTarget»")''')
	}
}