USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spProjectLoadProjectCreativeBrief]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spProjectLoadProjectCreativeBrief]
	(
	@ProjectKey int
	)
AS

select * from tProjectCreativeBrief (nolock) Where ProjectKey = @ProjectKey
GO
