USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_allDMG]    Script Date: 12/21/2015 14:17:43 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.EDSetup_all    Script Date: 5/28/99 1:17:44 PM ******/
CREATE PROCEDURE [dbo].[EDSetup_allDMG]
AS
 SELECT *
 FROM EDSetup
 ORDER BY SetUpID
GO
