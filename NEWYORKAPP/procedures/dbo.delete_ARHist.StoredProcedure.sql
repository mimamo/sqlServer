USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[delete_ARHist]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.delete_ARHist    Script Date: 4/7/98 12:30:34 PM ******/
Create PROC [dbo].[delete_ARHist] @parm1 varchar ( 4) As
        DELETE arhist FROM ARHist WHERE ARHist.FiscYr <= @parm1
GO
