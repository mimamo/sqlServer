USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityGetLinks]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityGetLinks]
	(
	@ActivityKey int
	)

AS


Select * from tActivityLink (nolock) Where ActivityKey = @ActivityKey
GO
