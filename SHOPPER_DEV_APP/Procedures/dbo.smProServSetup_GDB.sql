USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[smProServSetup_GDB]    Script Date: 12/16/2015 15:55:34 ******/
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
