USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[APTmpChk_UPDT_Bat_ChkNbr_CPrt]    Script Date: 12/21/2015 14:17:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTmpChk_UPDT_Bat_ChkNbr_CPrt    Script Date: 4/7/98 12:19:55 PM ******/
Create Proc  [dbo].[APTmpChk_UPDT_Bat_ChkNbr_CPrt] @parm1 varchar ( 10), @parm2 smallint as
       Update APDoc
           Set  Selected   =   @parm2
           where BatNbr    =   @parm1
             and RefNbr    <>  ''
             and Selected  <>  @parm2
GO
