USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Benefit_ClassId]    Script Date: 12/21/2015 14:34:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Benefit_ClassId] @parm1 varchar ( 10) as
       Select * from Benefit
           where ClassId  LIKE  @parm1
           order by BenId
GO
