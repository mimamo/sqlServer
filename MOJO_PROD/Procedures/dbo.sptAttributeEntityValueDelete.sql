USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAttributeEntityValueDelete]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptAttributeEntityValueDelete]

	(
		@Entity varchar(50),
		@EntityKey int
	)

AS --Encrypt


Delete 
	tAttributeEntityValue
Where
	Entity = @Entity and
	EntityKey = @EntityKey
GO
