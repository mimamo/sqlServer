USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[BenRateTable_BenId]    Script Date: 12/21/2015 13:44:46 ******/
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
