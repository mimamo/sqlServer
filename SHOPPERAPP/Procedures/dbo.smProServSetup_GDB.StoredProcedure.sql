USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[smProServSetup_GDB]    Script Date: 12/21/2015 16:13:25 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[smProServSetup_GDB]
AS
	SELECT HoursOprFromMi, HoursOprToMi
	FROM smProServSetup (nolock)
	WHERE SetupID = 'PROSETUP'
GO
