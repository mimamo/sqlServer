USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadProjectSpecSheets]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadProjectSpecSheets]
	(
	@ProjectKey int
	)
AS

select * from tSpecSheet (nolock) Where Entity = 'Project' and EntityKey = @ProjectKey
Order By Subject
GO
