USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadProjectNotes]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadProjectNotes]
	(
	@ProjectKey int
	)
AS

select * from tProjectNote (nolock) Where ProjectKey = @ProjectKey
Order By ISNULL(DateUpdated, DateAdded)
GO
