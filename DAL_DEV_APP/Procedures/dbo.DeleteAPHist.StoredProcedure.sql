USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[DeleteAPHist]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.DeleteAPHist    Script Date: 4/7/98 12:19:55 PM ******/
Create Procedure [dbo].[DeleteAPHist] @parm1 varchar ( 4) As
Delete aphist from APHist Where
FiscYr <= @parm1
GO
