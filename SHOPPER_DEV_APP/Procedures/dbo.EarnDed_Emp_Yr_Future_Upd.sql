USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_Emp_Yr_Future_Upd]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EarnDed_Emp_Yr_Future_Upd] @parm1 smallint, @parm2 smallint,@parm3 float, @parm4 float,
                                       @parm5 float, @parm6 float, @parm7 smallint,
                                       @parm8 varchar ( 10), @parm9 varchar ( 4), @parm10 varchar ( 10) as
       Update Earnded set NbrPersExmpt = @parm1,
                          NbrOthrExmpt = @parm2,
                          AddlExmptAmt = @parm3,
                          AddlCRAmt    = @parm4,
                          FxdPctRate   = @parm5,
                          CalMaxYTDDed = @parm6,
                          Exmpt        = @parm7
           where EmpId      =     @parm8
             and CalYr      >     @parm9
             and EDType     =     "D"
             and EarnDedId  =     @parm10
GO
