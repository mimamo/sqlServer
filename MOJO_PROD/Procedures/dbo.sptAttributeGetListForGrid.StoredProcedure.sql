USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeGetListForGrid]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeGetListForGrid]
		@Entity varchar(50),
		@EntityKey int

AS --Encrypt

	SELECT	a.*, av.AttributeValueKey, av.AttributeValue
	FROM	tAttribute a (nolock)
	LEFT JOIN tAttributeValue av (nolock) ON a.AttributeKey = av.AttributeKey
	WHERE	Entity = @Entity
	AND		EntityKey = @EntityKey
	ORDER BY a.DisplayOrder
	
	RETURN 1
GO
