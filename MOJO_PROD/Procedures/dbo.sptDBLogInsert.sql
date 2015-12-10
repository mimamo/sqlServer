USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDBLogInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDBLogInsert]
	@UserKey int,
	@Method varchar(50),
	@Parameters text
AS


Insert tDBLog (UserKey, Method, Parameters)
Values(@UserKey, @Method, @Parameters)


Return @@IDENTITY
GO
