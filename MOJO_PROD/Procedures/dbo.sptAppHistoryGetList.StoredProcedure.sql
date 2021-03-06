USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptAppHistoryGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptAppHistoryGetList]
(
	@CompanyKey int,
	@UserKey int,
	@Section varchar(50),
	@ActionID varchar(100)
)
as


	Select top 15 *, 1 as listIndex
	from vAppHistory (nolock)
	Where CompanyKey = @CompanyKey
	and UserKey = @UserKey
	and (@Section is null OR Section = @Section)
	and (@ActionID is null OR ActionID = @ActionID)
	Order By DateAdded DESC
GO
