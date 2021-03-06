USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeEntityValueGetViewList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeEntityValueGetViewList]

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
	av.AttributeValue
From
	tAttribute a (nolock)
	inner join tAttributeValue av (nolock) on a.AttributeKey = av.AttributeKey
	inner join tAttributeEntityValue aev (nolock) on av.AttributeValueKey = aev.AttributeValueKey
Where
	a.Entity = @AttributeEntity and
	a.EntityKey = @AttributeEntityKey and
	aev.Entity = @Entity and
	aev.EntityKey = @EntityKey
Order By a.DisplayOrder, av.AttributeValue
GO
