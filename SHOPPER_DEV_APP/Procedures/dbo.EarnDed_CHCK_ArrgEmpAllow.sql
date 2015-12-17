USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_CHCK_ArrgEmpAllow]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EarnDed_CHCK_ArrgEmpAllow]  @parm1 varchar (10), @parm2 varchar (4), @parm3 varchar (10) as
       Select ArrgEmpAllow from EarnDed
            where EmpId     = @parm1
              and CalYr     = @parm2
              and EarnDedId = @parm3
              and EDType    = "D"
GO
