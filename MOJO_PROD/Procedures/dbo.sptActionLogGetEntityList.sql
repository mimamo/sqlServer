USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActionLogGetEntityList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActionLogGetEntityList]

	(
		@Entity varchar(100),
		@EntityKey int,
		@CompanyKey int
	)

AS --Encrypt
 /*
  || When     Who Rel   What
  || 07/23/13 RLB 10570 (184730) Added CompanyKey
  */

Select *
From tActionLog (nolock) Where CompanyKey = @CompanyKey and Entity = @Entity and EntityKey = @EntityKey
Order By ActionDate DESC
GO
