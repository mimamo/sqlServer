USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Deduction_DedId]    Script Date: 12/21/2015 14:34:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Deduction_DedId] @parm1 varchar ( 10) as
       Select * from Deduction
           where DedId like @parm1
           order by DedId
GO
