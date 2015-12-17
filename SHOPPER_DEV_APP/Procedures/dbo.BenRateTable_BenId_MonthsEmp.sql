USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[BenRateTable_BenId_MonthsEmp]    Script Date: 12/16/2015 15:55:14 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[BenRateTable_BenId_MonthsEmp] @parm1 varchar ( 10), @parm2beg smallint, @parm2end smallint as
       Select * from BenRateTable
           where BenId      =        @parm1
             and MonthsEmp  BETWEEN  @parm2beg and @parm2end
           order by BenId,
                    MonthsEmp
GO
