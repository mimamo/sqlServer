USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkBenefit_BenId]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkBenefit_BenId] @parm1 varchar ( 10) as
       Select * from WrkBenefit
           where BenId  =  @parm1
           order by BenId
GO
