USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10550]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10550]

AS
	SET NOCOUNT ON

	update tSecurityGroup set SecurityLevel = 1

	RETURN 1
GO
