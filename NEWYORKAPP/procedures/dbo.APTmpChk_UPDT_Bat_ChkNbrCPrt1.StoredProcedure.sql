USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[APTmpChk_UPDT_Bat_ChkNbrCPrt1]    Script Date: 12/21/2015 16:00:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APTmpChk_UPDT_Bat_ChkNbrCPrt1    Script Date: 4/7/98 12:19:55 PM ******/
Create Proc  [dbo].[APTmpChk_UPDT_Bat_ChkNbrCPrt1] @parm1 varchar ( 10) as
       Update APDoc
           Set  BatNbr      =  ''      ,
                RefNbr          =  ''     ,
        Selected             =  0
           where BatNbr     =  @parm1
             and RefNbr         =  ''
GO
