USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDShipSetup_AllDMG]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDShipSetup_All    Script Date: 5/28/99 1:17:44 PM ******/
CREATE PROCEDURE [dbo].[EDShipSetup_AllDMG]
AS
select * from EDShipSetup
GO
