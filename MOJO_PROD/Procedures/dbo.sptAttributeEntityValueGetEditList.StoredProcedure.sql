USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeEntityValueGetEditList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeEntityValueGetEditList]

	(
		@AttributeEntity varchar(50),
		@AttributeEntityKey int,
		@Entity varchar(50),
		@EntityKey int
	)

AS --Encrypt


Select
	a.AttributeKey,
	a.AttributeName,
	a.DisplayOrder,
	av.AttributeValueKey,
	av.AttributeValue,
	ISNULL((Select 1 from tAttributeEntityValue (nolock) Where AttributeValueKey = av.AttributeValueKey and Entity = @Entity and EntityKey = @EntityKey), 0) as Selected
From
	tAttribute a (nolock)
	inner join tAttributeValue av (nolock) on a.AttributeKey = av.AttributeKey
Where
	a.Entity = @AttributeEntity and
	a.EntityKey = @AttributeEntityKey
Order By a.DisplayOrder, av.AttributeValue
GO
