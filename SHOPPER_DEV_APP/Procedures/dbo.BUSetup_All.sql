USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BUSetup_All]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.BUSetup_All    Script Date: 11/4/99 12:38:58 PM ******/
CREATE PROCEDURE [dbo].[BUSetup_All]
@Parm1 varchar ( 10) AS
SELECT * FROM BUSetup WHERE CpnyID Like @Parm1
ORDER BY CpnyID
GO
