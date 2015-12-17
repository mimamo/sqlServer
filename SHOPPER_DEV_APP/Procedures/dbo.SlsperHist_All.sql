USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SlsperHist_All]    Script Date: 12/16/2015 15:55:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.SlsperHist_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[SlsperHist_All] @parm1 varchar ( 10), @parm2 varchar ( 4) as
    Select * from SlsperHist where SlsperId like @parm1
           and FiscYr like @parm2 order by SlsperId, FiscYr
GO
