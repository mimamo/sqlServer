USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlsTaxHist_TaxId_YrMon]    Script Date: 12/21/2015 14:17:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlsTaxHist_TaxId_YrMon    Script Date: 4/7/98 12:42:26 PM ******/
Create Proc [dbo].[SlsTaxHist_TaxId_YrMon] @parm1 varchar ( 10), @parm2 varchar ( 10), @parm3 varchar ( 6) as
           Select * from SlsTaxHist
                       where SlsTaxHist.TaxId = @parm2
					     and SlsTaxHist.CpnyId like @parm1
                         and SlsTaxHist.YrMon like @parm3
                       order by SlsTaxHist.TaxId , SlsTaxHist.CpnyId, SlsTaxHist.YrMon
GO
