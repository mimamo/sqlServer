USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeDelete]
	@AttributeKey int

AS --Encrypt

Declare @Entity varchar(50), @EntityKey int, @DisplayOrder int

Select 
	@Entity = Entity, @EntityKey = EntityKey, @DisplayOrder = DisplayOrder
FROM tAttribute (nolock)
WHERE
	AttributeKey = @AttributeKey 
	
	DELETE tAttributeEntityValue
	From
		tAttributeValue
	WHERE
		tAttributeEntityValue.AttributeValueKey = tAttributeValue.AttributeValueKey and
		tAttributeValue.AttributeKey = @AttributeKey 

	DELETE
	FROM tAttributeValue
	WHERE
		AttributeKey = @AttributeKey 

	DELETE
	FROM tAttribute
	WHERE
		AttributeKey = @AttributeKey 
		
	Update tAttribute
	Set DisplayOrder = DisplayOrder - 1
	Where 
		Entity = @Entity and
		EntityKey = @EntityKey and
		DisplayOrder > @DisplayOrder

	RETURN 1
GO
