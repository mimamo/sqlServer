USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkBenefit_BenId]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[WrkBenefit_BenId] @parm1 varchar ( 10) as
       Select * from WrkBenefit
           where BenId  =  @parm1
           order by BenId
GO
