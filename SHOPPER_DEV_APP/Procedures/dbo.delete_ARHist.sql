USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[delete_ARHist]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.delete_ARHist    Script Date: 4/7/98 12:30:34 PM ******/
Create PROC [dbo].[delete_ARHist] @parm1 varchar ( 4) As
        DELETE arhist FROM ARHist WHERE ARHist.FiscYr <= @parm1
GO
