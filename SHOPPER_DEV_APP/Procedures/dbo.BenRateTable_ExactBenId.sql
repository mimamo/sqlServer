USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenRateTable_ExactBenId]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenRateTable_ExactBenId] @parm1 varchar ( 10) as
       Select * from BenRateTable
           where BenId      =  @parm1
           order by BenId
GO
