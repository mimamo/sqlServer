USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EarnDed_UPDT_ArrgEmpAllow]    Script Date: 12/16/2015 15:55:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EarnDed_UPDT_ArrgEmpAllow] @parm1 varchar ( 10), @parm2 varchar ( 4) as
       Update EarnDed set ArrgEmpAllow = 0
           where EarnDedId =  @parm1
             and EDType    =  "D"
             and CalYr     =  @parm2
             and ArrgEmpAllow <> 0
GO
