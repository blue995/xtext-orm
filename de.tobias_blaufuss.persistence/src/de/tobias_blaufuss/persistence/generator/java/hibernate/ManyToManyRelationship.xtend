package de.tobias_blaufuss.persistence.generator.java.hibernate

import de.tobias_blaufuss.persistence.persistence.BackrefField
import java.util.Collection
import de.tobias_blaufuss.persistence.persistence.EntityField
import de.tobias_blaufuss.persistence.generator.util.EntityFieldUtils
import de.tobias_blaufuss.persistence.generator.util.FieldUtils

class ManyToManyRelationship extends Relationship{
	extension JavaHibernateUtils = new JavaHibernateUtils
	extension EntityFieldUtils = new EntityFieldUtils
	extension FieldUtils = new FieldUtils
	
	String sourceIdColumn
	String sourceColumn
	String targetIdColumn
	String targetColumn
	Boolean isBidirectional
	Boolean isMappingSource
	String mappedBy
	
	new(BackrefField backrefField) {
		super(backrefField)
		sourceIdColumn = sourceColumn = targetIdColumn = targetColumn = null
		this.isBidirectional = true
		this.isMappingSource = false
		this.mappedBy = backrefField.backref.name
	}
	
	new(EntityField entityField){
		super(entityField)
		this.sourceIdColumn = entityField.entity.idName
		this.sourceColumn = entityField.entity.name.columnName
		this.targetIdColumn = entityField.entityReference.idName
		this.targetColumn = entityField.entityName.columnName
		
		this.isMappingSource = true
		this.isBidirectional = entityField.bidirectional
		this.mappedBy = null
	}
	
	override appendAttributes(Collection<String> attributes) {
		if(isMappingTarget){
			attributes.add('''mappedBy = "«mappedBy»"''')
		}
	}
	
	override appendAdditionalAnnotations(Collection<String> attributes) {
		if(isMappingSource){
			attributes.add('''
			@JoinTable(name = "«sourceColumn»_«targetColumn»", joinColumns = {
				@JoinColumn(name = "«sourceIdColumn»", referencedColumnName = "«sourceIdColumn»")}, inverseJoinColumns = {
				@JoinColumn(name = "«targetIdColumn»", referencedColumnName = "«targetIdColumn»")})
			''')
		}
	}
	
	private def isMappingTarget(){
		return isBidirectional && !isMappingSource
	}
	
}