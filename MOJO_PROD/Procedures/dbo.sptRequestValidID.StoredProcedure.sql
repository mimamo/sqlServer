USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptRequestValidID]    Script Date: 12/10/2015 12:30:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptRequestValidID]

	(
		@CompanyKey int,
		@ClientKey int,
		@RequestID varchar(50)
	)

AS

Declare @RequestKey int

Select @RequestKey = RequestKey
From tRequest (NOLOCK) 
Where
	CompanyKey = @CompanyKey and
	ClientKey = @ClientKey and
	RequestID = @RequestID and
	Status = 4
	
Return ISNULL(@RequestKey, 0)
GO
