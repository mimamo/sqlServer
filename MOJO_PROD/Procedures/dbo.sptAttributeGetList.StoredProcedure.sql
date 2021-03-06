USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeGetList]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeGetList]

	(
		@Entity varchar(50),
		@EntityKey int
	)

AS --Encrypt

Select * from tAttribute (nolock)
Where
	Entity = @Entity and
	EntityKey = @EntityKey
Order By
	DisplayOrder
GO
