USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Benefit_TrnsBenId_NEClassId]    Script Date: 12/21/2015 13:44:46 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[Benefit_TrnsBenId_NEClassId] @parm1 varchar ( 10), @parm2 varchar ( 10) as
       Select * from Benefit
           where TrnsBenId  =   @parm1
             and ClassId    <>  @parm2
           order by BenId
GO
