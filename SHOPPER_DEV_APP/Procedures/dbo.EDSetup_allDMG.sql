USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDSetup_allDMG]    Script Date: 12/16/2015 15:55:21 ******/
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
