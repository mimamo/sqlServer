USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[FreightAR_Descr]    Script Date: 12/21/2015 14:06:06 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[FreightAR_Descr] @parm1 varchar ( 10) as
    Select Descr from FrtTerms where FrtTermsID = @parm1 order by FrtTermsID
GO
