USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenRateTable_BenId]    Script Date: 12/21/2015 15:36:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenRateTable_BenId] @parm1 varchar ( 10) as
       Select * from BenRateTable
           where BenId      LIKE  @parm1
           order by BenId         ,
                    MonthsEmp DESC
GO
