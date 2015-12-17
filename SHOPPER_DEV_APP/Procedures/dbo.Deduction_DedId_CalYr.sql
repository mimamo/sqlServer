USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_DedId_CalYr]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Deduction_DedId_CalYr] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Select * from Deduction
           where DedId like @parm1
             and CalYr like @parm2
           order by DedId, CalYr
GO
