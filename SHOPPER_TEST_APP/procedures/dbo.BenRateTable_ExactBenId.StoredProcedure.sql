USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenRateTable_ExactBenId]    Script Date: 12/21/2015 16:06:57 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenRateTable_ExactBenId] @parm1 varchar ( 10) as
       Select * from BenRateTable
           where BenId      =  @parm1
           order by BenId
GO
